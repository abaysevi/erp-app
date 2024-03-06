import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import './payment_complete_anim.dart';
import '../utils/sql_helper.dart'; // Import the SQLHelper class

enum PaymentOption { Card, Cash }

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartItems = [];
  PaymentOption? _selectedPaymentOption;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final cartItems = await SQLHelper.getCartItems();
    setState(() {
      _cartItems = cartItems;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCartItems();
  }

  Future<void> _removeItemFromCart(int itemId) async {
    final cartItem = _cartItems.firstWhere((item) => item['id'] == itemId);
    final int currentQuantity = cartItem['quantity'] ?? 0;

    if (currentQuantity > 1) {
      await SQLHelper.updateCartQuantity(itemId, currentQuantity - 1);
    } else {
      await SQLHelper.removeFromCart(itemId);
    }

    _loadCartItems();
  }

  Future<void> _scanBarcode() async {
    try {
      String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );

      if (barcodeScanResult != '-1') {
        final product = await SQLHelper.getProductByBarcode(barcodeScanResult);

        if (product != null) {
          await SQLHelper.addToCart(
            product['product_name'],
            product['product_price'],
            product['unique_code'],
            product['tax'],
            1, // Default quantity
          );

          _loadCartItems();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product not found for the scanned barcode.'),
            ),
          );
        }
      }
    } on PlatformException {
      print('Error scanning barcode');
    }
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentOption == PaymentOption.Card) {
      // Implement card payment logic
      print('Processing card payment');
    } else if (_selectedPaymentOption == PaymentOption.Cash) {
      // Implement cash payment logic
      print('Processing cash payment');
    }

    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const AnimationSuccess(),
      ),
    );

    // You can add more payment options as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(0, 5),
          child: const Text(
            "Cart",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 52, 34, 56),
        centerTitle: true,
        actions: <Widget>[
          const Text("Scan Barcode", style: TextStyle(color: Colors.white)),
          IconButton(
            onPressed: _scanBarcode,
            icon: const Icon(Icons.barcode_reader),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCartItems,
        child: _buildCartItemsList(),
      ),
      bottomNavigationBar: _buildTotalAmount(),
      backgroundColor: const Color.fromARGB(255, 52, 34, 56),
    );
  }

  Widget _buildCartItemsList() {
    return ListView.builder(
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = _cartItems[index];
        return ListTile(
          title: Text(
            cartItem['product_name'] ?? '',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Price: \$${cartItem['product_price']} - Quantity: ${cartItem['quantity']}',
            style: const TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: () => _removeItemFromCart(cartItem['id'] as int),
          ),
        );
      },
    );
  }

  // Widget _buildTotalAmount() {
  //   double totalAmount = _calculateTotalAmount();
  //   return BottomAppBar(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
  //             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           Row(
  //             children: [
  //               DropdownButton<PaymentOption>(
  //                 value: _selectedPaymentOption ??
  //                     PaymentOption.Card, // Default value
  //                 onChanged: (PaymentOption? newValue) {
  //                   setState(() {
  //                     _selectedPaymentOption = newValue;
  //                   });
  //                 },
  //                 items: PaymentOption.values.map((PaymentOption option) {
  //                   return DropdownMenuItem<PaymentOption>(
  //                     value: option,
  //                     child: Text(option.toString().split('.').last),
  //                   );
  //                 }).toList(),
  //               ),
  //               const SizedBox(width: 16),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   _processPayment();
  //                 },
  //                 style: ButtonStyle(
  //                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                     RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(
  //                           10.0), // Adjust the value for less circular appearance
  //                     ),
  //                   ),
  //                   backgroundColor: MaterialStateProperty.all<Color>(
  //                     Color.fromARGB(255, 52, 34, 56),
  //                   ),
  //                 ),
  //                 child: const Text(
  //                   'Pay',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildTotalAmount() {
  //   double totalAmount = _calculateTotalAmount();
  //   return BottomAppBar(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
  //                 style: const TextStyle(
  //                     fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 16), // Adjust the spacing between the rows
  //           Row(
  //             children: [
  //               DropdownButton<PaymentOption>(
  //                 value: _selectedPaymentOption ?? PaymentOption.Card,
  //                 onChanged: (PaymentOption? newValue) {
  //                   setState(() {
  //                     _selectedPaymentOption = newValue;
  //                   });
  //                 },
  //                 items: PaymentOption.values.map((PaymentOption option) {
  //                   return DropdownMenuItem<PaymentOption>(
  //                     value: option,
  //                     child: Text(option.toString().split('.').last),
  //                   );
  //                 }).toList(),
  //               ),
  //               const SizedBox(width: 16),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   _processPayment();
  //                 },
  //                 style: ButtonStyle(
  //                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                     RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                     ),
  //                   ),
  //                   backgroundColor: MaterialStateProperty.all<Color>(
  //                     Color.fromARGB(255, 52, 34, 56),
  //                   ),
  //                 ),
  //                 child: const Text(
  //                   'Pay',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildTotalAmount() {
  //   double totalAmount = _calculateTotalAmount();
  //   return Container(
  //     height: 120,
  //     child: BottomAppBar(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
  //                     style: const TextStyle(
  //                         fontSize: 18, fontWeight: FontWeight.bold),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 16), // Adjust the spacing between the rows
  //               Row(
  //                 children: [
  //                   DropdownButton<PaymentOption>(
  //                     value: _selectedPaymentOption ?? PaymentOption.Card,
  //                     onChanged: (PaymentOption? newValue) {
  //                       setState(() {
  //                         _selectedPaymentOption = newValue;
  //                       });
  //                     },
  //                     items: PaymentOption.values.map((PaymentOption option) {
  //                       return DropdownMenuItem<PaymentOption>(
  //                         value: option,
  //                         child: Text(option.toString().split('.').last),
  //                       );
  //                     }).toList(),
  //                   ),
  //                   const SizedBox(width: 16),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       _processPayment();
  //                     },
  //                     style: ButtonStyle(
  //                       shape:
  //                           MaterialStateProperty.all<RoundedRectangleBorder>(
  //                         RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10.0),
  //                         ),
  //                       ),
  //                       backgroundColor: MaterialStateProperty.all<Color>(
  //                         Color.fromARGB(255, 52, 34, 56),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       'Pay',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTotalAmount() {
    double totalAmount = _calculateTotalAmount();
    return Container(
      height: 140,
      child: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16), // Adjust the spacing between the rows
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<PaymentOption>(
                    value: _selectedPaymentOption ?? PaymentOption.Card,
                    onChanged: (PaymentOption? newValue) {
                      setState(() {
                        _selectedPaymentOption = newValue;
                      });
                    },
                    items: PaymentOption.values.map((PaymentOption option) {
                      return DropdownMenuItem<PaymentOption>(
                        value: option,
                        child: Text(option.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      _processPayment();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 52, 34, 56),
                      ),
                    ),
                    child: const Text(
                      'Pay',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalAmount() {
    double total = 0;
    for (var item in _cartItems) {
      total += (item['product_price'] ?? 0.0) * (item['quantity'] ?? 0);
    }
    return total;
  }
}
