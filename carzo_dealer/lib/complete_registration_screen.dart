import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'home_screen.dart';

class CompleteRegistrationScreen extends StatefulWidget {
  const CompleteRegistrationScreen({super.key});

  @override
  State<CompleteRegistrationScreen> createState() =>
      _CompleteRegistrationScreenState();
}

class _CompleteRegistrationScreenState
    extends State<CompleteRegistrationScreen> {

  final description = TextEditingController();

  File? logoImage;
  File? bannerImage;

  String? logoUrl;
  String? bannerUrl;

  bool agree = false;
  bool loading = false;

  String uid = "";

  String shopName = "";
  String city = "";
  String district = "";
  String state = "";
  String mobile = "";
  String location = "";

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUID();
  }

  loadUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("UID") ?? "";

    fetchDealerBasicData();
  }

  fetchDealerBasicData() async {
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("Dealer requests/$uid");

    final snap = await ref.get();

    if (snap.exists) {
      final data = snap.value as Map;

      shopName = data["Shop name"];
      city = data["City"];
      district = data["District"];
      state = data["State"];
      mobile = data["Mobile number"];
      location = data["Shop G Map Location"];
    }
  }

  pickImage(bool isLogo) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        if (isLogo) {
          logoImage = File(picked.path);
        } else {
          bannerImage = File(picked.path);
        }
      });
    }
  }

  showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  completeRegistration() async {

    if (description.text.isEmpty) {
      showSnack("Fill description");
      return;
    }

    if (logoImage == null || bannerImage == null) {
      showSnack("Upload logo and banner");
      return;
    }

    if (!agree) {
      showSnack("Please accept agreement");
      return;
    }

    setState(() => loading = true);

    /// Upload Logo
    final logoRef =
    FirebaseStorage.instance.ref("dealerProfile/$uid/logo.jpg");

    await logoRef.putFile(logoImage!);
    logoUrl = await logoRef.getDownloadURL();

    /// Upload Banner
    final bannerRef =
    FirebaseStorage.instance.ref("dealerProfile/$uid/banner.jpg");

    await bannerRef.putFile(bannerImage!);
    bannerUrl = await bannerRef.getDownloadURL();

    /// Account Created Month
    String created =
    DateFormat("MMM yyyy").format(DateTime.now());

    /// Save to shopDetails
    DatabaseReference detailsRef = FirebaseDatabase.instance
        .ref("carzoDealers/shopDetails/$uid/data");

    await detailsRef.set({
      "Shop name": shopName,
      "Logo": logoUrl,
      "Banner": bannerUrl,
      "City": city,
      "District": district,
      "State": state,
      "Mobile number": mobile,
      "Location": location,
      "Discription": description.text,
      "No of rating": 0,
      "Total rating": 0,
      "Account Created": created,
    });

    /// Save to shopLists
    DatabaseReference listRef =
    FirebaseDatabase.instance.ref("carzoDealers/shopLists/$uid");

    await listRef.set({
      "Shop name": shopName,
      "Logo": logoUrl,
      "Place": city,
    });

    /// TinyDB Save
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString("open", "home");

    setState(() => loading = false);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen()),
            (route) => false);
  }

  Future<bool> onBack() async {
    return false; // disable back
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onBack,
      child: Scaffold(
        appBar: AppBar(title: const Text("Complete Registration")),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [

                TextField(
                  controller: description,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Shop Description",
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => pickImage(true),
                  child: const Text("Upload Logo"),
                ),

                ElevatedButton(
                  onPressed: () => pickImage(false),
                  child: const Text("Upload Banner"),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(
                        value: agree,
                        onChanged: (v) {
                          setState(() {
                            agree = v!;
                          });
                        }),
                    const Expanded(
                        child: Text(
                            "I confirm that all information is correct")),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: completeRegistration,
                  child: const Text("Complete Registration"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}