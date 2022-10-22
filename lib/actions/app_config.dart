import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/firebase/firebase_api.dart';

class AppConfig {
  AppConfig._();

  static final AppConfig instance = AppConfig._();

  dynamic _config;

  String get theMovieDBHostV3 => _config['theMovieDBHostV3'];

  String get theMovieDBHostV4 => _config['theMovieDBHostV4'];

  String get theMovieDBApiKeyV3 => _config['theMovieDBApiKeyV3'];

  String get theMovieDBApiKeyV4 => _config['theMovieDBApiKeyV4'];

  String get baseApiHost => _config['baseApiHost'];

  String get graphQLHttpLink => _config['graphQLHttpLink'];

  String get graphQlWebSocketLink => _config['graphQlWebSocketLink'];

  String get urlresolverApiHost => _config['urlresolverApiHost'];

  String get urlresolverApiKey => _config['urlresolverApiKey'];

  bool _reviewing = false;
  bool get reviewing => _reviewing;

  Future init(BuildContext context) async {
    final _jsonStr = await _getConfigJson(context);
    if (_jsonStr == null) {
      print('can not find config file');
      return;
    }
    _config = json.decode(_jsonStr);
    await getReviewStatus();
  }

  Future getReviewStatus() async {
    final _packageInfo = await PackageInfo.fromPlatform();
    final version = _packageInfo?.version ?? '-';
    final prefs = await SharedPreferences.getInstance();
    final key = "${version}_reviewing";
    if (!prefs.containsKey(key) || prefs.getBool(key)) {
      _reviewing = await FirebaseApi.instance.getStatusReviewing(version);
      await prefs.setBool(key, _reviewing);
      print("Ducky on reviewing $_reviewing");
    }
  }
}

Future<String> _getConfigJson(BuildContext context) async {
  try {
    final _jsonStr =
        await DefaultAssetBundle.of(context).loadString("appconfig.json");
    return _jsonStr;
  } on Exception catch (_) {
    return null;
  }
}
