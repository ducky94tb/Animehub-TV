// @dart=2.12

import 'package:floor/floor.dart';

@entity
class History {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int tvId;
  final String tvName;
  final String timeStamp;
  final int seasonId;
  final int episodeId;
  final String imageUrl;

  History(this.id, this.tvId, this.tvName, this.timeStamp, this.seasonId,
      this.episodeId, this.imageUrl);

  History.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        imageUrl = res["imageUrl"],
        tvId = res["tvId"],
        episodeId = res["episodeId"],
        tvName = res["tvName"],
        seasonId = res["seasonId"],
        timeStamp = res["timeStamp"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tvName': tvName,
      'tvId': tvId,
      'timeStamp': timeStamp,
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
