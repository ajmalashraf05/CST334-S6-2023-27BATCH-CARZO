import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {

  final brand = TextEditingController();
  final name = TextEditingController();
  final variant = TextEditingController();
  final year = TextEditingController();
  final km = TextEditingController();
  final price = TextEditingController();
  final fitness = TextEditingController();

  String fuel = "Petrol";
  String transmission = "Manual";
  String accident = "No";
  String ownership = "1";

  bool loading = false;

  File? front;
  File? rear;
  File? left;
  File? right;
  File? cabinF;
  File? cabinR;
  File? view3d;

  final picker = ImagePicker();

  pick(Function(File) setImage) async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => setImage(File(img.path)));
  }

  snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future uploadCar() async {

    if (brand.text.isEmpty) return snack("Enter brand");
    if (name.text.isEmpty) return snack("Enter car name");
    if (price.text.isEmpty) return snack("Enter price");
    if (front == null || rear == null) return snack("Upload images");

    setState(() => loading = true);

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    String uid = prefs.getString("UID")!;

    String carId =
        "${name.text}-${Random().nextInt(99999)}";

    Future<String> upload(File file, String tag) async {
      final ref = FirebaseStorage.instance
          .ref("cars/$uid/$carId/$tag.jpg");

      await ref.putFile(file);
      return await ref.getDownloadURL();
    }

    String frontUrl = await upload(front!, "front");
    String rearUrl = await upload(rear!, "rear");

    String leftUrl =
    left != null ? await upload(left!, "left") : "";
    String rightUrl =
    right != null ? await upload(right!, "right") : "";
    String fCabin =
    cabinF != null ? await upload(cabinF!, "fcabin") : "";
    String rCabin =
    cabinR != null ? await upload(cabinR!, "rcabin") : "";
    String d3 =
    view3d != null ? await upload(view3d!, "3d") : "";

    DatabaseReference ref = FirebaseDatabase.instance
        .ref("carzoDealers/listedCars/$carId");

    await ref.set({
      "Car Brand": brand.text,
      "Car Name": name.text,
      "Car Variant": variant.text,
      "Registered year": year.text,
      "Car Odometer": km.text,
      "Price": price.text,
      "Fitness upto": fitness.text,
      "Transmission": transmission,
      "Car Fuel type": fuel,
      "Accident history": accident,
      "Ownership no": ownership,
      "Front view": frontUrl,
      "Rear view": rearUrl,
      "Left side view": leftUrl,
      "Right side view": rightUrl,
      "Front Interior": fCabin,
      "Rear Interior": rCabin,
      "3D view": d3,
      "Registered state": "Kerala",
      "Service History": "Available"
    });

    DatabaseReference listRef =
    FirebaseDatabase.instance.ref("carzoDealers/carLists/$carId");

    await listRef.set({
      "Car id": carId,
      "Car name": "${brand.text} ${name.text}",
      "Description":
      "${year.text} | $fuel | ${km.text}km",
      "Image": d3.isNotEmpty ? d3 : frontUrl,
      "Price": price.text,
      "UID": uid
    });

    setState(() => loading = false);

    snack("Car Uploaded Successfully");
    Navigator.pop(context);
  }

  Widget imgBtn(String title, Function(File) setImage) {
    return ElevatedButton(
        onPressed: () => pick(setImage),
        child: Text(title));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Add Car")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(controller: brand,
                decoration: const InputDecoration(labelText: "Brand")),
            TextField(controller: name,
                decoration: const InputDecoration(labelText: "Car Name")),
            TextField(controller: variant,
                decoration: const InputDecoration(labelText: "Variant")),
            TextField(controller: year,
                decoration: const InputDecoration(labelText: "Year")),
            TextField(controller: km,
                decoration: const InputDecoration(labelText: "Odometer")),
            TextField(controller: price,
                decoration: const InputDecoration(labelText: "Price")),
            TextField(controller: fitness,
                decoration: const InputDecoration(labelText: "Fitness Upto")),

            const SizedBox(height: 10),

            DropdownButton<String>(
              value: fuel,
              onChanged: (v) => setState(() => fuel = v!),
              items: ["Petrol", "Diesel", "EV"]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),

            DropdownButton<String>(
              value: transmission,
              onChanged: (v) =>
                  setState(() => transmission = v!),
              items: ["Manual", "Automatic"]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                imgBtn("Front", (f) => front = f),
                imgBtn("Rear", (f) => rear = f),
                imgBtn("Left", (f) => left = f),
                imgBtn("Right", (f) => right = f),
                imgBtn("Front Cabin", (f) => cabinF = f),
                imgBtn("Rear Cabin", (f) => cabinR = f),
                imgBtn("3D View", (f) => view3d = f),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: uploadCar,
                child: const Text("Upload Car"))
          ],
        ),
      ),
    );
  }
}