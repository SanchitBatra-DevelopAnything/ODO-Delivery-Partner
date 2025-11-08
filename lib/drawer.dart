import 'package:flutter/material.dart';

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
    color: Color(0xFF2C2455),
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
          "ODO Sales Executive",
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
            leading: Icon(Icons.person),
            title: Text("Members"),
            onTap: () {
              //remove all routes and go to members
              Navigator.pushNamedAndRemoveUntil(
                  context, '/members', (route) => false);
            }
          ),
          ListTile(
            leading: Icon(Icons.factory),
            title: Text("Orders"),
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