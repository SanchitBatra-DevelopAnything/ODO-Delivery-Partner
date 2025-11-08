import 'package:flutter/material.dart';
import 'package:odo_delivery_partner/providers/auth.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static const Color primaryColor = Color(0xFFF58220);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isFirstTime = true;
  TextEditingController contactController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!mounted) {
      print("Returned back");
      return;
    }
    if (_isFirstTime) {
      Provider.of<AuthProvider>(
        context,
        listen: false,
      ).fetchDeliveryPartnerAccounts();
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  // ODO Purple
  @override
  Widget build(BuildContext context) {
    //login button only visible when all refs downloaded for login.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Logo centered
              Image.asset(
                'assets/logo.jpeg', // make sure this path is correct
                height: 120,
              ),
              const SizedBox(height: 20),
              Text(
                "Delivery Partner Login",
                style: TextStyle(
                  color: Login.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // ✅ contact TextField
              TextField(
                controller: contactController,
                decoration: InputDecoration(
                  labelText: "Enter your mobile number",
                  floatingLabelStyle: const TextStyle(color: Login.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Login.primaryColor, // 👈 Border color when focused
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // ✅ Login Button
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  final isEnabled = auth.isDeliveryPartnerDataLoaded;

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEnabled
                            ? Login.primaryColor
                            : Colors.grey,
                      ),
                      onPressed: isEnabled
                          ? () async {
                              final isSuccess = auth.loginDeliveryPartner(
                                contactController.text.trim(),
                              );
                              if (isSuccess) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  "/members",
                                  (route) =>
                                      false, // removes all previous routes
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Login failed. Please check your mobile number and try again.",
                                    ),
                                  ),
                                );
                              }
                            }
                          : null, // ❌ disabled while loading
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
