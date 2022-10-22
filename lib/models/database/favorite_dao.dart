// @dart=2.12

import 'package:floor/floor.dart';
import 'package:movie/models/database/favorite.dart';

@dao
abstract class FavoriteDao {
  @Query('SELECT * FROM Favorite')
  Future<List<Favorite>> findAllFavoriteList();

  @Query('SELECT * FROM Favorite WHERE mediaType = :mediaType')
  Future<List<Favorite>> findAllFavoriteListByMediaType(String mediaType);

  @insert
  Future<void> addFavorite(Favorite item);
}
