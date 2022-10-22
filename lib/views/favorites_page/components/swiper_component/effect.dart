import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:movie/models/database/favorite.dart';

import 'action.dart';
import 'state.dart';

Effect<SwiperState> buildEffect() {
  return combineEffects(<Object, Effect<SwiperState>>{
    SwiperAction.action: _onAction,
    SwiperAction.cellTapped: _cellTapped,
  });
}

void _onAction(Action action, Context<SwiperState> ctx) {}

void _cellTapped(Action action, Context<SwiperState> ctx) async {
  final Favorite _media = action.payload;
  if (_media == null) return;
  final int _id = _media.animeId;
  final String title = _media.tvName;
  final String posterpic = _media.imageUrl;
  final String _pageName =
      _media.mediaType == 'movie' ? 'detailpage' : 'tvShowDetailPage';
  var _data = {
    'id': _id,
    'bgpic': posterpic,
    'name': title,
    'posterpic': posterpic
  };
  await Navigator.of(ctx.context).pushNamed(_pageName, arguments: _data);
}
