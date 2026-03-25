import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'verification_details_screen.dart';

class PendingListScreen extends StatelessWidget {
  const PendingListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    DatabaseReference ref =
    FirebaseDatabase.instance.ref("Dealer requests");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Verification"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No Requests"));
          }

          Map data =
          snapshot.data!.snapshot.value as Map;

          List keys = data.keys.toList();

          List pendingKeys = [];

          for (var k in keys) {
            if (data[k]["Approval status"] == "Pending") {
              pendingKeys.add(k);
            }
          }

          if (pendingKeys.isEmpty) {
            return const Center(
              child: Text("No Pending Requests"),
            );
          }

          return ListView.builder(
            itemCount: pendingKeys.length,
            itemBuilder: (context, index) {

              String uid = pendingKeys[index];

              return Card(
                child: ListTile(
                  title: Text(uid),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VerificationDetailsScreen(uid: uid),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}