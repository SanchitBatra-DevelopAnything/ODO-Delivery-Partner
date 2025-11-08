import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MembersProvider with ChangeNotifier {
  List<String> membersForMe = [];
  bool isLoading = false;

  Future<void> fetchMyMembers(String referrerId) async {
    isLoading = true;
    notifyListeners();

    print("Referrer id "+ referrerId);

    try {
      final url = Uri.parse(
        "https://getdistributorsbyreferrer-jipkkwipyq-uc.a.run.app/?referrerId=$referrerId", 
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        /// Cast dynamic list → List<String>
        membersForMe = data.map((m) => m.toString()).toList();
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchMyMembers error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
