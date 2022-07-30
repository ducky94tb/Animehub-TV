import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:movie/globalbasestate/state.dart';
import 'package:movie/models/app_user.dart';

class CastListState implements GlobalBaseState, Cloneable<CastListState> {
  @override
  CastListState clone() {
    return CastListState()
      ..user = user
      ..locale = locale;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

CastListState initState(Map<String, dynamic> args) {
  return CastListState();
}
