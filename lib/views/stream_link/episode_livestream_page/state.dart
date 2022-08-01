import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/episode_model.dart';
import 'package:movie/models/firebase_api_model/stream_link.dart';
import 'package:movie/models/firebase_api_model/tv_episode_model.dart';
import 'package:movie/models/season_detail.dart';
import 'package:movie/views/stream_link/episode_livestream_page/components/bottom_panel_component/components/comment_component/state.dart';
import 'package:movie/views/stream_link/episode_livestream_page/components/bottom_panel_component/state.dart';
import 'package:movie/widgets/overlay_entry_manage.dart';

import 'components/player_component/state.dart';

class EpisodeLiveStreamState implements Cloneable<EpisodeLiveStreamState> {
  int tvid;
  String tvName;
  bool loading;
  StreamLink selectedLink;
  Episode selectedEpisode;
  Season season;
  ScrollController scrollController;
  PlayerState playerState;
  BottomPanelState bottomPanelState;

  TVEpisodeModel newestItem;

  @override
  EpisodeLiveStreamState clone() {
    return EpisodeLiveStreamState()
      ..loading = loading
      ..tvid = tvid
      ..tvName = tvName
      ..season = season
      ..selectedEpisode = selectedEpisode
      ..scrollController = scrollController
      ..playerState = playerState
      ..newestItem = newestItem
      ..bottomPanelState = bottomPanelState
      ..selectedLink = selectedLink;
  }
}

EpisodeLiveStreamState initState(Map<String, dynamic> args) {
  EpisodeLiveStreamState state = EpisodeLiveStreamState();
  state.tvid = args['tvid'];
  state.tvName = args['tvName'];
  state.season = args['season'];
  state.selectedEpisode = args['selectedEpisode'];
  state.newestItem = TVEpisodeModel.fromParams(
    id: state.tvid,
    seasonId: state.season.seasonNumber,
    episodeId: state.season.episodes.length,
    posterPath: state.season.posterPath,
    tvName: state.tvName,
  );
  state.bottomPanelState = BottomPanelState()
    ..overlayStateKey = GlobalKey<OverlayEntryManageState>()
    ..tvId = state.tvid
    ..season = state.season.seasonNumber
    ..useVideoSourceApi = true
    ..streamInBrowser = false
    ..commentState = CommentState()
    ..likeCount = 0
    ..userLiked = false;
  state.playerState = PlayerState()
    ..background = state.selectedEpisode.stillPath;
  state.loading = true;
  return state;
}
