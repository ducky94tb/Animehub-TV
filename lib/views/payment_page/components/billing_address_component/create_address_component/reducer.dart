import 'package:fish_redux/fish_redux.dart';
import 'package:movie/models/country_phone_code.dart';

import 'action.dart';
import 'state.dart';

Reducer<CreateAddressState> buildReducer() {
  return asReducer(
    <Object, Reducer<CreateAddressState>>{
      CreateAddressAction.action: _onAction,
      CreateAddressAction.setRegion: _setRegion
    },
  );
}

CreateAddressState _onAction(CreateAddressState state, Action action) {
  final CreateAddressState newState = state.clone();
  return newState;
}

CreateAddressState _setRegion(CreateAddressState state, Action action) {
  final CountryPhoneCode _region = action.payload;
  final CreateAddressState newState = state.clone();
  newState.region = _region;
  return newState;
}
