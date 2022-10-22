import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/globalbasestate/state.dart';
import 'package:movie/models/app_user.dart';
import 'package:movie/models/database/favorite.dart';
import 'package:palette_generator/palette_generator.dart';

class FavoritesPageState
    implements GlobalBaseState, Cloneable<FavoritesPageState> {
  Favorite selectedMedia;
  AnimationController animationController;
  PaletteGenerator paletteGenerator;
  List<Favorite> movies;
  List<Favorite> tvshows;
  bool isMovie;

  @override
  FavoritesPageState clone() {
    return FavoritesPageState()
      ..selectedMedia = selectedMedia
      ..animationController = animationController
      ..paletteGenerator = paletteGenerator
      ..isMovie = isMovie
      ..movies = movies
      ..tvshows = tvshows
      ..user = user;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

FavoritesPageState initState(Map<String, dynamic> args) {
  FavoritesPageState state = FavoritesPageState();
  state.isMovie = true;
  state.paletteGenerator = PaletteGenerator.fromColors([]);
  return state;
}
