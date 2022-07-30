import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:movie/actions/api/base_api.dart';
import 'package:movie/globalbasestate/store.dart';
import 'package:toast/toast.dart';

import 'action.dart';
import 'state.dart';

Effect<CommentState> buildEffect() {
  return combineEffects(<Object, Effect<CommentState>>{
    CommentAction.action: _onAction,
    CommentAction.addComment: _addComment,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<CommentState> ctx) {}

void _onInit(Action action, Context<CommentState> ctx) {
  ctx.state.scrollController = ScrollController()
    ..addListener(() {
      if (ctx.state.scrollController.position.pixels ==
          ctx.state.scrollController.position.maxScrollExtent) {
        _loadMore(action, ctx);
      }
    });
  ctx.state.isBusy = false;
}

void _onDispose(Action action, Context<CommentState> ctx) {
  ctx.state.scrollController?.dispose();
}

void _addComment(Action action, Context<CommentState> ctx) async {
  final String _commentTxt = action.payload;
  final _user = GlobalStore.store.getState().user;
  if (_user == null) {
    Toast.show('login before comment', ctx.context, duration: 2);
    return;
  }
}

void _loadMore(Action action, Context<CommentState> ctx) async {
  if (!ctx.state.isBusy) {
    ctx.state.isBusy = true;
    final _baseApi = BaseApi.instance;
    final _comment = await _baseApi.getMovieComments(ctx.state.movieId,
        page: ctx.state.comments.page + 1);
    if (_comment.success) {
      if (_comment.result.data.length > 0)
        ctx.dispatch(CommentActionCreator.loadMore(_comment.result));
    }

    ctx.state.isBusy = false;
  }
}
