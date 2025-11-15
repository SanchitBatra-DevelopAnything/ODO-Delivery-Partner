import 'package:flutter/material.dart';
import 'package:odo_delivery_partner/drawer.dart';
import 'package:odo_delivery_partner/login.dart';

class StoreBalanceScreen extends StatelessWidget {
  const StoreBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = {
      "totalHisaab": 15000,
      "data": {
        "store1": {
          "orders": [
            {"shopName": "Shop A", "amount": 5000},
            {"shopName": "Shop B", "amount": 3000}
          ],
        },
        "store2": {
          "orders": [
            {"shopName": "Shop A", "amount": 5000},
            {"shopName": "Shop B", "amount": 3000}
          ],
        },
        "store3": {
          "orders": [
            {"shopName": "Shop A", "amount": 5000},
            {"shopName": "Shop B", "amount": 3000}
          ],
        }
      }
    };

    final stores = data["data"] as Map<String, dynamic>;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Scaffold(
        drawer: const Sidebar(), // 👈 your drawer widget
        backgroundColor: const Color(0xFFF9FAFB),

        appBar: AppBar(
          toolbarHeight: 56,
          elevation: 1,
          centerTitle: true,
          backgroundColor: Login.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Store Balance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOTAL HISAAB CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Login.primaryColor,
              child: Text(
                "Total Hisaab: ₹${data['totalHisaab']}",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  String storeName = stores.keys.elementAt(index);
                  List orders = stores[storeName]["orders"];

                  // calculate store total
                  int storeTotal = orders.fold(
                      0, (sum, order) => sum + (order["amount"] as int));

                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                    child: ExpansionTile(
                      title: Text(
                        storeName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      subtitle: Text(
                        "Total: ₹$storeTotal",
                        style: const TextStyle(fontSize: 15),
                      ),

                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orders.length,
                          itemBuilder: (context, i) {
                            final order = orders[i];

                            return ListTile(
                              leading: const Icon(Icons.shopping_bag),
                              title: Text(order["shopName"]),
                              trailing: Text(
                                "₹${order['amount']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
