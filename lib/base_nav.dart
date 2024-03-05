import 'package:flutter/material.dart';
import './screens/home.dart';
import './screens/cart.dart';
import './screens/add_products.dart';
import './screens/sales.dart';
import './login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late PageController _pageController;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId'); // Clear the 'userId' data

    // Navigate to the login page and remove all routes on top of it
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: [
          HomePage(),
          CartPage(),
          AddProduct(),
          SalesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Sales',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            isDark ? Colors.white : const Color.fromARGB(255, 64, 0, 75),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
      floatingActionButton: _selectedIndex == 3
          ? FloatingActionButton(
              onPressed: () {
                _logout();
              },
              child: const Icon(Icons.logout),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
