import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'app.dart';
import 'models/base_api_model/ads_config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp();
  AdsConfig.instance.initialize();
  final FirebaseAnalytics analytics =
      FirebaseAnalytics.instanceFor(app: firebaseApp);
  await FlutterDownloader.initialize();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(App());
}
