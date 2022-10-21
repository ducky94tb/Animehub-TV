import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:movie/models/firebase_api_model/movie_model.dart';
import 'package:movie/models/firebase_api_model/tv_episode_model.dart';

import '../firebase_api_model/movie_info_model.dart';
import '../firebase_api_model/stream_link.dart';

class FirebaseApi {
  FirebaseApi._();

  static final FirebaseApi _instance = FirebaseApi._();

  static FirebaseApi get instance => _instance;

  //Report movie or tvShow error (streamlink not found or expired)
  Future<int> report(
      {String mediaType,
      int id,
      int tvSeasonId = 0,
      int tvEpisodeId = 0}) async {
    final db = FirebaseDatabase.instance;
    final animeHubRef = db.ref("AnimeHub/Report");
    switch (mediaType) {
      case "movie":
        final movieRef = animeHubRef.child("movie/$id");
        movieRef.set({
          'id': id,
        }).catchError((onError) => 0);
        break;
      default:
        final tvRef = animeHubRef.child("tv/${id}_${tvSeasonId}_$tvEpisodeId");
        tvRef.set({
          'id': id,
          'seasonId': tvSeasonId,
          'episode': tvEpisodeId,
        }).catchError((onError) => 0);
        break;
    }
    return 1;
  }

  Future<int> setMovieStreamLink({
    int movieId,
    String type,
    String streamLink,
    String language = 'en',
  }) async {
    final ref = FirebaseFirestore.instance
        .collection('movie')
        .doc('$movieId')
        .collection('link')
        .doc(language);
    await ref.set({
      'type': type,
      'url': streamLink,
    }).catchError((error) => 0);
    return 1;
  }

  Future<bool> getStatusReviewing(String version) async {
    final ref = FirebaseFirestore.instance.collection('version').doc(version);
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    Map<String, dynamic> data = snapshot.data();
    return data != null && data['reviewing'];
  }

  Future<Map<String, dynamic>> getConfigs() async {
    Map<String, dynamic> configs = Map();
    final ref = FirebaseFirestore.instance.collection('configs').doc('list');
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    configs.addAll(snapshot.data());
    return configs;
  }

  final List<TVEpisodeModel> listEp = [];
  final List<MovieModel> listMovie = [];
  DateTime lastQueryTv, lastQueryMovie;

  Future<List<TVEpisodeModel>> getNewestEpisodes(
      {bool forceRefresh = false}) async {
    var shouldRefresh = true;
    if (lastQueryTv != null) {
      final dd = lastQueryTv.add(Duration(minutes: 1));
      if (dd.isAfter(DateTime.now())) {
        shouldRefresh = false;
      }
    }
    if (forceRefresh && shouldRefresh) listEp.clear();
    if (listEp.length == 0) {
      final ref = FirebaseFirestore.instance.collection("latest/tvShow/en");
      final documents = await ref.get();
      lastQueryTv = DateTime.now();
      documents.docs.forEach((element) {
        if (element.data() != null) {
          listEp.add(TVEpisodeModel.fromJson(element.data()));
        }
      });
    }
    return listEp;
  }

  Future<List<MovieModel>> getNewestMovies({bool forceRefresh = false}) async {
    var shouldRefresh = true;
    if (lastQueryMovie != null) {
      final dd = lastQueryMovie.add(Duration(minutes: 1));
      if (dd.isAfter(DateTime.now())) {
        shouldRefresh = false;
      }
    }
    if (forceRefresh && shouldRefresh) listMovie.clear();
    if (listMovie.length == 0) {
      final ref = FirebaseFirestore.instance.collection("latest/movie/en");
      final documents = await ref.get();
      lastQueryMovie = DateTime.now();
      documents.docs.forEach((element) {
        if (element.data() != null) {
          listMovie.add(MovieModel.fromJson(element.data()));
        }
      });
    }
    return listMovie;
  }

  Future<int> setTvShowStreamLink({
    int tvId,
    int seasonId,
    int episodeId,
    String type,
    String streamLink,
    String language = 'en',
  }) async {
    final ref = FirebaseFirestore.instance
        .collection('tvshow')
        .doc('$tvId')
        .collection('season')
        .doc('$seasonId')
        .collection('episode')
        .doc('$episodeId')
        .collection('link')
        .doc(language);
    await ref.set({
      'type': type,
      'url': streamLink,
    }).catchError((error) => 0);
    return 1;
  }

