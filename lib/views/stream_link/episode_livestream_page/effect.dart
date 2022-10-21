import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:movie/actions/api/base_api.dart';
import 'package:movie/models/firebase/firebase_api.dart';
import 'package:movie/models/firebase_api_model/stream_link.dart';
import 'package:movie/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'action.dart';
import 'state.dart';

Effect<EpisodeLiveStreamState> buildEffect() {
  return combineEffects(<Object, Effect<EpisodeLiveStreamState>>{
    EpisodeLiveStreamAction.action: _onAction,
    EpisodeLiveStreamAction.episodeTapped: _episodeTapped,
    EpisodeLiveStreamAction.markWatched: _markWatched,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<EpisodeLiveStreamState> ctx) {}

void _episodeTapped(Action action, Context<EpisodeLiveStreamState> ctx) async {
  final Episode _episode = action.payload;
  if (_episode == null ||
      _episode.episodeNumber == ctx.state.selectedEpisode.episodeNumber) return;
  ctx.state.scrollController.animateTo(0.0,
      duration: Duration(milliseconds: 300), curve: Curves.ease);
  StreamLink _link = await FirebaseApi.instance.getTvShowStreamLink(
      tvId: ctx.state.tvid,
      seasonId: ctx.state.season.seasonNumber,
      episodeId: _episode.episodeNumber);
  ctx.dispatch(
      EpisodeLiveStreamActionCreator.setSelectedEpisode(_episode, _link));
  await _getLike(action, ctx);
  await _getComment(action, ctx);
}

void _onInit(Action action, Context<EpisodeLiveStreamState> ctx) async {
  ctx.state.scrollController = ScrollController();
  StreamLink _link = await FirebaseApi.instance.getTvShowStreamLink(
    tvId: ctx.state.tvid,
    seasonId: ctx.state.season.seasonNumber,
    episodeId: ctx.state.selectedEpisode.episodeNumber,
    movieInfo: ctx.state.movieInfo,
  );
  ctx.dispatch(EpisodeLiveStreamActionCreator.setStreamLink(_link));
  ctx.dispatch(EpisodeLiveStreamActionCreator.setLoading(false));
}

void _onDispose(Action action, Context<EpisodeLiveStreamState> ctx) {
  ctx.state.scrollController.dispose();
}

Future _getComment(Action action, Context<EpisodeLiveStreamState> ctx) async {
  final _comment = await BaseApi.instance.getTvShowComments(
      ctx.state.tvid,
      ctx.state.selectedEpisode.seasonNumber,
      ctx.state.selectedEpisode.episodeNumber);
  if (_comment.success)
    ctx.dispatch(EpisodeLiveStreamActionCreator.setComment(_comment.result));
}

Future _getLike(Action action, Context<EpisodeLiveStreamState> ctx) async {}

Future<TvShowStreamLinks> _sortStreamLink(TvShowStreamLinks links) async {
  List<TvShowStreamLink> _lists = links.list;
  final _pre = await SharedPreferences.getInstance();
  if (_pre.containsKey('defaultVideoLanguage')) {
    final _defaultVideoLanguage = _pre.getString('defaultVideoLanguage');
    final _languageList =
        _lists.where((e) => e.language.code == _defaultVideoLanguage).toList();
    if (_languageList.length > 0) {
      for (var d in _languageList) links.list.remove(d);
      links.list.insertAll(0, _languageList);
    }
  }
  if (_pre.containsKey('preferHost')) {
    final _preferHost = _pre.getString('preferHost');
    final _hostList =
        _lists.where((e) => e.streamLink.contains(_preferHost)).toList();
    if (_hostList.length > 0) {
      for (var d in _hostList) links.list.remove(d);
      links.list.insertAll(0, _hostList);
    }
  }
  return links;
}

void _markWatched(Action action, Context<EpisodeLiveStreamState> ctx) async {
  final _pre = await SharedPreferences.getInstance();
  final _episode = action.payload as Episode;
  final index = ctx.state.season.episodes.indexOf(_episode);
  if (ctx.state.season.playStates[index] != '1') {
    ctx.state.season.playStates[index] = '1';
    _episode.playState = true;
    _pre.setStringList(
        'TvSeason${ctx.state.season.id}', ctx.state.season.playStates);
  }
}
