import 'package:flutter/material.dart';
import 'dart:async';
import 'pending_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PendingListScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              "Assets/images/carzo_admin_logo.png",
              width: 200,
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: Colors.red,
            )

          ],
        ),
      ),
    );
  }
}