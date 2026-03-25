import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailsScreen extends StatefulWidget {
  final String carId;
  final String uid;

  const CarDetailsScreen(
      {super.key, required this.carId, required this.uid});

  @override
  State<CarDetailsScreen> createState() =>
      _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {

  Map? carData;
  String dealerNumber = "";
  bool loading = true;

  List<String> images = [];
  int currentImage = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {

    /// Fetch Car Details
    DatabaseReference carRef = FirebaseDatabase.instance
        .ref("carzoDealers/listedCars/${widget.carId}");

    DataSnapshot carSnap = await carRef.get();

    if (carSnap.exists) {
      carData = Map.from(carSnap.value as Map);

      images = [
        carData!["Front view"] ?? "",
        carData!["Rear view"] ?? "",
        carData!["Left side view"] ?? "",
        carData!["Right side view"] ?? "",
        carData!["Front Interior"] ?? "",
        carData!["Rear Interior"] ?? "",
        carData!["3D view"] ?? "",
      ];
    }

    /// Fetch Dealer Mobile Number
    DatabaseReference dealerRef = FirebaseDatabase.instance
        .ref("carzoDealers/shopDetails/${widget.uid}/data");

    DataSnapshot dealerSnap = await dealerRef.get();

    if (dealerSnap.exists) {
      Map d = Map.from(dealerSnap.value as Map);
      dealerNumber = d["Mobile number"].toString();
    }

    setState(() {
      loading = false;
    });
  }

  void callDealer() async {
    Uri url = Uri.parse("tel:$dealerNumber");
    await launchUrl(url);
  }

  void nextImage() {
    if (currentImage < images.length - 1) {
      setState(() {
        currentImage++;
      });
    }
  }

  void prevImage() {
    if (currentImage > 0) {
      setState(() {
        currentImage--;
      });
    }
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold))),
          Expanded(child: Text(value))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Details"),
        backgroundColor: Colors.black,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : carData == null
          ? const Center(child: Text("No Data"))
          : Column(
        children: [

          /// ⭐ IMAGE SLIDER
          SizedBox(
            height: 250,
            child: Stack(
              children: [

                Positioned.fill(
                  child: Image.network(
                    images[currentImage]
                        .toString()
                        .replaceAll('"', ''),
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  left: 10,
                  top: 100,
                  child: IconButton(
                    icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white),
                    onPressed: prevImage,
                  ),
                ),

                Positioned(
                  right: 10,
                  top: 100,
                  child: IconButton(
                    icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white),
                    onPressed: nextImage,
                  ),
                ),
              ],
            ),
          ),

          /// ⭐ DETAILS
          Expanded(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    carData!["Car Name"]
                        .toString()
                        .replaceAll('"', ''),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "₹ ${carData!["Price"]
                        .toString()
                        .replaceAll('"', '')}",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight:
                        FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  infoRow(
                      "Brand",
                      carData!["Car Brand"]
                          .toString()),
                  infoRow(
                      "Variant",
                      carData!["Car Variant"]
                          .toString()),
                  infoRow(
                      "Year",
                      carData!["Registered year"]
                          .toString()),
                  infoRow(
                      "KM",
                      carData!["Car Odometer"]
                          .toString()),
                  infoRow(
                      "Fuel",
                      carData!["Car Fuel type"]
                          .toString()),
                  infoRow(
                      "Transmission",
                      carData!["Transmission"]
                          .toString()),
                  infoRow(
                      "Ownership",
                      carData!["Ownership no"]
                          .toString()),
                  infoRow(
                      "Accident",
                      carData!["Accident history"]
                          .toString()),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style:
                      ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.black,
                          padding:
                          const EdgeInsets
                              .all(15)),
                      onPressed: callDealer,
                      child: const Text(
                          "Call Now"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}