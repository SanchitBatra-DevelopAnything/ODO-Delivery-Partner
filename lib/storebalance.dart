import 'package:flutter/material.dart';
import 'package:odo_delivery_partner/drawer.dart';
import 'package:odo_delivery_partner/login.dart';
import 'package:odo_delivery_partner/providers/auth.dart';
import 'package:odo_delivery_partner/providers/order.dart';
import 'package:odo_delivery_partner/route_observer.dart';
import 'package:provider/provider.dart';

class StoreBalanceScreen extends StatefulWidget {
  const StoreBalanceScreen({super.key});

  @override
  State<StoreBalanceScreen> createState() => _StoreBalanceScreenState();
}

class _StoreBalanceScreenState extends State<StoreBalanceScreen> with RouteAware {



  bool _isSubscribed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isSubscribed) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
      _isSubscribed = true;
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // ✅ Defer provider call until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchStoreBalance();
    });
  }

  @override
  void didPopNext() {
    // ✅ Same here, avoid rebuild conflicts when coming back
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchStoreBalance();
    });
  }

  void _fetchStoreBalance() {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final deliveryPartnerId =
        Provider.of<AuthProvider>(context, listen: false).loggedInDeliveryPartner?['id'];

    if (deliveryPartnerId != null) {
      ordersProvider.fetchStoreBalance(deliveryPartnerId);
    } else {
      print("⚠️ No deliveryPartnerId found.");
    }
  }




  @override
  Widget build(BuildContext context) {

    final ordersProvider = Provider.of<OrdersProvider>(context);
    final Map<dynamic, dynamic> data = ordersProvider.storeBalanceData;

    final Map<String, dynamic> stores =
    Map<String, dynamic>.from(data["data"] ?? {});

    final int totalHisaab = data["totalHisaab"] ?? 0;
    final bool hasNoPending = totalHisaab == 0;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Scaffold(
        drawer: const Sidebar(),
        backgroundColor: const Color(0xFFF9FAFB),

        appBar: AppBar(
          toolbarHeight: 56,
          elevation: 1,
          centerTitle: true,
          backgroundColor: Login.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Store Balance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),

        body: ordersProvider.isLoading ? Center(child: CircularProgressIndicator(color: Login.primaryColor,),) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOTAL HISAAB CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Login.primaryColor,
              child: Text(
                "Total Hisaab: ₹$totalHisaab",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: hasNoPending
                  ? Center(
                      child: Text(
                        "You are all set, No pending balance 😊",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: stores.length,
                      itemBuilder: (context, index) {
                        String storeName = stores.keys.elementAt(index);
                        List orders = stores[storeName]["orders"];

                        int storeTotal = orders.fold(
                            0, (sum, order) => sum + (order["amount"] as int));

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: ExpansionTile(
                            title: Text(
                              storeName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "Total: ₹$storeTotal",
                              style: const TextStyle(fontSize: 15),
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                itemCount: orders.length,
                                itemBuilder: (context, i) {
                                  final order = orders[i];

                                  return ListTile(
                                    leading:
                                        const Icon(Icons.shopping_bag),
                                    title: Text(order["shopName"]),
                                    trailing: Text(
                                      "₹${order['amount']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
