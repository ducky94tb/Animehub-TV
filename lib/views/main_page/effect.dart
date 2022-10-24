import 'package:fish_redux/fish_redux.dart';
import 'package:movie/actions/local_notification.dart';

import 'action.dart';
import 'state.dart';

Effect<MainPageState> buildEffect() {
  return combineEffects(<Object, Effect<MainPageState>>{
    MainPageAction.action: _onAction,
    Lifecycle.initState: _onInit,
  });
}

void _onAction(Action action, Context<MainPageState> ctx) {}

void _onInit(Action action, Context<MainPageState> ctx) async {
  final _localNotification = LocalNotification.instance;
  await _localNotification.init();
}
