import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../utils/sql_helper.dart';

class AnimationSuccess extends StatefulWidget {
  const AnimationSuccess({Key? key}) : super(key: key);

  @override
  State<AnimationSuccess> createState() => _AnimationSuccessState();
}

class _AnimationSuccessState extends State<AnimationSuccess> {
  Future<void> _printInvoice() async {
    const format = PdfPageFormat.letter;

    final pw.Document pdf = pw.Document();

    // Fetch cart items from the database
    final cartItems = await SQLHelper.getCartItems();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (pw.Context context) => [
          // Invoice header
          pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(bottom: 20.0),
            child: pw.Text(
              "INVOICE",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          // Shop details
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Shop Name: Your Retail Shop"),
                pw.Text("Address: 123 Main Street, Cityville"),
                pw.Text("Phone: (555) 123-4567"),
                pw.Text("Email: info@yourretailshop.com"),
              ],
            ),
          ),

          // Invoice details
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Invoice Number: INV-2024001"),
                pw.Text("Date: ${DateTime.now().toLocal()}"),
              ],
            ),
          ),

          // Table header
          pw.TableHelper.fromTextArray(
            headers: ['Description', 'Quantity', 'Unit Price', 'tax', 'Total'],
            data: [
              for (var item in cartItems)
                [
                  item['product_name'],
                  item['quantity'].toString(),
                  '\$${item['product_price']}',
                  '${item['tax']}%',
                  '\$${item['quantity'] * item['product_price']}'
                ],
            ],
          ),
          pw.TableHelper.fromTextArray(
            headers: ['Tax', 'Amount'],
            data: [
              [
                'Subtotal',
                '\$${_calculateSubtotal(cartItems).toStringAsFixed(2)}',
              ],
              ['VAT (10%)', '\$${_calculateVAT(cartItems).toStringAsFixed(2)}'],
              ['Tax (5%)', '\$${_calculateTax(cartItems).toStringAsFixed(2)}'],
              [
                'Total',
                '\$${_calculateTotal(cartItems).toStringAsFixed(2)}',
              ],
            ],
          ),

          // Invoice footer
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 20.0),
            child: pw.Text(
              'Thank you for shopping with us!\nPlease make checks payable to Your Retail Shop.',
              textAlign: pw.TextAlign.center,
            ),
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      format: format,
    );
  }

  // Helper functions to calculate subtotal, VAT, tax, and total
  double _calculateSubtotal(List<Map<String, dynamic>> cartItems) {
    return cartItems.fold(
        0.0, (sum, item) => sum + item['quantity'] * item['product_price']);
  }

  double _calculateVAT(List<Map<String, dynamic>> cartItems) {
    return _calculateSubtotal(cartItems) * 0.10; // Assuming 10% VAT
  }

  double _calculateTax(List<Map<String, dynamic>> cartItems) {
    return _calculateSubtotal(cartItems) * 0.05; // Assuming 5% tax
  }

  double _calculateTotal(List<Map<String, dynamic>> cartItems) {
    return _calculateSubtotal(cartItems) +
        _calculateVAT(cartItems) +
        _calculateTax(cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/setayi.json',
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Paid!",
                    style: TextStyle(
                      color: Color.fromARGB(255, 52, 34, 56),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _printInvoice();
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
                    'Print Invoice',
                    style: TextStyle(fontSize: 23, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
