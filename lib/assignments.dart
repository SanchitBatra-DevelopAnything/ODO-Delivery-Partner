import 'package:flutter/material.dart';
import 'package:odo_delivery_partner/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:odo_delivery_partner/drawer.dart'; // your sidebar

class MyAssignmentsScreen extends StatefulWidget {
  const MyAssignmentsScreen({super.key});
  static const Color primaryColor = Color(0xFFF58220);

  @override
  State<MyAssignmentsScreen> createState() => _MyAssignmentsScreenState();
}

class _MyAssignmentsScreenState extends State<MyAssignmentsScreen> {
  final List<Map<String, dynamic>> assignments = [
    {
      "shop": "Shop A",
      "orderIds": ["order_1", "order_2"],
      "totalAmount": 450,
      "referrerName": "Ramesh",
      "referrerContact": "9876543210",
      "delivery-latitude": "28.6139",
      "delivery-longitude": "77.2090",
    },
    {
      "shop": "Shop B",
      "orderIds": ["order_3"],
      "totalAmount": 300,
      "referrerName": "Suresh",
      "referrerContact": "9123456789",
      "delivery-latitude": "28.6448",
      "delivery-longitude": "77.2167",
    },
  ];

  Future<void> openInGoogleMaps(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true, // 👈 removes the AppBar’s top padding
      child: Scaffold(
        drawer: const Sidebar(),
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          toolbarHeight: 56,
          elevation: 1,
          centerTitle: true,
          backgroundColor: Login.primaryColor,
          iconTheme: const IconThemeData(color: Colors.black87),
          title: const Text(
            "My Assignments",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final shop = assignments[index];

            return Card(
              elevation: 2,
              shadowColor: Colors.black12,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            shop["shop"],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          "₹${shop["totalAmount"]}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .orange
                            .shade50, // subtle background for clarity
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        "In case of any issues, please contact:\n",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${shop["referrerName"]} (${shop["referrerContact"]})",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () {
                          final lat = double.parse(shop["delivery-latitude"]);
                          final lng = double.parse(shop["delivery-longitude"]);
                          openInGoogleMaps(lat, lng);
                        },
                        icon: const Icon(Icons.navigation_outlined, size: 18),
                        label: const Text(
                          "Maps",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
