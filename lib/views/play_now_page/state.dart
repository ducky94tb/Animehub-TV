import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie/globalbasestate/state.dart';
import 'package:movie/models/app_user.dart';
import 'package:movie/models/firebase_api_model/movie_model.dart';
import 'package:movie/models/firebase_api_model/tv_episode_model.dart';
import 'package:movie/models/sort_condition.dart';
import 'package:movie/views/play_now_page/components/filter_component/state.dart';

import 'components/movicecell_component/state.dart';

class PlayNowPageState extends MutableSource
    implements GlobalBaseState, Cloneable<PlayNowPageState> {
  FilterState filterState;
  List<MovieModel> movieList;
  List<TVEpisodeModel> tvEpisodeList;
  ScrollController scrollController;
  GlobalKey stackKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  SortCondition selectedSort;
  bool sortDesc;
  bool isMovie;
  bool isbusy;
  double lVote;
  double rVote;
  List<SortCondition> currentGenres = [];

  @override
  PlayNowPageState clone() {
    return PlayNowPageState()
      ..filterState = filterState
      ..movieList = movieList
      ..tvEpisodeList = tvEpisodeList
      ..selectedSort = selectedSort
      ..scrollController = scrollController
      ..scaffoldKey = scaffoldKey
      ..stackKey = stackKey
      ..lVote = lVote
      ..rVote = rVote
      ..sortDesc = sortDesc
      ..isMovie = isMovie
      ..isbusy = isbusy
      ..currentGenres = currentGenres;
  }

  @override
  Color themeColor;

  @override
  Locale locale;

  @override
  AppUser user;

  @override
  Object getItemData(int index) => VideoCellState()
    ..videodata = isMovie ? movieList[index] : tvEpisodeList[index]
    ..isMovie = isMovie ?? true;

  @override
  String getItemType(int index) => 'moviecell';

  @override
  int get itemCount => isMovie ? movieList.length : tvEpisodeList.length;

  @override
  void setItemData(int index, Object data) {}
}

PlayNowPageState initState(Map<String, dynamic> args) {
  final PlayNowPageState state = PlayNowPageState();
  state.filterState = new FilterState();
  state.filterState.selectedSort = state.filterState.sortTypes[0];
  state.selectedSort = state.filterState.sortTypes[0];
  state.currentGenres = state.filterState.currentGenres;
  state.scaffoldKey = GlobalKey();
  state.stackKey = GlobalKey();
  state.sortDesc = true;
  state.isMovie = true;
  state.isbusy = false;
  state.lVote = 0.0;
  state.rVote = 10.0;
  state.tvEpisodeList = [];
  state.movieList = [];
  return state;
}
