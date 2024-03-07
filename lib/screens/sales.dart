import 'package:flutter/material.dart';
import '../utils/sql_helper.dart'; // Adjust the import based on your project structure

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<Map<String, dynamic>> _salesData = [];

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  Future<void> _loadSalesData() async {
    final salesData = await SQLHelper
        .getSalesData(); // Update the method based on your SQLHelper implementation
    setState(() {
      _salesData = salesData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(0, 5),
          child: const Text(
            "Sales",
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
      backgroundColor: const Color.fromARGB(255, 52, 34, 56),
      body: _buildSalesList(),
    );
  }

  Widget _buildSalesList() {
    return ListView.builder(
      itemCount: _salesData.length,
      itemBuilder: (context, index) {
        final sale = _salesData[index];
        return ListTile(
          title: Text(
            'Sale ID: ${sale['id']}',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Order Date: ${sale['createdAt']} - Total Amount: \$${sale['total_amount']}  Payment Methord: ${sale['payment_option']}',
            style: const TextStyle(color: Colors.white),
          ),
          onTap: () {
            // Implement onTap to show/hide products for this sale
            // You might use a modal bottom sheet or navigate to a new page
            // depending on your UI design
            _showSaleDetails(sale['id'] as int);
          },
        );
      },
    );
  }

  void _showSaleDetails(int saleId) {
    // Implement the logic to show/hide products for the selected sale
    // You can use a modal bottom sheet or navigate to a new page
    // to show the products related to this sale
  }
}
