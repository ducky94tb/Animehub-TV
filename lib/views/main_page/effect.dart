import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;
import 'package:in_app_update/in_app_update.dart';
import 'package:movie/actions/local_notification.dart';
import 'package:movie/models/notification_model.dart';
import 'package:movie/views/detail_page/page.dart';
import 'package:movie/views/tvshow_detail_page/page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'action.dart';
import 'state.dart';

Effect<MainPageState> buildEffect() {
  return combineEffects(<Object, Effect<MainPageState>>{
    MainPageAction.action: _onAction,
    Lifecycle.initState: _onInit,
  });
}

void _onAction(Action action, Context<MainPageState> ctx) {}

void _onInit(Action action, Context<MainPageState> ctx) async {
  final _localNotification = LocalNotification.instance;
  await _localNotification.init();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    _handleFirebaseMessage(message, _localNotification);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    _push(message.toMap(), ctx);
  });
  FirebaseMessaging.onBackgroundMessage(_handleFirebaseBackgroundMessage);
  await _checkAppUpdate(ctx);
}

void _handleFirebaseMessage(
    RemoteMessage message, LocalNotification localNotification) async {
  final _preferences = await SharedPreferences.getInstance();
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
  NotificationList _list;
  if (_preferences.containsKey('notifications')) {
    final String _notifications = _preferences.getString('notifications');
    _list = NotificationList(_notifications);
  }
  if (_list == null) _list = NotificationList.fromParams(notifications: []);
  final _notificationMessage = NotificationModel.fromMap(message.toMap());
  _list.notifications.add(_notificationMessage);
  _preferences.setString('notifications', _list.toString());
  localNotification.sendNotification(_notificationMessage.notification.title,
      _notificationMessage.notification?.body ?? '',
      id: int.parse(_notificationMessage.id),
      payload: _notificationMessage.type);
  print(_list.toString());
}

Future<void> _handleFirebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  final _localNotification = LocalNotification.instance;
  await _localNotification.init();
  final _preferences = await SharedPreferences.getInstance();
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
  NotificationList _list;
  if (_preferences.containsKey('notifications')) {
    final String _notifications = _preferences.getString('notifications');
    _list = NotificationList(_notifications);
  }
  if (_list == null) _list = NotificationList.fromParams(notifications: []);
  final _notificationMessage = NotificationModel.fromMap(message.toMap());
  _list.notifications.add(_notificationMessage);
  _preferences.setString('notifications', _list.toString());
  _localNotification.sendNotification(_notificationMessage.notification.title,
      _notificationMessage.notification?.body ?? '',
      id: int.parse(_notificationMessage.id),
      payload: _notificationMessage.type);
  print(_list.toString());
}

Future _push(Map<String, dynamic> message, Context<MainPageState> ctx) async {
  if (message != null) {
    final _notificationMessage = NotificationModel.fromMap(message);
    var data = {
      'id': int.parse(_notificationMessage.id.toString()),
      'bgpic': _notificationMessage.posterPic,
      'name': _notificationMessage.name,
      'posterpic': _notificationMessage.posterPic
    };
    Page page = _notificationMessage.type == 'movie'
        ? MovieDetailPage()
        : TvShowDetailPage();
    await Navigator.of(ctx.state.scaffoldKey.currentContext)
        .push(PageRouteBuilder(pageBuilder: (context, animation, secAnimation) {
      return FadeTransition(
        opacity: animation,
        child: page.buildPage(data),
      );
    }));
  }
}

Future _checkAppUpdate(Context<MainPageState> ctx) async {
  if (!Platform.isAndroid) return;
  InAppUpdate.checkForUpdate().then((info) {
    if (info?.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate();
    }
  }).catchError((e) {});
}
