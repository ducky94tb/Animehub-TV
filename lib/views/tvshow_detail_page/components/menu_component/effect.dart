import 'package:fish_redux/fish_redux.dart';
import 'package:movie/views/tvshow_detail_page/action.dart';

import '../../../../models/database/database.dart';
import '../../../../models/database/favorite.dart';
import 'action.dart';
import 'state.dart';

Effect<MenuState> buildEffect() {
  return combineEffects(<Object, Effect<MenuState>>{
    MenuAction.action: _onAction,
    MenuAction.setRating: _setRating,
    MenuAction.setFavorite: _setFavorite,
  });
}

void _onAction(Action action, Context<MenuState> ctx) {}

void _setFavorite(Action action, Context<MenuState> ctx) async {
  final bool _isFavorite = ctx.state.liked;
  final db = await AppDatabase.getInstance();
  final favoriteDao = db.favoriteDao;
  final data = ctx.state.detail;
  if (!ctx.state.liked) {
    final item = Favorite(null, data?.type, data?.id, data?.name,
        data?.voteAverage, data?.overview, data?.posterPath);
    favoriteDao.addFavorite(item);
  } else {
    final favItem =
        await favoriteDao.findFavoriteItemById(data?.id, data?.type);
    favoriteDao.deleteFavorite(favItem);
  }
  ctx.broadcast(TvShowDetailActionCreator.showSnackBar(!_isFavorite
      ? '${data?.name} has been mark as favorite'
      : '${data?.name} has been removed from your favorites'));
  ctx.dispatch(MenuActionCreator.updateFavorite(!_isFavorite));
}

Future _setRating(Action action, Context<MenuState> ctx) async {
  ctx.dispatch(MenuActionCreator.updateRating(action.payload));
  ctx.broadcast(
      TvShowDetailActionCreator.showSnackBar('your rating has been saved'));
}
