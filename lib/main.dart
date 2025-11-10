import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odo_delivery_partner/assignments.dart';
import 'package:odo_delivery_partner/login.dart';
import 'package:odo_delivery_partner/memberOrders.dart';
import 'package:odo_delivery_partner/orderDetail.dart';
import 'package:odo_delivery_partner/providers/auth.dart';
import 'package:odo_delivery_partner/providers/member.dart';
import 'package:odo_delivery_partner/providers/order.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MembersProvider()),
        ChangeNotifierProvider(create: (context) => OrdersProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MaterialAppWithInitialRoute(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MaterialAppWithInitialRoute extends StatelessWidget {
  const MaterialAppWithInitialRoute({Key? key}) : super(key: key);

  Future<String> getInitialRoute() async {
    return '/';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInitialRoute(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final route = snapshot.data?.toString() ?? '/';
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ODO Delivery Partner',
            theme: ThemeData(primarySwatch: Colors.blue),
            initialRoute: route,
            routes: {
              '/': (context) => const Login(),
              '/assignments': (context) => const MyAssignmentsScreen(),
              '/orders': (context) => const MemberOrdersScreen(),
              '/detail':(context)=> const OrderDetailsScreen(),
            },
          );
        }

        /// ✅ Loader while app decides initial screen
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
