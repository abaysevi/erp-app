import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './base_nav.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _storeData(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLogin();
  }

  void _checkIfAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userStatus = prefs.containsKey('userId');

    if (userStatus) {
      String userId = prefs.getString('userId') ?? 'UserId is null or empty';
      print('UserId: $userId');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BasePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 52, 34, 56),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "odoo",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 360.0,
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'username',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 360.0,
              child: TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                controller: _passwordController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: 360.0,
              child: Container(
                height: 50,
                // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Login'),
                  onPressed: () {
                    _loginUser(
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginUser(String email, String password) {
    // Replace this with your own verification logic
    if (email == 'admin' && password == 'admin') {
      _storeData(
          'admin'); // Replace 'user123' with your user ID or any identifier
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BasePage()),
      );
    } else {
      // Show an error message or handle unsuccessful login
      print('Invalid credentials');
    }
  }
}
