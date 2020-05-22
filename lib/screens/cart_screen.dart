import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/app_state.dart';
import '../widgets/product_item.dart';
import './products_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  final void Function() onInit;
  CartScreen({this.onInit});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  Widget _cartTab() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          decoration: gradientBackground,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: state.cartProducts.isNotEmpty
                      ? GridView.builder(
                          itemCount: state.cartProducts.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 3,
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            childAspectRatio:
                                orientation == Orientation.portrait ? 1.0 : 1.3,
                          ),
                          itemBuilder: (BuildContext context, int i) =>
                              ProductItem(item: state.cartProducts[i]),
                        )
                      : Center(
                          child: Text("Cart is Empty"),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cardTab() {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: state.cards
                      .map<Widget>(
                        (card) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepOrange,
                            child: Icon(
                              Icons.credit_card,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                              "${card['exp_month']}/${card['exp_year']}, ${card['last4']}"),
                          subtitle: Text("${card['brand']}"),
                          trailing: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              'Set as Primary',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            onPressed: () => print('Pressed'),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          );
        });
  }

  Widget _ordersTab() {
    return Text('Orders');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.cyan[100],
            tabs: [
              Tab(icon: Icon(Icons.shopping_cart)),
              Tab(icon: Icon(Icons.credit_card)),
              Tab(icon: Icon(Icons.receipt)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _cartTab(),
            _cardTab(),
            _ordersTab(),
          ],
        ),
      ),
    );
  }
}
