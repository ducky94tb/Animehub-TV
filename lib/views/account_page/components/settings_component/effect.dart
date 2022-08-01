import 'dart:convert' show json;
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action;
import 'package:flutter/material.dart' hide Action;
import 'package:in_app_review/in_app_review.dart';
import 'package:movie/actions/api/github_api.dart';
import 'package:movie/actions/api/tmdb_api.dart';
import 'package:movie/actions/app_language.dart';
import 'package:movie/actions/notification_topic.dart';
import 'package:movie/actions/version_comparison.dart';
import 'package:movie/generated/i18n.dart';
import 'package:movie/globalbasestate/action.dart';
import 'package:movie/globalbasestate/store.dart';
import 'package:movie/models/item.dart';
import 'package:movie/widgets/update_info_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'action.dart';
import 'state.dart';

Effect<SettingsState> buildEffect() {
  return combineEffects(<Object, Effect<SettingsState>>{
    SettingsAction.action: _onAction,
    SettingsAction.adultContentTapped: _adultContentTapped,
    SettingsAction.languageTap: _languageTap,
    SettingsAction.checkUpdate: _checkUpdate,
    SettingsAction.darkModeTap: _darkModeTap,
    SettingsAction.feedbackTap: _feedbackTap,
    SettingsAction.notificationsTap: _notificationsTap,
  });
}

void _onAction(Action action, Context<SettingsState> ctx) {}

void _adultContentTapped(Action action, Context<SettingsState> ctx) async {
  final _b = !(ctx.state.adultContent ?? false);
  ctx.dispatch(SettingsActionCreator.adultContentUpadte(_b));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('adultItems', _b);
  TMDBApi.instance.setAdultValue(_b);
}

Future _checkUpdate(Action action, Context<SettingsState> ctx) async {
  if (!Platform.isAndroid) return;

  //ctx.dispatch(SettingPageActionCreator.onLoading(true));
  final _github = GithubApi.instance;
  final _result = await _github.checkUpdate();
  if (_result.success) {
    final _shouldUpdate =
        VersionComparison().compare(ctx.state.version, _result.result.tagName);
    final _apk = _result.result.assets.singleWhere(
        (e) => e.contentType == 'application/vnd.android.package-archive');

    if (_apk != null && _shouldUpdate) {
      await showDialog(
        context: ctx.context,
        builder: (_) => UpdateInfoDialog(
          version: _result.result.tagName,
          describe: _result.result.body,
          packageSize: (_apk.size / 1048576),
          downloadUrl: _apk.browserDownloadUrl,
        ),
      );
    } else
      Toast.show('Already up to date', ctx.context);
  } else
    Toast.show(_result.message, ctx.context);
  //ctx.dispatch(SettingPageActionCreator.onLoading(false));
}

void _languageTap(Action action, Context<SettingsState> ctx) async {
  final Item _language = action.payload;
  if (_language.name == ctx.state.appLanguage.name) return;
  final Item _currentLanguage = ctx.state.appLanguage;
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  if (_language.name == 'System Default')
    _prefs.remove('appLanguage');
  else
    _prefs.setString('appLanguage', _language.toString());
  ctx.dispatch(SettingsActionCreator.setLanguage(_language));
  GlobalStore.store.dispatch(GlobalActionCreator.changeLocale(
      _language.value == null ? null : Locale(_language.value)));
  TMDBApi.instance.setLanguage(_language.value);
  if (ctx.state.enableNotifications) {
    final List<String> _topics = [];
    final List<String> _unsubscribetopics = [];

    String _movieTypeUsbcirbed = _prefs.getString('movieTypeSubscribed');
    String _tvTypeUsbcirbed = _prefs.getString('tvTypeSubscribed');

    final _movieGenres = (json.decode(_movieTypeUsbcirbed) as List)
        .where((e) => e['value'])
        .toList();
    final _tvGenres = (json.decode(_tvTypeUsbcirbed) as List)
        .where((e) => e['value'])
        .toList();

    _unsubscribetopics.addAll(_movieGenres
        .map((e) => 'movie_genre_${e['name']}_${_currentLanguage.value}')
        .toList());
    _unsubscribetopics.addAll(_tvGenres
        .map((e) => 'tvshow_genre_${e['name']}_${_currentLanguage.value}')
        .toList());
    _topics.addAll(_movieGenres
        .map((e) => 'movie_genre_${e['name']}_${_language.value}')
        .toList());
    _topics.addAll(_tvGenres
        .map((e) => 'tvshow_genre_${e['name']}_${_language.value}')
        .toList());

    NotificationTopic _topic = NotificationTopic();

    _topic.unsubscribeFromTopic(_unsubscribetopics);
    _topic.subscribeToTopic(_topics);
  }
}

void _darkModeTap(Action action, Context<SettingsState> ctx) async {
  final Item _darkMode = action.payload;
  print("Ducky $_darkMode");
  if (_darkMode.name == ctx.state.darkMode.name) return;
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString('darkMode', _darkMode.toString());
  ctx.dispatch(SettingsActionCreator.setDarkMode(_darkMode));
}

void _notificationsTap(Action action, Context<SettingsState> ctx) async {
  final _enable = ctx.state.enableNotifications;
  ctx.dispatch(SettingsActionCreator.notificationsUpdate(!_enable));
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setBool('enableNotifications', !_enable);
  final List<String> topics = [];
  final Item _language = await AppLanguage.instance.getApplanguage();
  String _movieTypeUsbcirbed = _prefs.getString('movieTypeSubscribed');
  String _tvTypeUsbcirbed = _prefs.getString('tvTypeSubscribed');
  final _movieGenres = (json.decode(_movieTypeUsbcirbed) as List)
      .where((e) => e['value'])
      .toList();
  final _tvGenres =
      (json.decode(_tvTypeUsbcirbed) as List).where((e) => e['value']).toList();
  topics.addAll(
      _movieGenres.map((e) => 'movie_genre_${e['name']}_${_language.value}'));
  topics.addAll(
      _tvGenres.map((e) => 'tvshow_genre_${e['name']}_${_language.value}'));
  NotificationTopic _topic = NotificationTopic();
  if (_enable)
    _topic.subscribeToTopic(topics);
  else
    _topic.unsubscribeFromTopic(topics);
}

void _feedbackTap(Action action, Context<SettingsState> ctx) async {
  showDialog(
    context: ctx.context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: new Text(I18n.of(ctx.context).feedback),
      content: new Text("Do you want to review via Store or send us Gmail?"),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Review"),
          onPressed: () =>
              {Navigator.of(context).pop(true), _openStoreListing()},
        ),
        CupertinoDialogAction(
            child: Text("Gmail"),
            isDestructiveAction: true,
            onPressed: () => {Navigator.of(context).pop(true), _sendEmail()})
      ],
    ),
  );
}

void _sendEmail() {
  AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      type: 'text/html',
      data: 'ducdv.bk94@gmail.com',
      arguments: {
        'android.intent.extra.SUBJECT': "Feedback about android app"
      });
  intent.launch();
}

void _openStoreListing() async {
  final InAppReview inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    inAppReview.openStoreListing();
  }
}
