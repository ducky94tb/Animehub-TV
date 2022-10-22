import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:movie/actions/api/tmdb_api.dart';
import 'package:movie/models/episode_model.dart';

import 'action.dart';
import 'state.dart';

Effect<PlayNowPageState> buildEffect() {
  return combineEffects(<Object, Effect<PlayNowPageState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    PlayNowPageAction.action: _onAction,
    PlayNowPageAction.videoCellTapped: _onVideoCellTapped,
    PlayNowPageAction.refreshData: _onLoadData,
    PlayNowPageAction.mediaTypeChange: _mediaTypeChange,
    PlayNowPageAction.filterTap: _filterTap,
    PlayNowPageAction.applyFilter: _applyFilter,
  });
}

void _onAction(Action action, Context<PlayNowPageState> ctx) {}

Future _onInit(Action action, Context<PlayNowPageState> ctx) async {
  ctx.state.scrollController = ScrollController();
  ctx.state.filterState.keyWordController = TextEditingController();
  ctx.state.scrollController.addListener(() async {
    bool isBottom = ctx.state.scrollController.position.pixels ==
        ctx.state.scrollController.position.maxScrollExtent;
    if (isBottom) {
      await _onLoadMore(action, ctx);
    }
  });
  await _onLoadData(action, ctx);
}

void _onDispose(Action action, Context<PlayNowPageState> ctx) {
  ctx.state.scrollController.dispose();
  ctx.state.filterState.keyWordController.dispose();
}

Future _onLoadData(Action action, Context<PlayNowPageState> ctx) async {
  ctx.dispatch(PlayNowPageActionCreator.onBusyChanged(true));
  /*final _genres = ctx.state.currentGenres;
  var genresIds = _genres.where((e) => e.isSelected).map<int>((e) {
    return e.value;
  }).toList();
  ResponseModel<VideoListModel> r;
  String _sortBy = ctx.state.selectedSort == null
      ? null
      : '${ctx.state.selectedSort.value}${ctx.state.sortDesc ? '.desc' : '.asc'}';
  final _tmdb = TMDBApi.instance;*/
  // final _firebase = FirebaseApi.instance;
  // dynamic resultList;
  // if (ctx.state.isMovie)
  //   resultList = await _firebase.getNewestMovies();
  // else
  //   resultList = await _firebase.getNewestEpisodes();
  //
  // if (resultList.length != 0)
  //   ctx.dispatch(
  //       PlayNowPageActionCreator.onLoadData(resultList, ctx.state.isMovie));
  //
  // ctx.dispatch(PlayNowPageActionCreator.onBusyChanged(false));
  // ctx.state.scrollController?.jumpTo(0);
}

Future _onVideoCellTapped(Action action, Context<PlayNowPageState> ctx) async {
  if (ctx.state.isMovie)
    await Navigator.of(ctx.context).pushNamed(
      'detailpage',
      arguments: {'id': action.payload[0], 'bgpic': action.payload[1]},
    );
  else {
    final id = action.payload[0];
    final seasonId = action.payload[2];
    final episodeId = action.payload[3];
    final tvName = action.payload[4];
    final res = await TMDBApi.instance.getTVSeasonDetail(id, seasonId);
    if (res.success) {
      if (res.success) {
        final season = res.result;
        final Episode episode = season.episodes
            .firstWhere((element) => element.episodeNumber == episodeId);
        await Navigator.of(ctx.context).pushNamed(
          'episodeLiveStreamPage',
          arguments: {
            'tvid': id,
            'tvName': tvName,
            'selectedEpisode': episode,
            'season': season
          },
        );
      }
    }
  }
}

Future _onLoadMore(Action action, Context<PlayNowPageState> ctx) async {
  /*if (ctx.state.isbusy) return;
  ctx.dispatch(PlayNowPageActionCreator.onBusyChanged(true));
  final _genres = ctx.state.filterState.currentGenres;
  var genresIds = _genres.where((e) => e.isSelected).map<int>((e) {
    return e.value;
  }).toList();
  ResponseModel<VideoListModel> r;
  String _sortBy = ctx.state.selectedSort == null
      ? null
      : '${ctx.state.selectedSort?.value ?? ''}${ctx.state.filterState.sortDesc ? '.desc' : '.asc'}';
  final _tmdb = TMDBApi.instance;
  if (ctx.state.isMovie)
    r = await _tmdb.getMovieDiscover(
      voteAverageGte: ctx.state.lVote,
      voteAverageLte: ctx.state.rVote,
      page: ctx.state.videoListModel.page + 1,
      sortBy: _sortBy,
      withGenres: genresIds.length > 0 ? genresIds.join(',') : null,
    );
  else
    r = await _tmdb.getTVDiscover(
        voteAverageGte: ctx.state.lVote,
        voteAverageLte: ctx.state.rVote,
        page: ctx.state.videoListModel.page + 1,
        sortBy: _sortBy,
        withGenres: genresIds.length > 0 ? genresIds.join(',') : null,
        withKeywords: ctx.state.filterState.keywords);
  if (r.success)
    ctx.dispatch(PlayNowPageActionCreator.onLoadMore(r.result.results));
  ctx.dispatch(PlayNowPageActionCreator.onBusyChanged(false));*/
}

Future _mediaTypeChange(Action action, Context<PlayNowPageState> ctx) async {
  final bool _isMovie = action.payload ?? true;
  if (ctx.state.isMovie == _isMovie) return;
  ctx.state.isMovie = _isMovie;
  ctx.state.currentGenres = _isMovie
      ? ctx.state.filterState.movieGenres
      : ctx.state.filterState.tvGenres;
  await _onLoadData(action, ctx);
}

void _filterTap(Action action, Context<PlayNowPageState> ctx) async {
  ctx.state.filterState.isMovie = ctx.state.isMovie;
  ctx.state.filterState.selectedSort = ctx.state.selectedSort;
  ctx.state.filterState.currentGenres = ctx.state.currentGenres;
  ctx.state.filterState.lVote = ctx.state.lVote;
  ctx.state.filterState.rVote = ctx.state.rVote;
  Navigator.of(ctx.context)
      .push(PageRouteBuilder(pageBuilder: (_, animation, ___) {
    return SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
        child: FadeTransition(
            opacity: animation, child: ctx.buildComponent('filter')));
  }));
}

void _applyFilter(Action action, Context<PlayNowPageState> ctx) {
  ctx.state.currentGenres = ctx.state.filterState.currentGenres;
  ctx.state.selectedSort = ctx.state.filterState.selectedSort;
  ctx.state.sortDesc = ctx.state.filterState.sortDesc;
  ctx.state.isMovie = ctx.state.filterState.isMovie;
  ctx.state.lVote = ctx.state.filterState.lVote;
  ctx.state.rVote = ctx.state.filterState.rVote;
  _onLoadData(action, ctx);
}
