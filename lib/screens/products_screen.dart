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

  final Widget _appBar = PreferredSize(
    child: StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return AppBar(
          centerTitle: true,
          leading: Icon(Icons.store),
          title: SizedBox(
            child: Text(state.user != null ? state.user.username : ''),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: state.user != null
                    ? IconButton(
                        icon: Icon(Icons.exit_to_app), //
                        onPressed: () {},
                      )
                    : null),
          ],
        );
      },
    ),
    preferredSize: Size.fromHeight(60.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Container(
        child: Text('Products Page'),
      ),
    );
  }
}

//nbmbnmnbnmgfhipo
