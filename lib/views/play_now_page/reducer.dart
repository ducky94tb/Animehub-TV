import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PlayNowPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<PlayNowPageState>>{
      PlayNowPageAction.action: _onAction,
      PlayNowPageAction.loadData: _onLoadData,
      PlayNowPageAction.loadMore: _onLoadMore,
      PlayNowPageAction.busyChanged: _busyChanged,
    },
  );
}

PlayNowPageState _onAction(PlayNowPageState state, Action action) {
  final PlayNowPageState newState = state.clone();
  return newState;
}

PlayNowPageState _busyChanged(PlayNowPageState state, Action action) {
  final bool _isBusy = action.payload;
  final PlayNowPageState newState = state.clone();
  newState.isbusy = _isBusy;
  return newState;
}

PlayNowPageState _onLoadData(PlayNowPageState state, Action action) {
  final isMovie = action.payload[0];
  final list = action.payload[1];
  final PlayNowPageState newState = state.clone();
  if (isMovie) {
    newState.movieList = list;
  } else {
    newState.tvEpisodeList = list;
  }
  return newState;
}

PlayNowPageState _onLoadMore(PlayNowPageState state, Action action) {
  final PlayNowPageState newState = state.clone();
  return newState;
}
