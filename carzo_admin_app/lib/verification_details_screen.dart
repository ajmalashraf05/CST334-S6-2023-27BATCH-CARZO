import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class VerificationDetailsScreen extends StatefulWidget {
  final String uid;

  const VerificationDetailsScreen({super.key, required this.uid});

  @override
  State<VerificationDetailsScreen> createState() =>
      _VerificationDetailsScreenState();
}

class _VerificationDetailsScreenState
    extends State<VerificationDetailsScreen> {

  Map? dealerData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Dealer requests/${widget.uid}");

    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      dealerData = Map.from(snapshot.value as Map);
    }

    setState(() {
      loading = false;
    });
  }

  void updateStatus(String status) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Dealer requests/${widget.uid}");

    await ref.update({
      "Approval status": status,
    });

    Navigator.pop(context);
  }

  Widget infoTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text("$title : $value",
          style: const TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification"),
        backgroundColor: Colors.black,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : dealerData == null
          ? const Center(child: Text("No Data"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            const Text("Business details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            infoTile("Shop name",
                dealerData!["Shop name"]),
            infoTile("Shop owner name",
                dealerData!["Shop owner name"]),
            infoTile("Year of establish",
                dealerData!["Year of establish"]),

            const SizedBox(height: 20),

            const Text("Contact details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            infoTile("Mobile number",
                dealerData!["Mobile number"]),
            infoTile("Whatsapp number",
                dealerData!["Whatsapp number"]),
            infoTile("Alternative number",
                dealerData!["Alternative number"]),

            const SizedBox(height: 20),

            const Text("Location details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            infoTile(
                "City", dealerData!["City"]),
            infoTile("District",
                dealerData!["District"]),
            infoTile(
                "State", dealerData!["State"]),
            infoTile("Pincode",
                dealerData!["Pincode"]),
            infoTile(
                "Shop G Map Location",
                dealerData!["Shop G Map Location"]),

            const SizedBox(height: 20),

            const Text("Verification documents",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            const Text("ID Proof"),
            const SizedBox(height: 5),

            Image.network(
                dealerData!["Id proof"]),

            const SizedBox(height: 15),

            const Text("GST Proof"),
            const SizedBox(height: 5),

            Image.network(
                dealerData!["GST proof"]),

            const SizedBox(height: 20),

            const Text("Signup details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            infoTile(
                "Email id",
                dealerData!["Email id"]),
            infoTile(
                "Timestamp",
                dealerData!["Timestamp"]),
            infoTile(
                "Approval status",
                dealerData!["Approval status"]),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding:
                    const EdgeInsets.all(15)),
                onPressed: () {
                  updateStatus("Approved");
                },
                child: const Text("Approve"),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                    const EdgeInsets.all(15)),
                onPressed: () {
                  updateStatus("Rejected");
                },
                child: const Text("Reject"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}