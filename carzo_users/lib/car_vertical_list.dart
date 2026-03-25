import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'car_details_screen.dart';

class CarVerticalList extends StatelessWidget {
  const CarVerticalList({super.key});

  @override
  Widget build(BuildContext context) {

    DatabaseReference carRef =
    FirebaseDatabase.instance.ref("carzoDealers/carLists");

    return StreamBuilder(
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
          physics: const NeverScrollableScrollPhysics(),
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
                              uid: uid,
                            )));
              },
              child: Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(
                          top: Radius.circular(12)),
                      child: Image.network(
                        image,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Text(name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold)),

                          const SizedBox(height: 5),

                          Text(desc),

                          const SizedBox(height: 5),

                          Text("₹ $price",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.bold,
                                  color: Colors.green)),
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
    );
  }
}