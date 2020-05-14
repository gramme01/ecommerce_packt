import 'package:e_commerce_packt/models/user.dart';
import 'package:e_commerce_packt/redux/actions.dart';

import '../models/app_state.dart';

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
    //return user from action
    return action.user;
  }
  return user;
}

List<dynamic> productsReducer(List<dynamic> products, dynamic action) {
  if (action is GetProductsAction) {
    return action.products;
  }
  return products;
}
