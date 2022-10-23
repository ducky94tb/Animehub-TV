import 'package:fish_redux/fish_redux.dart';

enum DataPanelAction { action }

class DataPanelActionCreator {
  static Action onAction() {
    return const Action(DataPanelAction.action);
  }
}
