import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationSuccess extends StatefulWidget {
  const AnimationSuccess({Key? key}) : super(key: key);

  @override
  State<AnimationSuccess> createState() => _AnimationSuccessState();
}

class _AnimationSuccessState extends State<AnimationSuccess> {
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
                    // Handle button press here
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
