import 'package:flutter/material.dart';

import '../models/product.dart';
import './products_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Map arg = ModalRoute.of(context).settings.arguments as Map;
    final Product product = arg['product'];
    final String pictureUrl = "http://10.0.2.2:1337${product.picture['url']}";
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: gradientBackground,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: orientation == Orientation.portrait ? 500 : 250,
                  child: Image.network(
                    pictureUrl,
                    fit: orientation == Orientation.portrait
                        ? BoxFit.cover
                        : BoxFit.contain,
                  ),
                ),
              ),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                '\$${product.price}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 32.0, right: 32.0, bottom: 32.0, top: 10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
