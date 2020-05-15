import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/app_state.dart';
import '../widgets/product_item.dart';

final gradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: <Color>[
      Colors.deepOrange[300],
      Colors.deepOrange[400],
      Colors.deepOrange[500],
      Colors.deepOrange[600],
      Colors.deepOrange[700],
    ],
    stops: [0.1, 0.3, 0.5, 0.7, 0.9],
  ),
);

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

  Widget _buildAppBar(state) {
    return PreferredSize(
      child: AppBar(
        centerTitle: true,
        leading: Icon(Icons.store),
        title: SizedBox(
          child: Text(state.user != null
              ? state.user.username.toString().toUpperCase()
              : ''),
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
      ),
      preferredSize: Size.fromHeight(60.0),
    );
  }

  ///

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(state),
          body: Container(
              decoration: gradientBackground,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: GridView.builder(
                        itemCount: state.products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int i) =>
                            ProductItem(item: state.products[i]),
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}

//nbmbnmnbnmgfhipo
