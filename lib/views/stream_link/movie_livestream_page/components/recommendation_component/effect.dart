import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/animation.dart';
import 'package:movie/actions/api/tmdb_api.dart';
import 'package:movie/models/firebase/firebase_api.dart';
import 'package:movie/models/firebase_api_model/stream_link.dart';
import 'package:movie/models/models.dart';
import 'package:movie/views/stream_link/movie_livestream_page/action.dart';

import 'action.dart';
import 'state.dart';

Effect<RecommendationState> buildEffect() {
  return combineEffects(<Object, Effect<RecommendationState>>{
    RecommendationAction.action: _onAction,
    RecommendationAction.cellTap: _cellTap,
  });
}

void _onAction(Action action, Context<RecommendationState> ctx) {}

void _cellTap(Action action, Context<RecommendationState> ctx) async {
  final VideoListResult _movie = action.payload;
  ctx.state.controller.animateTo(0.0,
      duration: Duration(milliseconds: 300), curve: Curves.ease);
  ctx.dispatch(RecommendationActionCreator.setInfo(_movie));
  StreamLink _link = await FirebaseApi.instance.getMovieStreamLink(
    movieId: _movie.id,
    name: ctx.state.name,
  );
  ctx.dispatch(MovieLiveStreamActionCreator.setStreamLink(_link));
  ctx.dispatch(MovieLiveStreamActionCreator.setLoading(false));

  final _tmdb = TMDBApi.instance;
  _tmdb
      .getMovieDetail(_movie.id, appendtoresponse: 'recommendations,credits')
      .then((d) {
    if (d.success)
      ctx.dispatch(RecommendationActionCreator.setDetail(d.result));
  });
}
