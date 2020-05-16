import 'package:e_commerce_packt/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  // final Product product;
  // ProductDetailScreen({@required this.product});

  @override
  Widget build(BuildContext context) {
    final Map arg = ModalRoute.of(context).settings.arguments as Map;
    final Product product = arg['product'];
    return Scaffold(
      body: Center(
        child: Text(product.name),
      ),
    );
  }
}
