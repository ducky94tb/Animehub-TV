import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/firebase_api_model/tv_episode_model.dart';
import 'package:movie/models/models.dart';
import 'package:movie/views/stream_link/episode_livestream_page/state.dart';

class PlayerState implements Cloneable<PlayerState> {
  String playerType;
  String streamLink;
  String background;
  int streamLinkId;
  bool useVideoSourceApi;
  bool streamInBrowser;
  bool needAd;
  bool loading;
  TVEpisodeModel newestItem;
  Episode episode;

  @override
  PlayerState clone() {
    return PlayerState()
      ..playerType = playerType
      ..streamLink = streamLink
      ..background = background
      ..useVideoSourceApi = useVideoSourceApi
      ..streamInBrowser = streamInBrowser
      ..needAd = needAd
      ..newestItem = newestItem
      ..loading = loading
      ..episode = episode;
  }
}

class PlayerConnector extends ConnOp<EpisodeLiveStreamState, PlayerState> {
  @override
  PlayerState get(EpisodeLiveStreamState state) {
    PlayerState mstate = state.playerState.clone();
    mstate.episode = state.selectedEpisode;
    mstate.loading = state.loading;
    mstate.newestItem = state.newestItem;
    mstate.background = state.selectedEpisode.stillPath;
    mstate.playerType = state.selectedLink?.type;
    mstate.streamLink = state.selectedLink?.url;
    return mstate;
  }

  @override
  void set(EpisodeLiveStreamState state, PlayerState subState) {
    state.playerState = subState;
  }
}
