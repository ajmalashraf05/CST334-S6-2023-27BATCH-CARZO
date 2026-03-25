import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShopHorizontalList extends StatelessWidget {
  const ShopHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {

    DatabaseReference shopRef =
    FirebaseDatabase.instance.ref("carzoDealers/shopLists");

    return SizedBox(
      height: 120,
      child: StreamBuilder(
        stream: shopRef.onValue,
        builder: (context, snapshot) {

          if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No Shops"));
          }

          Map data = snapshot.data!.snapshot.value as Map;

          List keys = data.keys.toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: keys.length,
            itemBuilder: (context, index) {

              String key = keys[index];

              String logo = data[key]["Logo"]
                  .toString()
                  .replaceAll('"', '');

              String shop = data[key]["Shop name"]
                  .toString()
                  .replaceAll('"', '');

              String place = data[key]["Place"]
                  .toString()
                  .replaceAll('"', '');

              return Container(
                width: 150,
                margin: const EdgeInsets.only(left: 10),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(logo),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        shop,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),

                      Text(
                        place,
                        style: const TextStyle(
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}