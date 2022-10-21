import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:movie/models/firebase/firebase_api.dart';
import 'package:movie/models/firebase_api_model/movie_info_model.dart';
import 'package:movie/models/season_detail.dart';

import 'action.dart';
import 'state.dart';

Effect<SeasonState> buildEffect() {
  return combineEffects(<Object, Effect<SeasonState>>{
    SeasonAction.action: _onAction,
    SeasonAction.cellTapped: _cellTapped,
  });
}

void _onAction(Action action, Context<SeasonState> ctx) {}

void _cellTapped(Action action, Context<SeasonState> ctx) async {
  final Season _season = action.payload;
  MovieInfoModel movieInfoModel = await FirebaseApi.instance.getMovieInfo(
    id: ctx.state.tvid,
    seasonId: _season.seasonNumber,
  );
  if (_season == null) return;
  await Navigator.of(ctx.context).pushNamed('seasondetailpage', arguments: {
    'tvid': ctx.state.tvid,
    'seasonNumber': _season.seasonNumber,
    'tvShowName': ctx.state.name,
    'seasonName': _season.name,
    'posterpic': _season.posterPath,
    'movieInfo': movieInfoModel,
  });
}
