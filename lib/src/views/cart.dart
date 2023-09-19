import '../models/cart.dart';

class Cart {
  final List<CartItem> items = [];

  void addToCart(CartItem item) {
    final existingItemIndex =
        items.indexWhere((element) => element.id == item.id);

    if (existingItemIndex != -1) {
      // Item is already in the cart, increase quantity
      items[existingItemIndex].quantity += 1;
    } else {
      // Item is not in the cart, add it
      items.add(item);
    }
  }

  void removeFromCart(int productId) {
    items.removeWhere((element) => element.id == productId);
  }

  void updateQuantity(int productId, int newQuantity) {
    final itemIndex = items.indexWhere((element) => element.id == productId);

    if (itemIndex != -1) {
      items[itemIndex].quantity = newQuantity;
    }
  }
}
