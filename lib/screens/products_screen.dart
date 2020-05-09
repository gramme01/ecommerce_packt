import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('The product screen'),
      ),
    );
  }
}
