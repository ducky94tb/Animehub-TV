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

void _onInit(Action action, Context<TrendingCellState> ctx) async {
  final db = await AppDatabase.getInstance();
  final favoriteDao = db.favoriteDao;
  final data = ctx.state.cellData;
  final favItem =
      await favoriteDao.findFavoriteItemById(data?.id, data?.mediaType);
  if (favItem == null) {
    ctx.dispatch(TrendingCellActionCreator.setLiked(false, ctx.state.index));
  } else {
    ctx.dispatch(TrendingCellActionCreator.setLiked(true, ctx.state.index));
  }
}

void _onLikeTap(Action action, Context<TrendingCellState> ctx) async {
  final db = await AppDatabase.getInstance();
  final favoriteDao = db.favoriteDao;
  final data = ctx.state.cellData;
  if (!ctx.state.liked) {
    final item = Favorite(
        null,
        data?.mediaType,
        data?.id,
        data?.name ?? data?.title,
        data?.voteAverage,
        data?.overview,
        data?.posterPath);
    favoriteDao.addFavorite(item);
    ctx.dispatch(TrendingCellActionCreator.setLiked(true, ctx.state.index));
  } else {
    final favItem =
        await favoriteDao.findFavoriteItemById(data?.id, data?.mediaType);
    favoriteDao.deleteFavorite(favItem);
    ctx.dispatch(TrendingCellActionCreator.setLiked(false, ctx.state.index));
  }
}
