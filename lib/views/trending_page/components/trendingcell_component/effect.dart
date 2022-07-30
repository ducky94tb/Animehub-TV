import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<TrendingCellState> buildEffect() {
  return combineEffects(<Object, Effect<TrendingCellState>>{
    TrendingCellAction.action: _onAction,
    TrendingCellAction.onLikeTap: _onLikeTap,
    Lifecycle.initState: _onInit,
  });
}

void _onAction(Action action, Context<TrendingCellState> ctx) {}

void _onInit(Action action, Context<TrendingCellState> ctx) async {}

void _onLikeTap(Action action, Context<TrendingCellState> ctx) async {}
