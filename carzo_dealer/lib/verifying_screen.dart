import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'complete_registration_screen.dart';

class VerifyingScreen extends StatefulWidget {
  const VerifyingScreen({super.key});

  @override
  State<VerifyingScreen> createState() => _VerifyingScreenState();
}

class _VerifyingScreenState extends State<VerifyingScreen> {

  String uid = "";

  @override
  void initState() {
    super.initState();
    startChecking();
  }

  startChecking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("UID") ?? "";

    if (uid.isEmpty) return;

    DatabaseReference ref =
    FirebaseDatabase.instance.ref("Dealer requests/$uid/Approval status");

    ref.onValue.listen((event) async {

      if (event.snapshot.exists) {

        String status = event.snapshot.value.toString();

        if (status == "Approved") {

          SharedPreferences prefs =
          await SharedPreferences.getInstance();

          await prefs.setString("open", "verified");

          if (mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const CompleteRegistrationScreen()));
          }
        }
      }
    });
  }

  Future<bool> onBackPress() async {
    return false; // disable back
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const CircularProgressIndicator(),

                const SizedBox(height: 30),

                const Text(
                  "Verification in Progress",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Your shop details are under review.\n"
                      "Please wait until admin approval.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
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