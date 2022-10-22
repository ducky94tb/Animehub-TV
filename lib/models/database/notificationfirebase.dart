// @dart=2.12

import 'package:floor/floor.dart';

@entity
class NotificationFirebase {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int tvId;
  final String title;
  final String description;
  final String tvName;
  final String timeStamp;
  final int seasonId;
  final int episodeId;
  final String imageUrl;
  bool read;

  NotificationFirebase(
      this.id,
      this.tvId,
      this.tvName,
      this.timeStamp,
      this.seasonId,
      this.episodeId,
      this.imageUrl,
      this.read,
      this.title,
      this.description);

  NotificationFirebase.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        imageUrl = res["imageUrl"],
        tvId = res["tvId"],
        episodeId = res["episodeId"],
        tvName = res["tvName"],
        seasonId = res["seasonId"],
        read = res["read"],
        title = res["title"],
        description = res["description"],
        timeStamp = res["timeStamp"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tvName': tvName,
      'tvId': tvId,
      'timeStamp': timeStamp,
      'seasonId': seasonId,
      'episodeId': episodeId,
      'read': read,
      'title': title,
      'description': description,
      'imageUrl': imageUrl
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
