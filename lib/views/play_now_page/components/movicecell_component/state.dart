import 'package:fish_redux/fish_redux.dart';

class VideoCellState implements Cloneable<VideoCellState> {
  dynamic videodata;
  bool isMovie;

  @override
  VideoCellState clone() {
    return VideoCellState()
      ..videodata = videodata
      ..isMovie = isMovie;
  }
}

VideoCellState initState(Map<String, dynamic> args) {
  return VideoCellState();
}
