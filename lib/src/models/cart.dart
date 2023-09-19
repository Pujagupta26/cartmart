class CartItem {
  final int id;
  final String productName;
  final double productPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.productName,
    required this.productPrice,
    this.quantity = 1, // Default quantity is 1
  });
}
