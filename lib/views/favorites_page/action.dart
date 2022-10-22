import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/database/favorite.dart';
import 'package:movie/models/video_list.dart';
import 'package:palette_generator/palette_generator.dart';

enum FavoritesPageAction {
  action,
  setFavoriteMovies,
  setFavoriteTV,
  setBackground,
  setColor,
  updateColor,
  setMovie,
  setTVShow,
}

class FavoritesPageActionCreator {
  static Action onAction() {
    return const Action(FavoritesPageAction.action);
  }

  static Action setFavoriteMovies(List<Favorite> d) {
    return Action(FavoritesPageAction.setFavoriteMovies, payload: d);
  }

  static Action setFavoriteTV(VideoListModel d) {
    return Action(FavoritesPageAction.setFavoriteTV, payload: d);
  }

  static Action setBackground(Favorite result) {
    return Action(FavoritesPageAction.setBackground, payload: result);
  }

  static Action setColor(String url) {
    return Action(FavoritesPageAction.setColor, payload: url);
  }

  static Action updateColor(PaletteGenerator palette) {
    return Action(FavoritesPageAction.updateColor, payload: palette);
  }

  static Action setMovie(List<Favorite> d) {
    return Action(FavoritesPageAction.setMovie, payload: d);
  }

  static Action setTVShow(List<Favorite> d) {
    return Action(FavoritesPageAction.setTVShow, payload: d);
  }
}
