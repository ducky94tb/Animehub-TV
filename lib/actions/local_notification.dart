import 'package:common_utils/common_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/database/database.dart';
import '../models/database/notificationfirebase.dart';

class LocalNotification {
  LocalNotification._();

  static final LocalNotification instance = LocalNotification._();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future init() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessage(message);
    });
  }

  Future<void> handleMessage(RemoteMessage message) async {
    final db = await AppDatabase.getInstance();
    final notificationDao = db.notificationDao;
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      final data = message.data;
      int tvId = int.tryParse(data['tvId']) ?? 1;
      int seasonId = int.tryParse(data['seasonId']) ?? 1;
      int epId = int.tryParse(data['epId']) ?? 1;
      final timeStamp =
          DateUtil.formatDate(DateTime.now(), format: DateFormats.full);
      final item = NotificationFirebase(null, tvId, '', timeStamp, seasonId,
          epId, android.imageUrl, false, notification.title, notification.body);
      notificationDao.addNotification(item);
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'mipmap/ic_launcher',
          ),
        ),
      );
    }
  }
}
