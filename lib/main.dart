import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_logging/redux_logging.dart';

import './screens/cart_screen.dart';
import './screens/login_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_screen.dart';
import './screens/register_screen.dart';

import './redux/actions.dart';
import './models/app_state.dart';
import './redux/reducers.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware, LoggingMiddleware.printer()],
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce Packt',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.cyan[400],
          accentColor: Colors.deepOrange[200],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: ThemeData.dark().textTheme.copyWith(
                headline1:
                    TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                headline5:
                    TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                bodyText1: TextStyle(fontSize: 18),
                bodyText2: TextStyle(fontSize: 16),
              ),
          textSelectionHandleColor: Colors.cyan,
          cursorColor: Colors.deepOrange,
        ),
        routes: {
          ProductsScreen.routeName: (BuildContext context) => ProductsScreen(
                onInit: () {
                  StoreProvider.of<AppState>(context).dispatch(getUserAction);
                  StoreProvider.of<AppState>(context)
                      .dispatch(getProductsAction);
                  StoreProvider.of<AppState>(context)
                      .dispatch(getCartProductsAction);
                },
              ),
          LoginScreen.routeName: (BuildContext context) => LoginScreen(),
          RegisterScreen.routeName: (BuildContext context) => RegisterScreen(),
          ProductDetailScreen.routeName: (BuildContext context) =>
              ProductDetailScreen(),
          CartScreen.routeName: (BuildContext context) =>
              CartScreen(onInit: () {
                StoreProvider.of<AppState>(context).dispatch(getCardsAction);
              }),
        },
      ),
    );
  }
}
//cjzkhjk
