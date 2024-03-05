import 'package:flutter/material.dart';
import '../utils/sql_helper.dart'; // Replace with the correct path

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final products = await SQLHelper.getProducts();
    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 52, 34, 56),
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(0, 5),
          child: const Text(
            "Home",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 52, 34, 56),
        centerTitle: true,
      ),
      body: Center(
        child: _products.isEmpty
            ? const Text(
                "No Products Available",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              )
            : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(
                      product['product_name'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Price: \$${product['product_price']} | Tax: ${product['tax']}%',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Implement onTap action if needed
                    },
                  );
                },
              ),
      ),
    );
  }
}
