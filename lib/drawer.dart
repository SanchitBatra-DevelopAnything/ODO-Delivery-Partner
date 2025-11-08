import 'package:flutter/material.dart';
import 'package:odo_delivery_partner/login.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
  decoration: const BoxDecoration(
    color: Login.primaryColor,
  ),
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12), // Optional: rounded corners
          child: Image.asset(
            'assets/logo.jpeg',
            height: 80,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "ODO Delivery Partner",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
),
          ListTile(
            leading: Icon(Icons.factory),
            title: Text("Orders"),
            onTap: () {
              //remove all routes and go to members
              Navigator.pushNamedAndRemoveUntil(
                  context, '/assignments', (route) => false);
            }
          ),
          ListTile(
            leading: Icon(Icons.currency_rupee),
            title: Text("Store Balance"),
            onTap: () {
              //remove all routes and go to members
              Navigator.pushNamedAndRemoveUntil(
                  context, '/orders', (route) => false);
            }
          ),
        ],
      ),);
  }
}