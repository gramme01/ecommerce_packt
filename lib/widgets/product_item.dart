import 'package:e_commerce_packt/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/app_state.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product item;

  ProductItem({this.item});

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = "http://10.0.2.2:1337${item.picture['url']}";

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: {'product': item}),
      child: GridTile(
        child: Image.network(
          pictureUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          subtitle: Text("\$${item.price}"),
          backgroundColor: Color(0xBB000000),
          trailing: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) => state.user != null
                ? IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () => print('[CART BUTTON] ${item.name}'),
                  )
                : Text(''),
          ),
        ),
      ),
    );
  }
}
