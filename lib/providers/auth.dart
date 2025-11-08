import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
   Map<String, dynamic>? loggedInDeliveryPartner;
   Map<String , dynamic> _deliveryPartnerCredentials = {};
   bool isDeliveryPartnerDataLoaded = false;

  Future<void> fetchDeliveryPartnerAccounts() async {
    isDeliveryPartnerDataLoaded = false;
    print("Fetching partner accounts...");
  try {
    final url = Uri.parse(
      "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/deliveryPartners.json",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Clear old values before refreshing the map
      _deliveryPartnerCredentials.clear();

      data.forEach((key, partner) {
        final contact = partner['contact'];
        if (contact != null) {
          // insert: contact → deliveryPartner object
          _deliveryPartnerCredentials[contact] = {
            "id": key,
            "partnerName": partner["partnerName"],
            "contact" : partner["contact"]
          };
        }
      });

      print(_deliveryPartnerCredentials);
      isDeliveryPartnerDataLoaded = true;
      notifyListeners();
    } else {
      print("Error status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
  }


  bool loginDeliveryPartner(String contact) {
    if (_deliveryPartnerCredentials.containsKey(contact)) {
      final partner = _deliveryPartnerCredentials[contact];
      if (partner != null) {
        loggedInDeliveryPartner = {
          "id": partner["id"],
          "partnerName": partner["partnerName"],
          "contact": partner["contact"]
        };
        notifyListeners();
        return true;
      } 
    } else {
      print("No partner found with contact: $contact");
    }
    return false;
  }
}