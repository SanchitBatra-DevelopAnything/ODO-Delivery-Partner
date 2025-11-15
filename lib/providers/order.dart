import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier
{
  Map<String, dynamic> ordersMetaData = {};
  bool isLoading = false;
  Map<String , dynamic> memberOrders = {};
  Map<String , dynamic> storeBalanceData = {};

  List<dynamic> get getMemberOrders {
  final orders = memberOrders["orders"];
  if (orders is List) return orders;
  return []; // ✅ Always return an empty list if null or invalid
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

Future<bool> rejectOrder(
    String orderId,
    String status,
    String choice,
    String imageUrl,
  ) async {
    final url = Uri.parse("https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/activeDistributorOrders/$orderId.json");

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "status": status,
          "imageUrl": imageUrl,
          "rejectionReason": choice,
          "rejectedAt" : DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("✅ Order $orderId updated successfully.");
        return true;
      } else {
        print("❌ Failed to update order $orderId. Status: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Exception during order update: $e");
      rethrow;
    }
  }


  Future<bool> deliverOrder(
    String orderId,
    String status,
    String choice,
    String imageUrl,
  ) async {
    final url = Uri.parse("https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/activeDistributorOrders/$orderId.json");

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "status": status,
          "imageUrl": imageUrl,
          "paymentType": choice,
          "deliveredAt" : DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("✅ Order $orderId updated successfully.");
        return true;
      } else {
        print("❌ Failed to update order $orderId. Status: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Exception during order update: $e");
      rethrow;
    }
  }


  Future<void> fetchStoreBalance(String deliveryPartnerId) async {
  isLoading = true;
  storeBalanceData = {}; 
  notifyListeners();

  print("Fetching store balance data for deliveryPartnerId = $deliveryPartnerId");

  try {
    final url = Uri.parse(
      "https://getstorebalance-jipkkwipyq-uc.a.run.app"
      "?partnerId=$deliveryPartnerId",   // ensure query param matches backend
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json =
          jsonDecode(response.body);

      // Convert EXACTLY into required map format
      storeBalanceData = {
        "totalHisaab": json["totalHisaab"] ?? 0,
        "data": Map<String, dynamic>.from(json["data"] ?? {}),
      };

      print("Store balance fetched successfully:");
      print(storeBalanceData);
    } else {
      print("Error fetching store balance: ${response.statusCode}");
    }
  } catch (e) {
    print("Exception while fetching store balance: $e");
  }

  isLoading = false;
  notifyListeners();
}




}