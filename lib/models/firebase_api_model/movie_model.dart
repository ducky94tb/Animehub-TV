import 'dart:math';

class MovieModel {
  int id;
  String posterPath;
  String name;
  String overview;
  double voteAverage;
  String airDate;
  int views;
  String genres;

  MovieModel.fromParams(
      {this.id,
      this.posterPath,
      this.name,
      this.overview,
      this.genres,
      this.views,
      this.airDate,
      this.voteAverage});

  MovieModel.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    posterPath = data['posterPath'] != null ? data['posterPath'] : '';
    name = data['name'];
    overview = data['overview'];
    genres = data['genres'] ?? "-";
    views = data['views'] ?? 0;
    airDate = data['airDate'];
    voteAverage = data['voteAverage'] != null ? data['voteAverage'] * 1.0 : 0.0;
    if (voteAverage == 0) voteAverage = 5 + Random().nextInt(5) * 1.0;
  }

  @override
  String toString() {
    return name + posterPath;
  }
}
