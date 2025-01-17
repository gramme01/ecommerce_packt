import 'package:meta/meta.dart';

class Order {
  final double amount;
  final DateTime createdAt;
  final List<dynamic> products;

  Order({
    @required this.amount,
    @required this.createdAt,
    @required this.products,
  });

  factory Order.fromJson(json) {
    return Order(
      amount: json['amount'],
      createdAt: DateTime.parse(json['createdAt']),
      products: json['products'],
    );
  }
}
