import 'package:flutter/material.dart';
import "./login.dart";

void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventory app',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const LoginPage());
  }
}
