import 'package:e_commerce_packt/models/user.dart';
import 'package:e_commerce_packt/redux/actions.dart';

import '../models/app_state.dart';
import '../models/product.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
      user: userReducer(
        state.user,
        action,
      ),
      products: productsReducer(
        state.products,
        action,
      ));
}

User userReducer(User user, dynamic action) {
  if (action is GetUserAction) {
    return action.user;
  }
  return user;
}

List<Product> productsReducer(List<Product> products, dynamic action) {
  if (action is GetProductsAction) {
    return action.products;
  }
  return products;
}
