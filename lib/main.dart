import 'package:flutter/material.dart';
// import "./home.dart";
import "./login.dart";

void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

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