  Future<StreamLink> getMovieStreamLink({
    int movieId,
    MovieInfoModel movieInfo,
  }) async {
    if (movieInfo == null)
      movieInfo = await getMovieInfo(movie: true, id: movieId);
    if (movieInfo == null || movieInfo.title == null) {
      //report this movie that it needs added title
      report(
        mediaType: 'movie',
        id: movieId,
      );
      return StreamLink.fromJson({});
    }
    final db = FirebaseDatabase.instance;
    final animeHubRef = db.ref("AnimeHub/Episode");
    final ref = animeHubRef.child("${movieInfo.title}/1");
    final snapshot = await ref.get();
    String streamLink = "";
    if (snapshot.value != null) {
      Map<Object, Object> data = snapshot.value;
      streamLink = data["streamLink"] ?? "";
      if (!streamLink.contains("https://")) {
        streamLink = "https://animixplay.to$streamLink";
      }
    }
    return StreamLink.fromParams(url: streamLink);
  }

  Future<void> updateViews({int movieId, int value = 1}) async {
    final ref = FirebaseFirestore.instance.collection('newest').doc('$movieId');
    final increase = FieldValue.increment(value);
    try {
      await ref.update({"views": increase});
    } on Exception catch (_) {}
  }

  Future<void> updateLikes({bool isMovie, int id, int value = 1}) async {
    final type = isMovie ? 'movie' : 'tvshow';
    final ref = FirebaseFirestore.instance
        .collection(type)
        .doc('$id')
        .collection("likes")
        .doc("count");
    final increase = FieldValue.increment(value);
    final snapshot = await ref.get();
    if (snapshot.exists)
      await ref.update({"number": increase});
    else
      await ref.set({"number": value > 0 ? value : 0});
  }

  Future<int> getLikes({bool isMovie, int id}) async {
    final type = isMovie ? 'movie' : 'tvshow';
    final ref = FirebaseFirestore.instance
        .collection(type)
        .doc('$id')
        .collection("likes")
        .doc("count");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return snapshot.data()['number'];
    }
    return 0;
  }

/*Future<List<CommentModel>> getComments({bool isMovie, int id}) async {
    final type = isMovie ? 'movie' : 'tvshow';
    final limitation = kDebugMode ? 25 : 15;
    final ref = FirebaseFirestore.instance
        .collection(type)
        .doc('$id')
        .collection("comments")
        .orderBy("createtime", descending: true)
        .limit(limitation);
    final snapshot = await ref.get();
    List<CommentModel> comments = [];
    snapshot.docs.forEach((element) {
      comments.add(CommentModel.fromJson(element.data()));
    });
    return comments;
  }*/

/*Future<void> addComment({bool isMovie, int id, CommentModel comment}) async {
    final type = isMovie ? 'movie' : 'tvshow';
    final ref = FirebaseFirestore.instance
        .collection(type)
        .doc('$id')
        .collection("comments");
    await ref.add(comment.toMap());
  }*/

  Future<StreamLink> getTvShowStreamLink({
    int tvId,
    int seasonId,
    int episodeId,
    MovieInfoModel movieInfo,
  }) async {
    if (movieInfo == null)
      movieInfo = await getMovieInfo(id: tvId, seasonId: seasonId);
    if (movieInfo == null || movieInfo.title == null) {
      //report this tvShow that it needs added title
      report(
          mediaType: 'tv',
          id: tvId,
          tvSeasonId: seasonId,
          tvEpisodeId: episodeId);
      return StreamLink.fromJson({});
    }
    int adjustNo = movieInfo.adjust;
    episodeId += adjustNo;
    if (episodeId < 1) episodeId = 1;
    final db = FirebaseDatabase.instance;
    final animeHubRef = db.ref("AnimeHub/Episode");
    final ref = animeHubRef.child("${movieInfo.title}/$episodeId");
    final snapshot = await ref.get();
    String streamLink = "";
    if (snapshot.value != null) {
      Map<Object, Object> data = snapshot.value;
      streamLink = data["streamLink"] ?? "";
      if (!streamLink.contains("https://")) {
        streamLink = "https://animixplay.to$streamLink";
      }
    }
    return StreamLink.fromParams(url: streamLink);
  }

  Future<MovieInfoModel> getMovieInfo(
      {bool movie = false, int id, int seasonId}) async {
    var ref;
    if (movie) {
      ref = FirebaseFirestore.instance
          .collection('movie')
          .doc('$id')
          .collection('movie_info')
          .doc('1');
    } else {
      ref = FirebaseFirestore.instance
          .collection('tvshow')
          .doc('$id')
          .collection('season')
          .doc('$seasonId')
          .collection('movie_info')
          .doc('$seasonId');
    }
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    Map<String, dynamic> data = snapshot.data();
    return MovieInfoModel.fromJson(data);
  }
}
