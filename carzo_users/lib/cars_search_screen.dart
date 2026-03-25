import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'car_details_screen.dart';

class CarsSearchScreen extends StatefulWidget {
  const CarsSearchScreen({super.key});

  @override
  State<CarsSearchScreen> createState() =>
      _CarsSearchScreenState();
}

class _CarsSearchScreenState
    extends State<CarsSearchScreen> {

  DatabaseReference carRef =
  FirebaseDatabase.instance.ref("carzoDealers/carLists");

  List allCars = [];
  List filteredCars = [];

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  void loadCars() async {
    DataSnapshot snap = await carRef.get();

    if (snap.exists) {
      Map data = snap.value as Map;

      allCars = data.entries.toList();
      filteredCars = allCars;

      setState(() {});
    }
  }

  void search(String text) {

    if (text.isEmpty) {
      filteredCars = allCars;
    } else {
      filteredCars = allCars.where((car) {

        String name = car.value["Car name"]
            .toString()
            .replaceAll('"', '')
            .toLowerCase();

        return name.contains(text.toLowerCase());

      }).toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Cars"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search car...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(10)),
              ),
            ),
          ),

          Expanded(
            child: filteredCars.isEmpty
                ? const Center(child: Text("No Cars"))
                : ListView.builder(
              itemCount: filteredCars.length,
              itemBuilder: (context, index) {

                var car = filteredCars[index];

                String carId = car.key;

                String name =
                car.value["Car name"]
                    .toString()
                    .replaceAll('"', '');

                String price =
                car.value["Price"]
                    .toString()
                    .replaceAll('"', '');

                String desc =
                car.value["Description"]
                    .toString()
                    .replaceAll('"', '');

                String image =
                car.value["Image"]
                    .toString()
                    .replaceAll('"', '');

                String uid =
                car.value["UID"]
                    .toString()
                    .replaceAll('"', '');

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                CarDetailsScreen(
                                    carId: carId,
                                    uid: uid)));
                  },
                  child: Card(
                    margin:
                    const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [

                        Image.network(image,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.cover),

                        Padding(
                          padding:
                          const EdgeInsets.all(
                              10),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [

                              Text(name,
                                  style:
                                  const TextStyle(
                                      fontSize:
                                      18,
                                      fontWeight:
                                      FontWeight
                                          .bold)),

                              Text(desc),

                              const SizedBox(
                                  height: 5),

                              Text("₹ $price",
                                  style:
                                  const TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      color: Colors
                                          .green)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}