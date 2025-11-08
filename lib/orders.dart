// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:odo_delivery_partner/drawer.dart';
// import 'package:odo_delivery_partner/providers/auth.dart';
// import 'package:odo_delivery_partner/providers/order.dart';
// import 'package:provider/provider.dart';

// class Orders extends StatefulWidget {
//   const Orders({super.key});

//   @override
//   State<Orders> createState() => _OrdersState();
// }

// class _OrdersState extends State<Orders> {

//   bool _isFirstTime = true;
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     if (_isFirstTime) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
//         final referrerId = Provider.of<AuthProvider>(context, listen: false).loggedInDeliveryPartner?['id'];
//         final todaysDate = DateTime.now();
//         String formattedDate = todaysDate.day.toString()+"-"+todaysDate.month.toString()+"-"+todaysDate.year.toString();
//         ordersProvider.fetchOrderData(formattedDate , referrerId);
//       });
//       _isFirstTime = false;
//   }
//   }


//   //  var orderData = {"orders" : [{"orderedFrom" : "Store A" , "status" : "delivered" , "amount" : 3500.0} , 
//   //                    {"orderedFrom" : "Store B" , "status" : "pending" , "amount" : 1500.0} ,
//   //                    {"orderedFrom" : "Store C" , "status" : "out-for-delivery" , "amount" : 2500.0},
//   //                    {"orderedFrom" : "Store C" , "status" : "out-for-delivery" , "amount" : 2500.0},
//   //                    {"orderedFrom" : "Store C" , "status" : "out-for-delivery" , "amount" : 2500.0},
//   //                    {"orderedFrom" : "Store C" , "status" : "pending" , "amount" : 2500.0},
//   //                    {"orderedFrom" : "Store D" , "status" : "delivered" , "amount" : 2500.0}],
//   //                    "totalAmount" : 17500.0
//   //  };


//   Widget _buildStatusChip(String status) {
//   Color bgColor;
//   Color textColor = Colors.white;

//   switch (status) {
//     case "pending":
//       bgColor = Colors.pink.shade200;
//       break;
//     case "out-for-delivery":
//       bgColor = Colors.lightGreenAccent.shade400;
//       textColor = Colors.black;
//       break;
//     case "delivered":
//       bgColor = Colors.green;
//       break;
//     default:
//       bgColor = Colors.grey;
//   }

//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//     decoration: BoxDecoration(
//       color: bgColor,
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Text(
//       status.toUpperCase(),
//       style: TextStyle(
//         color: textColor,
//         fontWeight: FontWeight.bold,
//         fontSize: 12,
//       ),
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     final ordersProvider = Provider.of<OrdersProvider>(context);
//     final orders = ordersProvider.ordersData["orders"] ?? [];
//     final totalAmount = ordersProvider.ordersData["totalAmount"];
//     final referrerId = Provider.of<AuthProvider>(context, listen: false).loggedInDeliveryPartner?['id'];
//     return MediaQuery.removePadding(
//     context: context,
//     removeTop: true,
//     child: Scaffold(
//       drawer: Sidebar(),
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "My Orders",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: const Color(0xFF2C2455),
//         actions: [
//     IconButton(
//       icon: const Icon(Icons.calendar_today, color: Colors.white),
//       onPressed: () async {
//   DateTime today = DateTime.now();
//   DateTime minDate = today.subtract(const Duration(days: 2));
//   DateTime initialDate =
//       ordersProvider.selectedDate != null ? ordersProvider.selectedDate! : today;

//   DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: initialDate,
//     firstDate: minDate,
//     lastDate: today,
//     builder: (context, child) => Theme(
//       data: Theme.of(context).copyWith(
//         colorScheme: const ColorScheme.light(
//           primary: Color(0xFF2C2455), // Your purple color ✅
//         ),
//       ),
//       child: child!,
//     ),
//   );

//   if (pickedDate != null) {

//     final dateString = pickedDate.day.toString() + "-" + pickedDate.month.toString() + "-" + pickedDate.year.toString();

//     Provider.of<OrdersProvider>(context, listen: false)
//         .fetchOrderData(dateString , referrerId);
//   }
// },
//     ),
//   ],
//       ),
//       body: ordersProvider.isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               ) // ✅ Loading state
//             : orders.isEmpty
//             ? const Center(child: Text("No orders found!"))
//             :Column(
//         children: [
//           /// ✅ Total Amount Card
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFF2C2455),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               "Total Amount : ₹ $totalAmount",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),

//           /// ✅ Orders List
//           Expanded(
//             child: ListView.separated(
//               itemCount: orders.length,
//               separatorBuilder: (_, __) => const Divider(height: 1),
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 final shop = order["orderedFrom"];
//                 final status = order["status"];

//                 return ListTile(
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                   leading: const Icon(Icons.storefront, size: 30),
//                   title: Text(
//                     shop,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   trailing: _buildStatusChip(status),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
//   }
// }