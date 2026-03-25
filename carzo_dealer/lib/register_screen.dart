import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'verifying_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  /// Controllers
  final shopName = TextEditingController();
  final ownerName = TextEditingController();
  final mobile = TextEditingController();
  final altMobile = TextEditingController();
  final whatsapp = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final state = TextEditingController();
  final district = TextEditingController();
  final city = TextEditingController();
  final pincode = TextEditingController();
  final gstYear = TextEditingController();
  final gmap = TextEditingController();

  /// Image vars
  File? gstImage;
  File? idImage;

  String? gstUrl;
  String? idUrl;

  bool loading = false;

  final picker = ImagePicker();

  pickImage(bool isGst) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        if (isGst) {
          gstImage = File(picked.path);
        } else {
          idImage = File(picked.path);
        }
      });
    }
  }

  showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future uploadImages(String uid) async {
    if (gstImage == null || idImage == null) {
      showSnack("Upload GST and ID proof");
      return false;
    }

    setState(() => loading = true);

    final gstRef = FirebaseStorage.instance
        .ref("dealerDocs/$uid/gst.jpg");

    await gstRef.putFile(gstImage!);
    gstUrl = await gstRef.getDownloadURL();

    final idRef = FirebaseStorage.instance
        .ref("dealerDocs/$uid/id.jpg");

    await idRef.putFile(idImage!);
    idUrl = await idRef.getDownloadURL();

    return true;
  }

  registerDealer() async {
    if (shopName.text.isEmpty) return showSnack("Enter shop name");
    if (ownerName.text.isEmpty) return showSnack("Enter owner name");
    if (mobile.text.isEmpty) return showSnack("Enter mobile number");
    if (email.text.isEmpty) return showSnack("Enter email");
    if (password.text.isEmpty) return showSnack("Enter password");
    if (state.text.isEmpty) return showSnack("Enter state");
    if (district.text.isEmpty) return showSnack("Enter district");
    if (city.text.isEmpty) return showSnack("Enter city");
    if (pincode.text.isEmpty) return showSnack("Enter pincode");
    if (gstYear.text.isEmpty) return showSnack("Enter year of establish");

    try {
      setState(() => loading = true);

      /// Firebase Auth Signup
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim());

      String uid = cred.user!.uid;

      /// Upload Images
      bool uploaded = await uploadImages(uid);
      if (!uploaded) {
        setState(() => loading = false);
        return;
      }

      /// Timestamp
      String time = DateFormat("dd MMM yyyy - hh:mm:ss a")
          .format(DateTime.now());

      /// Save to Realtime DB
      DatabaseReference ref = FirebaseDatabase.instance
          .ref("Dealer requests/$uid");

      await ref.set({
        "Shop name": shopName.text,
        "Shop owner name": ownerName.text,
        "Mobile number": mobile.text,
        "Alternative number": altMobile.text,
        "Whatsapp number": whatsapp.text,
        "Email id": email.text,
        "State": state.text,
        "District": district.text,
        "City": city.text,
        "Pincode": pincode.text,
        "Year of establish": gstYear.text,
        "Shop G Map Location": gmap.text,
        "GST proof": gstUrl,
        "Id proof": idUrl,
        "Approval status": "Pending",
        "Timestamp": time,
      });

      /// TinyDB Save
      SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.setString("open", "registered");
      await prefs.setString("UID", uid);

      setState(() => loading = false);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const VerifyingScreen()));

    } catch (e) {
      setState(() => loading = false);
      showSnack(e.toString());
    }
  }

  openWhatsapp() async {
    Uri url = Uri.parse("https://wa.me/916235323966");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Dealer Register")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(controller: shopName,
                decoration:
                const InputDecoration(labelText: "Shop Name")),

            TextField(controller: ownerName,
                decoration:
                const InputDecoration(labelText: "Owner Name")),

            TextField(controller: mobile,
                decoration:
                const InputDecoration(labelText: "Mobile")),

            TextField(controller: altMobile,
                decoration:
                const InputDecoration(labelText: "Alternative Number")),

            TextField(controller: whatsapp,
                decoration:
                const InputDecoration(labelText: "Whatsapp Number")),

            TextField(controller: email,
                decoration:
                const InputDecoration(labelText: "Email")),

            TextField(controller: password,
                obscureText: true,
                decoration:
                const InputDecoration(labelText: "Password")),

            TextField(controller: state,
                decoration:
                const InputDecoration(labelText: "State")),

            TextField(controller: district,
                decoration:
                const InputDecoration(labelText: "District")),

            TextField(controller: city,
                decoration:
                const InputDecoration(labelText: "City")),

            TextField(controller: pincode,
                decoration:
                const InputDecoration(labelText: "Pincode")),

            TextField(controller: gstYear,
                decoration:
                const InputDecoration(labelText: "Year of Establish")),

            TextField(controller: gmap,
                decoration:
                const InputDecoration(labelText: "Google Map Location")),

            const SizedBox(height: 15),

            ElevatedButton(
                onPressed: () => pickImage(true),
                child: const Text("Upload GST Proof")),

            ElevatedButton(
                onPressed: () => pickImage(false),
                child: const Text("Upload Owner ID")),

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: registerDealer,
                child: const Text("Submit")),

            TextButton(
                onPressed: openWhatsapp,
                child: const Text("Contact Us")),

            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const LoginScreen()));
                },
                child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}