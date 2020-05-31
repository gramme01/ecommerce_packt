import '../models/app_state.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(
      state.user,
      action,
    ),
    products: productsReducer(
      state.products,
      action,
    ),
    cartProducts: cartProductsReducer(
      state.cartProducts,
      action,
    ),
    cards: cardsReducer(
      state.cards,
      action,
    ),
    orders: ordersReducer(
      state.orders,
      action,
    ),
    cardToken: cardTokenReducer(
      state.cardToken,
      action,
    ),
  );
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

List<Product> cartProductsReducer(List<Product> cartProducts, dynamic action) {
  if (action is UpdateCartProductsAction) {
    return action.cartProducts;
  }

  return cartProducts;
}

List<dynamic> cardsReducer(List<dynamic> cards, dynamic action) {
  if (action is GetCardsAction) {
    return action.cards;
  }
  if (action is AddCardAction) {
    return List.from(cards)..add(action.card);
  }
  return cards;
}

String cardTokenReducer(String cardToken, dynamic action) {
  if (action is UpdateCardTokenAction) {
    return action.cardToken;
  }
  return cardToken;
}

List<Order> ordersReducer(List<Order> orders, dynamic action) {
  if (action is AddOrderAction) {
    return List<Order>.from(orders)..add(action.order);
  }
  return orders;
}
