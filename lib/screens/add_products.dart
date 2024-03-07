import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:convert' show utf8;
import 'package:file_picker/file_picker.dart'; // Import the file_picker package
import '../utils/sql_helper.dart';
import 'dart:io';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _taxController = TextEditingController();
  TextEditingController _uniqueCodeController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _nameController.dispose();
    _priceController.dispose();
    _taxController.dispose();
    _uniqueCodeController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) async {
    // Get values from controllers
    String productName = _nameController.text;
    String priceText = _priceController.text;
    String taxText = _taxController.text;
    String uniqueCode = _uniqueCodeController.text;

    // Check if any field is empty
    if (productName.isEmpty ||
        priceText.isEmpty ||
        taxText.isEmpty ||
        uniqueCode.isEmpty) {
      // Show SnackBar for empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop further processing if any field is empty
    }

    // Parse values
    double productPrice = double.tryParse(priceText) ?? 0;
    double tax = double.tryParse(taxText) ?? 0;

    // Call createProduct method
    await SQLHelper.createProduct(productName, productPrice, uniqueCode, tax);

    // Show SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added successfully!'),
        duration: Duration(seconds: 1),
      ),
    );

    // Clear the fields
    _nameController.clear();
    _priceController.clear();
    _taxController.clear();
    _uniqueCodeController.clear();
  }

  void _importFromCSV(BuildContext context) async {
    // Open file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      // Ensure there is at least one file in the list
      PlatformFile file = result.files.first;

      try {
        // Read the file as bytes
        List<int> bytes = await File(file.path!).readAsBytes();

        // Load CSV data from the picked file
        String csvString = utf8.decode(bytes);
        List<List<dynamic>> csvData =
            const CsvToListConverter(eol: '\n').convert(csvString);
        // Assuming CSV structure is Product Name, Price, Tax, Unique Code
        // print(csvData);
        for (List<dynamic> row in csvData) {
          String productName = row[0].toString();
          double productPrice = double.tryParse(row[1].toString()) ?? 0.0;
          double tax = double.tryParse(row[2].toString()) ?? 0.0;
          String uniqueCode = row[3].toString().trim();
          // print(productName);
          // print(tax);
          // Call createProduct method without toInt()
          await SQLHelper.createProduct(
              productName, productPrice, uniqueCode, tax);
        }

        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Products imported successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error reading or decoding the file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 34, 56),
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(0, 5),
          child: const Text(
            "Add Product",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () => _importFromCSV(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              SizedBox(
                width: 360.0,
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 360.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'Price',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: 360.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _taxController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'Tax',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: 360.0,
                child: TextField(
                  controller: _uniqueCodeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'Unique Code',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: 360.0,
                child: ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
