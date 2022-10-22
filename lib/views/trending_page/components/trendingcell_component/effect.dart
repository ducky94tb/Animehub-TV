import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/database/database.dart';
import 'package:movie/models/database/favorite.dart';

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

void _onLikeTap(Action action, Context<TrendingCellState> ctx) async {
  final db = await AppDatabase.getInstance();
  final favoriteDao = db.favoriteDao;
  final data = ctx.state.cellData;
  final item = Favorite(null, data?.mediaType, data?.id,
      data?.name ?? data?.title, data.id, data.id, data?.posterPath);
  favoriteDao.addFavorite(item);
}
