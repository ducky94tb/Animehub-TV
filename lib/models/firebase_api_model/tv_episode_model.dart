import 'dart:math';

class TVEpisodeModel {
  int id;
  String epName;
  int episodeId;
  String posterPath;
  int seasonId;
  String seasonName;
  String tvName;
  String genres;
  double voteAverage;
  String airDate;
  int views;

  TVEpisodeModel.fromParams(
      {this.epName,
      this.id,
      this.episodeId,
      this.genres,
      this.posterPath,
      this.seasonId,
      this.seasonName,
      this.tvName,
      this.views,
      this.airDate,
      this.voteAverage});

  TVEpisodeModel.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    epName = data['epName'];
    episodeId = data['episodeId'];
    posterPath = data['posterPath'] ?? '';
    seasonId = data['seasonId'];
    tvName = data['tvName'];
    views = data['views'] ?? 0;
    genres = data['genres'] ?? '-';
    airDate = data['airDate'];
    voteAverage = data['voteAverage'] != null ? data['voteAverage'] * 1.0 : 0.0;
    if (voteAverage == 0) voteAverage = 5 + Random().nextInt(5) * 1.0;
  }

  @override
  String toString() {
    return tvName + posterPath;
  }
}
