import 'package:flutter/material.dart';

import '../models/cart.dart';
import 'cart.dart';
import 'product_details.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String productImage;
  final double productPrice;
  final int id;
  final Cart cart;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.id,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the product detail page when the card is tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              id: id,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Product Image
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(productImage),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
              ),
            ),

            // Product Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Add the product to the cart
                      cart.addToCart(CartItem(
                        id: id,
                        productName: productName,
                        productPrice: productPrice,
                      ));
                    },
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),

            // Product Price
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
              child: Text(
                '\$${productPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
