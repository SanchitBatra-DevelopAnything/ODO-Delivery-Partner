import 'package:flutter/material.dart';
import 'package:odo_delivery_partner/login.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  static const Color primaryColor = Color(0xFF58220); 
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

void showAlertDialog(
  BuildContext context,
  String message, {
  bool shouldShowReasons = false,
  VoidCallback? onOkPressed,
  VoidCallback? onClickShopPhoto,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String? selectedReason;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text(
              "REJECT?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // 🔽 Show reasons dropdown only if shouldShowReasons = true
                if (shouldShowReasons) ...[
                  const Text(
                    "Select reason for rejection:",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedReason,
                    items: const [
                      DropdownMenuItem(
                          value: "No Payment.", child: Text("No Payment.")),
                      DropdownMenuItem(
                          value: "Partial delivery.",
                          child: Text("Partial delivery.")),
                      DropdownMenuItem(
                          value: "Damaged product.",
                          child: Text("Damaged product.")),
                      DropdownMenuItem(
                          value: "Asking for credit.",
                          child: Text("Asking for credit.")),
                      DropdownMenuItem(
                          value: "Shop closed.", child: Text("Shop closed.")),
                      DropdownMenuItem(
                          value: "Fake order.", child: Text("Fake order.")),
                      DropdownMenuItem(
                          value: "Others (I will explain)",
                          child: Text("Others (I will explain)")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                    ),
                  ),
                ],
              ],
            ),

            // 🎯 Conditional Buttons
            actions: [
              if (!shouldShowReasons)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onOkPressed != null) onOkPressed();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              if (shouldShowReasons && selectedReason != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Login.primaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onClickShopPhoto != null) onClickShopPhoto();
                  },
                  child: const Text(
                    "Click Shop Photo",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
            ],
          );
        },
      );
    },
  );
}


class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
 // same as Login.primaryColor
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> order =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<dynamic> items = order["items"] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Login.primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
            "Order Detail",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        elevation: 2,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏪 Shop Info (Minimal)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order["shop"] ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Ordered By: ${order["orderedBy"] ?? ""}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📦 Items (Simplified layout)
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Quantity × Item Name
                          Flexible(
                            child: Text(
                              "${item["quantity"]} × ${item["item"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          // Price after discount
                          Text(
                            "₹${item["priceAfterDiscount"].toString()}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // 💰 Total Bill
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Login.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Bill",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600 , color: Colors.white),
                  ),
                  Text(
                    "₹${order["totalPriceAfterDiscount"].toString()}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🚦 Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // Handle collected payment
                    },
                    child: const Text(
                      "Collected Payment",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16 , color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // Handle order rejected
                      showAlertDialog(context , "Shop ki photo kheechke daalo" , shouldShowReasons: true);
                    },
                    child: const Text(
                      "Order Rejected",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16 , color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
