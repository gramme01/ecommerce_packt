import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Widget _cartTab() {
    return Text('Cart');
  }

  Widget _cardTab() {
    return Text('Card');
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
          bottom: TabBar(
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
