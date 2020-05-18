import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_state.dart';
import '../models/product.dart';
import '../models/user.dart';

String productUrl = 'http://10.0.2.2:1337/products';
/* User Actions */
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;

  store.dispatch(GetUserAction(user));
};

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user;
  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final User _user;
  GetUserAction(this._user);

  User get user => this._user;
}

/* Product Actions */
ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  final response = await http.get(productUrl);
  final respData = json.decode(response.body);
  List<Product> products = [];
  respData.forEach((prodData) {
    final Product product = Product.fromJson(prodData);
    products.add(product);
  });

  store.dispatch(GetProductsAction(products));
};

class GetProductsAction {
  final List<Product> _products;
  GetProductsAction(this._products);

  List<Product> get products => [...this._products];
}

/* Cart Product Actions */
ThunkAction<AppState> toggleCartProductAction(Product cartProduct) {
  return (Store<AppState> store) {
    final List<Product> updatedCartProducts = [...store.state.cartProducts];
    final int index = updatedCartProducts
        .indexWhere((product) => product.id == cartProduct.id);
    bool isInCart = index > -1;

    if (isInCart) {
      updatedCartProducts.removeAt(index);
    } else {
      updatedCartProducts.add(cartProduct);
    }
    store.dispatch(ToggleCartProductAction(updatedCartProducts));
  };
}

class ToggleCartProductAction {
  final List<Product> _cartProducts;
  ToggleCartProductAction(this._cartProducts);

  List<Product> get cartProducts => this._cartProducts;
}
