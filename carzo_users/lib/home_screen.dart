import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'car_details_screen.dart';
import 'cars_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  DatabaseReference shopRef =
  FirebaseDatabase.instance.ref("carzoDealers/shopLists");

  DatabaseReference carRef =
  FirebaseDatabase.instance.ref("carzoDealers/carLists");

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Carzo"),
        backgroundColor: Colors.black,
      ),

      body: currentIndex == 0
          ? homeBody()
          : currentIndex == 1
          ? const CarsSearchScreen()
          : const Center(child: Text("Profile Coming")),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car), label: "Cars"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget homeBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.all(10),
            child: Text("Used Car Shops",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),

          /// ⭐ Horizontal Shops List
          SizedBox(
            height: 120,
            child: StreamBuilder(
              stream: shopRef.onValue,
              builder: (context, snapshot) {

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text("No Shops"));
                }

                Map data =
                snapshot.data!.snapshot.value as Map;

                List keys = data.keys.toList();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: keys.length,
                  itemBuilder: (context, index) {

                    String key = keys[index];

                    String logo = data[key]["Logo"]
                        .toString()
                        .replaceAll('"', '');

                    String shop =
                    data[key]["Shop name"]
                        .toString()
                        .replaceAll('"', '');

                    String place =
                    data[key]["Place"]
                        .toString()
                        .replaceAll('"', '');

                    return Container(
                      width: 150,
                      margin:
                      const EdgeInsets.only(left: 10),
                      child: Card(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [

                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                              NetworkImage(logo),
                            ),

                            const SizedBox(height: 5),

                            Text(shop,
                                style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold)),

                            Text(place,
                                style: const TextStyle(
                                    color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.all(10),
            child: Text("Used Cars",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),

          /// ⭐ Vertical Car List
          StreamBuilder(
            stream: carRef.onValue,
            builder: (context, snapshot) {

              if (!snapshot.hasData ||
                  snapshot.data!.snapshot.value == null) {
                return const Center(child: Text("No Cars"));
              }

              Map data =
              snapshot.data!.snapshot.value as Map;

              List keys = data.keys.toList();

              return ListView.builder(
                itemCount: keys.length,
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {

                  String key = keys[index];

                  String name =
                  data[key]["Car name"]
                      .toString()
                      .replaceAll('"', '');

                  String price =
                  data[key]["Price"]
                      .toString()
                      .replaceAll('"', '');

                  String desc =
                  data[key]["Description"]
                      .toString()
                      .replaceAll('"', '');

                  String image =
                  data[key]["Image"]
                      .toString()
                      .replaceAll('"', '');

                  String uid =
                  data[key]["UID"]
                      .toString()
                      .replaceAll('"', '');

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CarDetailsScreen(
                                      carId: key,
                                      uid: uid)));
                    },
                    child: Card(
                      margin:
                      const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Image.network(image,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover),

                          Padding(
                            padding:
                            const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [

                                Text(name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .bold)),

                                const SizedBox(height: 5),

                                Text(desc),

                                const SizedBox(height: 5),

                                Text("₹ $price",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color:
                                        Colors.green)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}