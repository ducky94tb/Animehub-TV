// @dart=2.12

import 'package:floor/floor.dart';

@entity
class Favorite {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String mediaType;
  final int animeId;
  final String tvName;
  final String overview;
  final String imageUrl;

  double rating;

  Favorite(this.id, this.mediaType, this.animeId, this.tvName, this.rating,
      this.overview, this.imageUrl);

  Favorite.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        imageUrl = res["imageUrl"],
        animeId = res["animeId"],
        rating = res["rating"],
        tvName = res["tvName"],
        overview = res["overview"],
        mediaType = res['mediaType'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tvName': tvName,
      'animeId': animeId,
      'mediaType': mediaType,
      'overview': overview,
      'rating': rating,
      'imageUrl': imageUrl
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
