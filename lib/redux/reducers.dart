import 'package:e_commerce_packt/redux/actions.dart';

import '../models/app_state.dart';

AppState appReducer(state, action) {
  return AppState(
      user: userReducer(
    state.user,
    action,
  ));
}

userReducer(user, action) {
  if (action is GetUserAction) {
    //return user from action
    return action.user;
  }
  return user;
}
