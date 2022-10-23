import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<DataPanelState> buildEffect() {
  return combineEffects(<Object, Effect<DataPanelState>>{
    DataPanelAction.action: _onAction,
    Lifecycle.initState: _onInit,
  });
}

void _onAction(Action action, Context<DataPanelState> ctx) {}
void _onInit(Action action, Context<DataPanelState> ctx) async {}
