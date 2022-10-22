// @dart=2.12

import 'package:floor/floor.dart';
import 'package:movie/models/database/notificationfirebase.dart';

@dao
abstract class NotificationDao {
  @Query('SELECT * FROM NotificationFirebase ORDER BY timeStamp DESC')
  Future<List<NotificationFirebase>> findAllNotificationList();

  @Query('SELECT COUNT(id) FROM NotificationFirebase WHERE read = 0')
  Future<int?> getUnread();

  @Query('SELECT * FROM NotificationFirebase WHERE id = :id')
  Stream<NotificationFirebase?> findNotificationItemById(int id);

  @insert
  Future<void> addNotification(NotificationFirebase item);

  @update
  Future<void> updateRead(NotificationFirebase item);
}
