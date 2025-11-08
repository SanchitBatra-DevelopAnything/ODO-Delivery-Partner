import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier
{
  Map<String, dynamic> ordersMetaData = {};
  bool isLoading = false;
  Map<String , dynamic> memberOrders = {};

  //create a getter for memberOrders where you give a copy of it
  Map<String, dynamic> get getMemberOrders {
    return {...memberOrders};
  }

  Future<void> fetchOrderMetadata(String deliveryPartnerId) async {
    isLoading = true;
    ordersMetaData = {}; // clear old data
    notifyListeners();

    print("Fetching order metadata for deliveryPartnerId = $deliveryPartnerId");

    try {
      // 👇 replace with your actual Firebase Function endpoint
      final url = Uri.parse(
        "https://getassignedordersmetadata-jipkkwipyq-uc.a.run.app"
        "?deliveryPartnerId=" + deliveryPartnerId,
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Convert list into a map for easy lookup by shop name
        ordersMetaData = {
          "shops": data,
        };
        print("Fetched ${data.length} shops for deliveryPartnerId: $deliveryPartnerId");
      } else {
        print("Error fetching metadata: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception while fetching metadata: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMemberOrders(List<String> orderIds) async {
  isLoading = true;
  memberOrders = {}; // 👈 clear old data first
  notifyListeners();

  const String url = "https://getordersbyids-jipkkwipyq-uc.a.run.app";

  try {
    final requestBody = {"orderIds": orderIds};

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      memberOrders = {"orders": data};
    } else {
      print("❌ Error: ${response.statusCode}");
      memberOrders = {"orders": []};
    }
  } catch (e) {
    print("🚨 Exception fetching member orders: $e");
    memberOrders = {"orders": []};
  }

  isLoading = false;
  notifyListeners();
}


}