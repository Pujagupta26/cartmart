import 'package:flutter/material.dart';

import '../models/product.dart';
import '../views/product_view.dart';

import 'dart:convert'; // For working with JSON data
import 'package:http/http.dart' as http; // For making HTTP requests

class ProductController {
  List<Product> products = [];

  Future<void> fetchProducts(BuildContext context) async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      products = responseData.map((data) => Product.fromJson(data)).toList();

      // Navigate to the ProductScreen with the fetched products
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductScreen(products: products),
        ),
      );
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
