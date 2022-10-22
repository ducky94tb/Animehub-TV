import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:movie/models/base_api_model/account_info.dart';

import '../../../../models/database/database.dart';
import 'action.dart';
import 'state.dart';

Effect<UserDataState> buildEffect() {
  return combineEffects(<Object, Effect<UserDataState>>{
    UserDataAction.action: _onAction,
    UserDataAction.navigatorPush: _navigatorPush,
    Lifecycle.initState: _onInit,
  });
}

void _onAction(Action action, Context<UserDataState> ctx) {}

void _onInit(Action action, Context<UserDataState> ctx) async {
  final db = await AppDatabase.getInstance();
  final historyDao = db.historyDao;
  final histories = await historyDao.findAllWatchedList();
  final info = AccountInfo.fromParams(watchLists: histories.length);
  ctx.dispatch(UserDataActionCreator.setInfo(info));
}

void _navigatorPush(Action action, Context<UserDataState> ctx) async {
  if (ctx.state.user?.firebaseUser == null)
    await _onLogin(action, ctx);
  else {
    String routerName = action.payload[0];
    Object data = action.payload[1];
    await Navigator.of(ctx.context).pushNamed(routerName, arguments: data);
  }
}

Future _onLogin(Action action, Context<UserDataState> ctx) async {
  await Navigator.of(ctx.context).pushNamed('loginpage');
}
