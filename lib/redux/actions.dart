import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/app_state.dart';

String productUrl = 'http://10.0.2.2:1337/products';
/* User Actions */
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;

  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final User _user;
  GetUserAction(this._user);

  User get user => this._user;
}

/* User Actions */
ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  final response = await http.get(productUrl);
  final List<dynamic> respData = json.decode(response.body);
  store.dispatch(GetProductsAction(respData));
};

class GetProductsAction {
  final List<dynamic> _products;
  GetProductsAction(this._products);

  List<dynamic> get products => [...this._products];
}
