import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_state.dart';

/* User Actions */
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user = storedUser != null ? json.decode(storedUser) : null;

  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final dynamic _user;
  GetUserAction(this._user);

  dynamic get user => this._user;
}