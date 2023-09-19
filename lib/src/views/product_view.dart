import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';
import 'add_to_cart.dart';
import 'cart.dart';
import 'commonComponents/drawer.dart';
import 'commonComponents/screen_title.dart';
import 'product_card.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  List<Product> products;

  ProductScreen({Key? key, required this.products}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _selectedIndex = 0;
  String _selectedFilter = '';
  Cart _cart = Cart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: screenTitle('Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    cartItems: _cart.items,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: drawer(),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: _calculateAspectRatio(context),
        ),
        itemCount: widget.products.length,
        itemBuilder: (BuildContext context, int index) {
          final Product product = widget.products[index];

          return ProductCard(
            productName: product.title,
            productImage: product.image,
            productPrice: product.price,
            id: product.id,
            cart: _cart,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sort),
            label: 'Sort',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            label: 'Filter',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Sort button is clicked
      _sortProducts();
    } else if (index == 1) {
      // Filter button is clicked
      _showFilterOptions(context);
    }
  }

  void _sortProducts() {
    setState(() {
      widget.products.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('Electronics', 'electronics'),
              _buildFilterOption('Jewellery', 'jewelery'),
              _buildFilterOption("Men's clothing", "men's clothing"),
              _buildFilterOption("Women's clothing", "women's clothing"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, String value) {
    return RadioListTile(
      title: Text(label),
      value: value,
      groupValue: _selectedFilter,
      onChanged: (newValue) {
        setState(() {
          _selectedFilter = newValue.toString();
        });
        Navigator.of(context).pop();
        _applyFilter(value);
      },
    );
  }

  void _applyFilter(String filterOption) async {
    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products/category/$filterOption'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          widget.products =
              responseData.map((data) => Product.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  double _calculateAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth / 2.2;
    final cardHeight = screenHeight / 3.2;
    return cardWidth / cardHeight;
  }
}
