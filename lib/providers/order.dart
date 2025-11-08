import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier
{
  Map<String, dynamic> ordersData = {};
  bool isLoading = false;
  DateTime? selectedDate;


  Future<void> fetchOrderData(String dateString , String referrerId) async {
  isLoading = true;
  selectedDate = _parseDate(dateString);

  // ✅ clear old data right away
  ordersData = {
    "orders": [],
    "totalAmount": 0.0,
  };
  notifyListeners(); // ✅ UI will instantly show fresh loading state
  print("Date String = "+dateString);
  try {
    final url = Uri.parse(
      "https://getordersforreferrerapp-jipkkwipyq-uc.a.run.app/" + "?date=" +dateString.toString() + "&referrerId=" + referrerId.toString(),
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      ordersData = jsonDecode(response.body);
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Exception while fetching orders: $e");
  }

  isLoading = false;
  notifyListeners();
}

DateTime _parseDate(String dateStr) {
  final parts = dateStr.split("-");
  return DateTime(
    int.parse(parts[2]),
    int.parse(parts[1]),
    int.parse(parts[0]),
  );
}

}