import 'package:flutter/material.dart';
import 'package:odo_delivery_partner/login.dart';

class MemberOrdersScreen extends StatefulWidget {
  const MemberOrdersScreen({super.key});

  @override
  State<MemberOrdersScreen> createState() => _MemberOrdersScreenState();
}

class _MemberOrdersScreenState extends State<MemberOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> orders = [
      {
        "id": "-Ob80fx4_UQqjtSTH9ek",
        "GST": "1234",
        "area": "NOIDA",
        "contact": "8743907244",
        "delivery-latitude": "28.569466",
        "delivery-longitude": "77.384375",
        "deviceToken": "",
        "items": [
          {
            "brand": "OREO",
            "discount_percentage": 15,
            "item": "OREO VANILLA RS 10 x 12",
            "price": 6000,
            "priceAfterDiscount": 5100.0,
            "quantity": 50,
          },
          {
            "brand": "OREO",
            "discount_percentage": 15,
            "item": "OREO VANILLA RS 10 x 12",
            "price": 6000,
            "priceAfterDiscount": 5100.0,
            "quantity": 50,
          },
          {
            "brand": "OREO",
            "discount_percentage": 15,
            "item": "OREO VANILLA RS 10 x 12",
            "price": 6000,
            "priceAfterDiscount": 5100.0,
            "quantity": 50,
          },
          {
            "brand": "OREO",
            "discount_percentage": 15,
            "item": "OREO VANILLA RS 10 x 12",
            "price": 6000,
            "priceAfterDiscount": 5100.0,
            "quantity": 50,
          },
          {
            "brand": "OREO",
            "discount_percentage": 15,
            "item": "OREO VANILLA RS 10 x 12",
            "price": 6000,
            "priceAfterDiscount": 5100.0,
            "quantity": 50,
          },
          
        ],
        "orderDate": "9-10-2025",
        "orderTime": "10/9/2025 6:21:25 PM",
        "orderedBy": "POORDAR",
        "shop": "POORDAR STORE",
        "shopAddress": "Bahlolpur Noida 63",
        "status": "out-for-delivery",
        "totalPrice": 6000.0,
        "totalPriceAfterDiscount": 5100.0,
      },
      {
        "id": "-Ob80fx4_UQqjtSTH9ek",
        "GST": "1234",
        "area": "NOIDA",
        "contact": "8743907244",
        "delivery-latitude": "28.569466",
        "delivery-longitude": "77.384375",
        "deviceToken": "",
        "items": [
          {
            "brand": "OREO",
            "discount_percentage": 15,
            "item": "OREO VANILLA RS 10 x 12",
            "price": 6000,
            "priceAfterDiscount": 5100.0,
            "quantity": 50,
          },
        ],
        "orderDate": "9-10-2025",
        "orderTime": "10/9/2025 6:21:25 PM",
        "orderedBy": "POORDAR",
        "shop": "POORDAR STORE",
        "shopAddress": "Bahlolpur Noida 63",
        "status": "out-for-delivery",
        "totalPrice": 6000.0,
        "totalPriceAfterDiscount": 5100.0,
      },
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          automaticallyImplyLeading: false, // we’ll add our custom back button
          elevation: 0,
          backgroundColor: Login.primaryColor,
          centerTitle: true,
          title: Text(
            "Orders",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏪 Shop Header
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DUMMY SHOp",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "dummy shoo",
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  "📞 987388288122",
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 🧾 Orders List
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 0, color: Colors.black12),
              itemBuilder: (context, index) {
                final order = orders[index];
                final items = (order["items"] as List<dynamic>? ?? []);
                final previewItems = items.take(2).toList();
                final remaining = items.length - previewItems.length;

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/orderDetails',
                      arguments: order,
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🧾 Serial number + total price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "₹${order["totalPriceAfterDiscount"]?.toStringAsFixed(0) ?? "--"}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // 📦 Items preview
                        const Text(
                          "Items:",
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...previewItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              bottom: 2,
                              right: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "• ",
                                  style: TextStyle(fontSize: 13.5),
                                ),
                                Expanded(
                                  child: Text(
                                    item["item"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        if (remaining > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 2),
                            child: Text(
                              "(+$remaining more)",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ),

                        const SizedBox(height: 6),

                        // 🆔 Order ID
                        Text(
                          "🆔 ${order["id"] ?? 'No ID'}",
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.black54,
                          ),
                        ),

                        // 👉 Click hint
                        const SizedBox(height: 4),
                        Text(
                          "👉 Click to open full details",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
