import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  login() async {

    if (email.text.isEmpty) return snack("Enter Email");
    if (password.text.isEmpty) return snack("Enter Password");

    try {
      setState(() => loading = true);

      UserCredential cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim());

      String uid = cred.user!.uid;

      SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.setString("UID", uid);
      await prefs.setString("open", "home");

      setState(() => loading = false);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()),
              (route) => false);

    } catch (e) {
      setState(() => loading = false);
      snack("Login Failed");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Dealer Login")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: email,
              decoration:
              const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: password,
              obscureText: true,
              decoration:
              const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: login,
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}