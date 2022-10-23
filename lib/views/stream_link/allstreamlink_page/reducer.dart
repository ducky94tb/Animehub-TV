import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/models.dart';

import 'action.dart';
import 'state.dart';

Reducer<AllStreamLinkPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<AllStreamLinkPageState>>{
      AllStreamLinkPageAction.action: _onAction,
      AllStreamLinkPageAction.initMovieList: _initMovieList,
      AllStreamLinkPageAction.loadMoreMovies: _loadMoreMovies,
      AllStreamLinkPageAction.initTvShowList: _initTvShowList,
      AllStreamLinkPageAction.loadMoreTvShows: _loadMoreTvShows,
    },
  );
}

AllStreamLinkPageState _onAction(AllStreamLinkPageState state, Action action) {
  final AllStreamLinkPageState newState = state.clone();
  return newState;
}

AllStreamLinkPageState _loadMoreMovies(
    AllStreamLinkPageState state, Action action) {
  final VideoListModel _list = action.payload;
  final AllStreamLinkPageState newState = state.clone();
  if (_list != null) {
    newState.movieList.page = _list.page;
    newState.movieList.results.addAll(
        _list?.results?.where((element) => element?.genreIds?.contains(16)) ??
            []);
  }
  return newState;
}

AllStreamLinkPageState _loadMoreTvShows(
    AllStreamLinkPageState state, Action action) {
  final VideoListModel _list = action.payload;
  final AllStreamLinkPageState newState = state.clone();
  if (_list != null) {
    newState.tvList.page = _list.page;
    newState.tvList.results.addAll(
        _list?.results?.where((element) => element?.genreIds?.contains(16)) ??
            []);
  }
  return newState;
}

AllStreamLinkPageState _initMovieList(
    AllStreamLinkPageState state, Action action) {
  final VideoListModel _list = action.payload;
  _list.results = _list.results
      .where((element) => element?.genreIds?.contains(16))
      .toList();
  final AllStreamLinkPageState newState = state.clone();
  newState.movieList = _list;
  return newState;
}

AllStreamLinkPageState _initTvShowList(
    AllStreamLinkPageState state, Action action) {
  VideoListModel _list = action.payload;
  _list.results = _list.results
      .where((element) => element?.genreIds?.contains(16))
      .toList();
  final AllStreamLinkPageState newState = state.clone();
  newState.tvList = _list;
  return newState;
}
