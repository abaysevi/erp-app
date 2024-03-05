import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 52, 34, 56),
      body: Center(
        child: Text(
          "Sales",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'AgeoTrial',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
