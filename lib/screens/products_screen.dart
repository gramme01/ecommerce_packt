import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/app_state.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';
  final void Function() onInit;

  ProductsScreen({this.onInit});
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    // _getUser();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      builder: (context, state) {
        return Text(json.encode(state.user));
      },
      converter: (store) => store.state,
    );
  }
}
//hkewrq vsghiopu hjhghjhh mbgfgfg  jkljlkjkjklj fdgfdgf dfhtugfhipo
