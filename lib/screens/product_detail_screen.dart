import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../redux/actions.dart';
import '../models/app_state.dart';
import '../models/product.dart';
import './products_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isInCart(AppState state, String id) {
    final List<Product> cartProducts = state.cartProducts;
    return cartProducts.indexWhere((cartProduct) => cartProduct.id == id) > -1;
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Map arg = ModalRoute.of(context).settings.arguments as Map;
    final Product product = arg['product'];
    final String pictureUrl = "http://10.0.2.2:1337${product.picture['url']}";
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: gradientBackground,
          child: Column(
            children: <Widget>[
              Container(
                // padding: const EdgeInsets.symmetric(horizontal: 32.0),
                color: Color(0XFFF6F6F6),
                width: double.infinity,
                height: orientation == Orientation.portrait ? 400 : 250,
                child: Hero(
                  tag: product,
                  child: Image.network(
                    pictureUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                '\$${product.price}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (_, state) => state.user != null
                      ? IconButton(
                          icon: Icon(Icons.shopping_cart),
                          color: _isInCart(state, product.id)
                              ? Colors.cyan[700]
                              : Colors.white,
                          onPressed: () {
                            StoreProvider.of<AppState>(context)
                                .dispatch(toggleCartProductAction(product));
                            final snackbar = SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text(
                                'Cart Updated',
                                style: TextStyle(color: Colors.green),
                              ),
                              backgroundColor: Colors.grey[900],
                            );
                            _scaffoldKey.currentState.removeCurrentSnackBar();
                            _scaffoldKey.currentState.showSnackBar(snackbar);
                          },
                        )
                      : Text(''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 32.0, right: 32.0, bottom: 32.0, top: 10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
