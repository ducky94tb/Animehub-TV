// @dart=2.12

// required package imports
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:movie/models/database/favorite.dart';
import 'package:movie/models/database/favorite_dao.dart';
import 'package:movie/models/database/history.dart';
import 'package:movie/models/database/history_dao.dart';
import 'package:movie/models/database/notification_dao.dart';
import 'package:movie/models/database/notificationfirebase.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [History, NotificationFirebase, Favorite])
abstract class AppDatabase extends FloorDatabase {
  HistoryDao get historyDao;

  NotificationDao get notificationDao;

  FavoriteDao get favoriteDao;

  static Future<AppDatabase> getInstance() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
