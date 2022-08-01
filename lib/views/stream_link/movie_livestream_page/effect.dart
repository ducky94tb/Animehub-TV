import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:movie/actions/api/base_api.dart';
import 'package:movie/models/firebase/firebase_api.dart';
import 'package:movie/models/firebase_api_model/stream_link.dart';

import 'action.dart';
import 'state.dart';

Effect<MovieLiveStreamState> buildEffect() {
  return combineEffects(<Object, Effect<MovieLiveStreamState>>{
    MovieLiveStreamAction.action: _onAction,
    MovieLiveStreamAction.getLike: _getLike,
    MovieLiveStreamAction.getComment: _getComment,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<MovieLiveStreamState> ctx) {}

void _onInit(Action action, Context<MovieLiveStreamState> ctx) async {
  ctx.state.scrollController = ScrollController();
  //ctx.dispatch(MovieLiveStreamActionCreator.setLoading(true));
  StreamLink _link =
      await FirebaseApi.instance.getMovieStreamLink(movieId: ctx.state.movieId);
  ctx.dispatch(MovieLiveStreamActionCreator.setStreamLink(_link));
  ctx.dispatch(MovieLiveStreamActionCreator.setLoading(false));
}

void _onDispose(Action action, Context<MovieLiveStreamState> ctx) {
  ctx.state.scrollController.dispose();
}

Future _getComment(Action action, Context<MovieLiveStreamState> ctx) async {
  final _comment = await BaseApi.instance.getMovieComments(ctx.state.movieId);
  if (_comment.success)
    ctx.dispatch(MovieLiveStreamActionCreator.setComment(_comment.result));
}

Future _getLike(Action action, Context<MovieLiveStreamState> ctx) async {}
