import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register_screen.dart';
import 'verifying_screen.dart';
import 'complete_registration_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    checkAppState();
  }

  checkAppState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? openValue = prefs.getString("open");

    if (openValue == null) {
      goToRegister();
    }
    else if (openValue == "registered") {
      goToVerifying();
    }
    else if (openValue == "verified") {
      goToCompleteRegistration();
    }
    else if (openValue == "home") {
      goToHome();
    }
    else {
      goToRegister();
    }
  }

  goToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  goToVerifying() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VerifyingScreen()),
    );
  }

  goToCompleteRegistration() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CompleteRegistrationScreen()),
    );
  }

  goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disable back
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// LOGO
              Image.asset(
                "Assets/images/carzo_dealer_logo.png",
                height: 120,
              ),

              const SizedBox(height: 40),

              /// PROXIMA TEXT
              const Text(
                "PROXIMA DIGITAL SOLUTIONS",
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 1,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}