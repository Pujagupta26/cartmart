import 'package:flutter/material.dart';
import '../models/cart.dart';
import 'product_details.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    // Calculate the initial total price when the widget is created
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    totalPrice = widget.cartItems.fold(0, (sum, item) {
      return sum + (item.productPrice * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.cartItems.isEmpty
                ? Center(
                    child: Text('Your cart is empty.'),
                  )
                : ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = widget.cartItems[index];

                      return GestureDetector(
                        onTap: () {
                          // Call a function using the item's ID
                          _onItemTap(cartItem.id);
                        },
                        child: Card(
                          margin: EdgeInsets.all(8.0),
                          color: Colors.blue[50], // Colorful cart items
                          child: ListTile(
                            title: Text(cartItem.productName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price: \$${cartItem.productPrice.toStringAsFixed(2)}',
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (cartItem.quantity > 1) {
                                            cartItem.quantity--;
                                          } else {
                                            widget.cartItems.removeAt(index);
                                          }
                                          _calculateTotalPrice();
                                        });
                                      },
                                    ),
                                    Text(cartItem.quantity.toString()),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          cartItem.quantity++;
                                          _calculateTotalPrice();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Place your order logic here
                    // You can clear the cart or proceed with payment
                  },
                  child: Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTap(int itemId) {
    // Implement the action when an item is tapped using its ID
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetail(
          id: itemId,
        ),
      ),
    );
  }
}
