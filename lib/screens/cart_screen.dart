import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stripe_payment/stripe_payment.dart';

import './products_screen.dart';
import '../models/app_state.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../redux/actions.dart';
import '../widgets/product_item.dart';

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
  String orderUrl = 'http://10.0.2.2:1337/orders';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false;

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

  Widget _cartTab(state) {
    Orientation orientation = MediaQuery.of(context).orientation;
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
  }

  Widget _cardTab(state) {
    _addCard(String cardToken) async {
      final User user = state.user;
      await http.put(
        '$userUrl/${user.id}',
        body: {"card_token": cardToken},
        headers: {"Authorization": "Bearer ${user.jwt}"},
      ); //add cardtoken to user data
      http.Response response = await http.post(
        '$cardUrl/add',
        body: {"paymentMethodId": cardToken, "customer": user.customerId},
      ); //link added card to stripe customer

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

            StoreProvider.of<AppState>(context)
                .dispatch(AddCardAction(card)); //AddCard Action

            StoreProvider.of<AppState>(context).dispatch(
                UpdateCardTokenAction(card['id'])); //Update Card Token action

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
                              label: Text(
                                'Primary Card',
                                style: TextStyle(fontSize: 13),
                              ),
                            )
                          : FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              color: Colors.grey[900],
                              child: Text(
                                'Set as Primary',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              onPressed: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                  toggleCardTokenAction(c['id']),
                                );
                              },
                            ),
                    ),
                  )
                  .toList()),
        )
      ],
    );
  }

  Widget _ordersTab(AppState state) {
    return ListView(
      children: state.orders.length > 0
          ? state.orders
              .map<Widget>(
                (order) => ListTile(
                  title: Text('\$${order.amount}'),
                  subtitle: Text(order.createdAt),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.attach_money, color: Colors.white),
                  ),
                ),
              )
              .toList()
          : [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.close, size: 60.0),
                    Text(
                      'No orders yet',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              )
            ],
    );
  }

  String calculateTotalPrice(List<Product> cartProducts) {
    double totalPrice = 0.0;
    cartProducts.forEach((cartProduct) {
      totalPrice += cartProduct.price;
    });
    return totalPrice.toStringAsFixed(2);
  }

  Future _showCheckoutDialog(AppState state) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        if (state.cards.length == 0) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text('Add Card'),
                ),
                Icon(Icons.credit_card, size: 60.0),
              ],
            ),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                Text('Provide a credit card before checking out',
                    style: Theme.of(context).textTheme.bodyText2)
              ],
            )),
          );
        }
        String cartSummary = "";
        state.cartProducts.forEach((cartProduct) {
          cartSummary += "• ${cartProduct.name}, \$${cartProduct.price}\n";
        });
        final primaryCard = state.cards
            .singleWhere((card) => card['id'] == state.cardToken)['card'];
        return AlertDialog(
          title: Text('Checkout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('CART ITEMS (${state.cartProducts.length})\n',
                    style: Theme.of(context).textTheme.bodyText2),
                Text('$cartSummary',
                    style: Theme.of(context).textTheme.bodyText2),
                Text('CARD DETAILS\n',
                    style: Theme.of(context).textTheme.bodyText2),
                Text('Brand: ${primaryCard["brand"]}',
                    style: Theme.of(context).textTheme.bodyText2),
                Text('Card Number: ${primaryCard["last4"]}',
                    style: Theme.of(context).textTheme.bodyText2),
                Text(
                    'Expires On: ${primaryCard["exp_month"]}/${primaryCard["exp_year"]}\n',
                    style: Theme.of(context).textTheme.bodyText2),
                Text(
                    'ORDER TOTAL: \$${calculateTotalPrice(state.cartProducts)}',
                    style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            RaisedButton(
              color: Colors.green,
              child: Text(
                'Checkout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      },
    ).then((value) async {
      _checkoutCartProducts() async {
        http.Response response = await http.post(
          orderUrl,
          body: {
            "amount": calculateTotalPrice(state.cartProducts),
            "products": json.encode(state.cartProducts),
            "paymentMethod": state.cardToken,
            "customer": state.user.customerId,
          },
          headers: {"Authorization": "Bearer ${state.user.jwt}"},
        );
        final respData = json.decode(response.body);
        return respData;
      }

      if (value == true) {
        //loading Spinner
        setState(() {
          _isSubmitting = true;
        });
        //checkout with stripe
        final newOrderData = await _checkoutCartProducts();
        //create order instance on strapi
        Order newOrder = Order.fromJson(newOrderData);
        //pass new order instance to action
        StoreProvider.of<AppState>(context).dispatch(AddOrderAction(newOrder));
        //clear cart
        StoreProvider.of<AppState>(context).dispatch(clearCartProductsAction);
        //hide spinner
        setState(() {
          _isSubmitting = false;
        });
        //show success dialog
        _showSuccessDialog(state.user.email);
      }
    });
  }

  Future _showSuccessDialog(email) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Success!'),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Order Successful!\n\nReceipt has benn sent to $email\n\n Check Orders Tab for the order summary',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => ModalProgressHUD(
        child: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                  'Summary: ${state.cartProducts.length} Items • \$${calculateTotalPrice(state.cartProducts)}'),
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
                _cartTab(state),
                _cardTab(state),
                _ordersTab(state),
              ],
            ),
            floatingActionButton: state.cartProducts.length > 0
                ? FloatingActionButton(
                    child: Icon(
                      Icons.local_atm,
                      size: 30,
                    ),
                    onPressed: () => _showCheckoutDialog(state),
                  )
                : Text(''),
          ),
        ),
        inAsyncCall: _isSubmitting,
      ),
    );
  }
}
