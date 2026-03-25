import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp();

  runApp(const CarzoDealerApp());
}

class CarzoDealerApp extends StatelessWidget {
  const CarzoDealerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carzo Dealer',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Poppins",

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}