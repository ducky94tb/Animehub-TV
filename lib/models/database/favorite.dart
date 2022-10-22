// @dart=2.12

import 'package:floor/floor.dart';

@entity
class Favorite {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String mediaType;
  final int animeId;
  final String tvName;
  final int seasonId;
  final int episodeId;
  final String imageUrl;

  Favorite(this.id, this.mediaType, this.animeId, this.tvName, this.seasonId,
      this.episodeId, this.imageUrl);

  Favorite.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        imageUrl = res["imageUrl"],
        animeId = res["animeId"],
        episodeId = res["episodeId"],
        tvName = res["tvName"],
        seasonId = res["seasonId"],
        mediaType = res['mediaType'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tvName': tvName,
      'animeId': animeId,
      'mediaType': mediaType,
      'seasonId': seasonId,
      'episodeId': episodeId,
      'imageUrl': imageUrl
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
