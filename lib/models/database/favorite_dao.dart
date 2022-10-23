// @dart=2.12

import 'package:floor/floor.dart';
import 'package:movie/models/database/favorite.dart';

@dao
abstract class FavoriteDao {
  @Query('SELECT * FROM Favorite')
  Future<List<Favorite>> findAllFavoriteList();

  @Query('SELECT * FROM Favorite WHERE mediaType = :mediaType')
  Future<List<Favorite>> findAllFavoriteListByMediaType(String mediaType);

  @Query(
      'SELECT * FROM Favorite WHERE animeId = :id AND mediaType = :mediaType')
  Future<Favorite?> findFavoriteItemById(int id, String mediaType);

  @insert
  Future<void> addFavorite(Favorite item);

  @delete
  Future<void> deleteFavorite(Favorite item);
}
