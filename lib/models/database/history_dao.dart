// @dart=2.12

import 'package:floor/floor.dart';
import 'package:movie/models/database/history.dart';

@dao
abstract class HistoryDao {
  @Query('SELECT * FROM History ORDER BY timeStamp DESC LIMIT 500')
  Future<List<History>> findAllWatchedList();

  @Query('SELECT * FROM History WHERE id = :id')
  Stream<History?> findWatchedItemById(int id);

  @insert
  Future<void> addHistory(History item);
}
