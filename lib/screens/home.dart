import 'package:flutter/material.dart';
import '../utils/sql_helper.dart'; // Replace with the correct path

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _products = [];

  Future<void> _refreshProducts() async {
    final products = await SQLHelper.getProducts();
    setState(() {
      _products = products;
    });
  }

  void _addToCart(Map<String, dynamic> product) async {
    // Assuming a default quantity of 1 for simplicity
    await SQLHelper.addToCart(
      product['product_name'],
      product['product_price'],
      product['unique_code'],
      product['tax'],
      1, // Default quantity
    );
    // You can also display a snackbar or any feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 500),
        content: Text('${product['product_name']} added to the cart.'),
      ),
    );
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
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: FutureBuilder(
          future: SQLHelper.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error fetching products",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
              return Center(
                child: Text(
                  "No Products Available",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              final List<Map<String, dynamic>> products =
                  snapshot.data! as List<Map<String, dynamic>>;
              _products = products;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _calculateCrossAxisCount(context),
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return GestureDetector(
                    onTap: () {
                      // Implement onTap action
                      print('Tapped on product: ${product['product_name']}');
                      print('Tapped on product: ${product['product_price']}');
                      print('Tapped on product: ${product['tax']}');
                      print('Tapped on product: ${product['unique_code']}');

                      _addToCart(product);
                    },
                    child: Card(
                      color: Color.fromARGB(255, 62, 44, 66),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['product_name'] ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Price: \$${product['product_price'] ?? ''}',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Tax: ${product['tax'] ?? ''}%',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Unique code: ${product['unique_code'] ?? ''}',
                              style: TextStyle(color: Colors.white),
                            ),
                            // Add more details as needed
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 600) {
      crossAxisCount = 6;
    }
    return crossAxisCount;
  }
}
