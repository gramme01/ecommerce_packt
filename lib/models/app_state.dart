import 'package:meta/meta.dart';

import '../models/product.dart';
import '../models/user.dart';

@immutable
class AppState {
  final User user;
  final List<Product> products;

  AppState({
    @required this.user,
    @required this.products,
  });

  factory AppState.initial() {
    return AppState(
      user: null,
      products: [],
    );
  }
}
