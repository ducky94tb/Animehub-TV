import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/firebase_api_model/stream_link.dart';
import 'package:movie/views/stream_link/movie_livestream_page/state.dart';
import 'package:movie/widgets/overlay_entry_manage.dart';

import 'components/comment_component/state.dart';

class BottomPanelState implements Cloneable<BottomPanelState> {
  String movieName;
  String preferHost;
  String defaultVideoLanguage;
  StreamLink selectedLink;
  CommentState commentState;
  GlobalKey<OverlayEntryManageState> overlayStateKey;
  bool useVideoSourceApi;
  bool streamInBrowser;
  bool userLiked;
  int likeCount;
  int movieId;
  int commentCount;
  @override
  BottomPanelState clone() {
    return BottomPanelState()
      ..movieName = movieName
      ..movieId = movieId
      ..userLiked = userLiked
      ..useVideoSourceApi = useVideoSourceApi
      ..streamInBrowser = streamInBrowser
      ..likeCount = likeCount
      ..selectedLink = selectedLink
      ..commentCount = commentCount
      ..commentState = commentState
      ..overlayStateKey = overlayStateKey
      ..preferHost = preferHost
      ..defaultVideoLanguage = defaultVideoLanguage;
  }
}

class BottomPanelConnector
    extends ConnOp<MovieLiveStreamState, BottomPanelState> {
  @override
  BottomPanelState get(MovieLiveStreamState state) {
    BottomPanelState mstate = state.bottomPanelState.clone();
    mstate.movieName = state.name;
    mstate.selectedLink = state.selectedLink;
    mstate.commentCount =
        state.bottomPanelState.commentState.comments?.totalCount ?? 0;
    return mstate;
  }

  @override
  void set(MovieLiveStreamState state, BottomPanelState subState) {
    state.bottomPanelState = subState;
    state.selectedLink = subState.selectedLink;
  }
}
