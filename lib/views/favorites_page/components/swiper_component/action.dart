import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/database/favorite.dart';

enum SwiperAction {
  action,
  mediaTpyeChanged,
  setBackground,
  cellTapped,
}

class SwiperActionCreator {
  static Action onAction() {
    return const Action(SwiperAction.action);
  }

  static Action mediaTpyeChanged(bool ismovie) {
    return Action(SwiperAction.mediaTpyeChanged, payload: ismovie);
  }

  static Action setBackground(Favorite result) {
    return Action(SwiperAction.setBackground, payload: result);
  }

  static Action cellTapped(Favorite media) {
    return Action(SwiperAction.cellTapped, payload: media);
  }
}
