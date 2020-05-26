import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/app_state.dart';
import '../redux/actions.dart';
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
  String userUrl = 'http://10.0.2.2:1337/users';
  String cardUrl = 'http://10.0.2.2:1337/card';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.onInit();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: 'pk_test_LalRFS5Tqdn4sPC3x65dftqs005QbAGBZx',
      ),
    );
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
          _addCard(String cardToken) async {
            final User user = state.user;
            //add cardtoken to user data
            await http.put(
              '$userUrl/${user.id}',
              body: {"card_token": cardToken},
              headers: {"Authorization": "Bearer ${user.jwt}"},
            );

            //link added card to stripe customer
            http.Response response = await http.post(
              '$cardUrl/add',
              body: {"source": cardToken, "customer": user.customerId},
            );

            final respData = json.decode(response.body);
            return respData;
          }

          return Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 10.0)),
              RaisedButton(
                elevation: 8.0,
                child: Text('Add Card'),
                onPressed: () async {
                  final PaymentMethod paymentMethod =
                      await StripePayment.paymentRequestWithCardForm(
                          CardFormPaymentRequest());
                  final card = await _addCard(paymentMethod.id);

                  //AddCard Action
                  StoreProvider.of<AppState>(context)
                      .dispatch(AddCardAction(card));

                  //Update Card Token action
                  StoreProvider.of<AppState>(context).dispatch(
                    UpdateCardTokenAction(card['id']),
                  );

                  //show snackbar
                  final snackbar = SnackBar(
                    content: Text(
                      'Card Added',
                      style: TextStyle(color: Colors.green),
                    ),
                    backgroundColor: Colors.grey[900],
                  );
                  _scaffoldKey.currentState.showSnackBar(snackbar);
                },
              ),
              Expanded(
                child: ListView(
                    children: state.cards
                        .map<Widget>(
                          (c) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepOrange,
                              child: Icon(
                                Icons.credit_card,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                                "${c['card']['exp_month']}/${c['card']['exp_year']}, ${c['card']['last4']}"),
                            subtitle: Text("${c['card']['brand']}"),
                            trailing: state.cardToken == c['id']
                                ? Chip(
                                    avatar: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    label: Text('Primary Card'),
                                  )
                                : FlatButton(
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
                                    onPressed: () async {
                                      //  final String cardToken = await StripePayment.createTokenWithCard(card);
                                    },
                                  ),
                          ),
                        )
                        .toList()),
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
        key: _scaffoldKey,
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
