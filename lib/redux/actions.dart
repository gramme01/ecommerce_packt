import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_state.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';

String productUrl = 'http://10.0.2.2:1337/products';
String cartProductUrl = 'http://10.0.2.2:1337/carts';
String cardUrl = 'http://10.0.2.2:1337/card';
String userUrl = 'http://10.0.2.2:1337/users';

// User Actions
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

// Cart Product Actions
ThunkAction<AppState> toggleCartProductAction(Product cartProduct) {
  return (Store<AppState> store) async {
    final List<Product> cartProducts = store.state.cartProducts;
    final User user = store.state.user;

    final int index =
        cartProducts.indexWhere((product) => product.id == cartProduct.id);
    bool isInCart = index > -1;
    List<Product> updatedCartProducts = List.from(cartProducts);

    if (isInCart) {
      updatedCartProducts.removeAt(index);
    } else {
      updatedCartProducts.add(cartProduct);
    }
    final List<String> cartProductsIds =
        updatedCartProducts.map((product) => product.id).toList();

    await http.put(
      '$cartProductUrl/${user.cartId}',
      body: {"products": json.encode(cartProductsIds)},
      headers: {"Authorization": "Bearer ${user.jwt}"},
    );
    store.dispatch(ToggleCartProductAction(updatedCartProducts));
  };
}

ThunkAction<AppState> getCartProductsAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  List<Product> cartProducts = [];

  if (storedUser == null) return;

  final User user = User.fromJson(json.decode(storedUser));
  http.Response response = await http.get(
    '$cartProductUrl/${user.cartId}',
    headers: {'Authorization': 'Bearer ${user.jwt}'},
  );
  final respData = json.decode(response.body)['products'] as List;

  respData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    cartProducts.add(product);
  });
  store.dispatch(GetCartProductsAction(cartProducts));
};

class ToggleCartProductAction {
  final List<Product> _cartProducts;
  ToggleCartProductAction(this._cartProducts);

  List<Product> get cartProducts => this._cartProducts;
}

class GetCartProductsAction {
  final List<Product> _cartProducts;
  GetCartProductsAction(this._cartProducts);

  List<Product> get cartProducts => this._cartProducts;
}

// Card Actions
ThunkAction<AppState> getCardsAction = (Store<AppState> store) async {
  final String customerId = store.state.user.customerId;
  final http.Response response = await http.get('$cardUrl?$customerId');
  print('GET URL \n $cardUrl?$customerId');
  final respData = json.decode(response.body);

  // print('[CardData]: $respData');
  store.dispatch(GetCardsAction(respData));
};

class GetCardsAction {
  final List<dynamic> _cards;
  GetCardsAction(this._cards);

  List<dynamic> get cards => this._cards;
}

class AddCardAction {
  final dynamic _card;
  AddCardAction(this._card);

  dynamic get card => this._card;
}

//CardToken action
class UpdateCardTokenAction {
  final String _cardToken;
  UpdateCardTokenAction(this._cardToken);

  String get cardToken => this._cardToken;
}

ThunkAction<AppState> getCardTokenAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedCardToken = prefs.getString('cardToken');
  final cardToken = storedCardToken != null ? storedCardToken : '';

  store.dispatch(UpdateCardTokenAction(cardToken));
};

ThunkAction<AppState> toggleCardTokenAction(String newCardToken) {
  return (Store<AppState> store) async {
    // final String cardToken = store.state.cardToken;
    final User user = store.state.user;

    await http.put(
      '$userUrl/${user.id}',
      body: {"card_token": newCardToken},
      headers: {"Authorization": "Bearer ${user.jwt}"},
    );
    store.dispatch(UpdateCardTokenAction(newCardToken));
  };
}

//Order Action
class AddOrderAction {
  final Order _order;
  AddOrderAction(this._order);

  Order get order => this._order;
}
