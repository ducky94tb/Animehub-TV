import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/tvshow_detail.dart';
import 'package:movie/views/tvshow_detail_page/state.dart';

class MenuState implements Cloneable<MenuState> {
  int id;
  String backdropPic;
  String posterPic;
  String name;
  String overWatch;
  bool liked;
  TVDetailModel detail;

  @override
  MenuState clone() {
    return MenuState()
      ..liked = liked
      ..posterPic = posterPic
      ..backdropPic = backdropPic
      ..id = id
      ..overWatch = overWatch
      ..name = name
      ..detail = detail;
  }
}

class MenuConnector extends ConnOp<TvShowDetailState, MenuState> {
  @override
  MenuState get(TvShowDetailState state) {
    MenuState substate = new MenuState();
    substate.posterPic = state.tvDetailModel.posterPath;
    substate.name = state.tvDetailModel.name;
    substate.liked = state.liked;
    substate.id = state.tvid;
    substate.backdropPic = state.tvDetailModel.backdropPath;
    substate.overWatch = state.tvDetailModel.overview;
    substate.detail = state.tvDetailModel;
    return substate;
  }

  @override
  void set(TvShowDetailState state, MenuState subState) {
    state.liked = subState.liked;
  }
}
