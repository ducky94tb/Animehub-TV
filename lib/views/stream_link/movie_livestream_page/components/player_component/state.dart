import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/app_user.dart';
import 'package:movie/views/stream_link/movie_livestream_page/state.dart';

class PlayerState implements Cloneable<PlayerState> {
  String playerType;
  String streamLink;
  String background;
  AppUser user;
  int streamLinkId;
  bool useVideoSourceApi;
  bool streamInBrowser;
  bool needAd;
  bool loading;
  @override
  PlayerState clone() {
    return PlayerState()
      ..user = user
      ..playerType = playerType
      ..streamLink = streamLink
      ..background = background
      ..useVideoSourceApi = useVideoSourceApi
      ..streamInBrowser = streamInBrowser
      ..needAd = needAd
      ..loading = loading;
  }
}

class PlayerConnector extends ConnOp<MovieLiveStreamState, PlayerState> {
  @override
  PlayerState get(MovieLiveStreamState state) {
    PlayerState mstate = state.playerState.clone();
    mstate.useVideoSourceApi = state.bottomPanelState.useVideoSourceApi;
    mstate.streamInBrowser = state.bottomPanelState.streamInBrowser;
    mstate.background = state.background;
    mstate.loading = state.loading;
    mstate.user = state.user;
    mstate.playerType = state.selectedLink?.type;
    mstate.streamLink = state.selectedLink?.url;
    return mstate;
  }

  @override
  void set(MovieLiveStreamState state, PlayerState subState) {
    state.playerState = subState;
  }
}
