import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var storedUser = prefs.getString('user');

    print('\n \n decoded user ${json.decode(storedUser)}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('The product screen'),
      ),
    );
  }
}
