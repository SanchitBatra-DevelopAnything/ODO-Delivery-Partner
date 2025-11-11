import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:odo_delivery_partner/login.dart';
import 'package:odo_delivery_partner/providers/order.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  static const Color primaryColor = Color(0xFF58220);
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

void showAlertDialog(
  BuildContext context,
  String heading,
  String message, {
  bool shouldShowReasons = false,
  bool shouldShowPaymentType = false,
  VoidCallback? onOkPressed,
  void Function(String)? onClickShopPhoto,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String? selectedReasonForRejection;
      String? selectedPaymentTypeAtDelivery;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              heading,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),

                // 🔽 Show reasons dropdown only if shouldShowReasons = true
                if (shouldShowReasons) ...[
                  const Text(
                    "Select reason for rejection:",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedReasonForRejection,
                    items: const [
                      DropdownMenuItem(
                        value: "No Payment.",
                        child: Text("No Payment."),
                      ),
                      DropdownMenuItem(
                        value: "Partial delivery.",
                        child: Text("Partial delivery."),
                      ),
                      DropdownMenuItem(
                        value: "Damaged product.",
                        child: Text("Damaged product."),
                      ),
                      DropdownMenuItem(
                        value: "Asking for credit.",
                        child: Text("Asking for credit."),
                      ),
                      DropdownMenuItem(
                        value: "Shop closed.",
                        child: Text("Shop closed."),
                      ),
                      DropdownMenuItem(
                        value: "Fake order.",
                        child: Text("Fake order."),
                      ),
                      DropdownMenuItem(
                        value: "Others (I will explain)",
                        child: Text("Others (I will explain)"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedReasonForRejection = value;
                        selectedPaymentTypeAtDelivery = null;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                    ),
                  ),
                ],
                if(shouldShowPaymentType) ...[
                  const Text(
                    "Select payment type at delivery:",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedPaymentTypeAtDelivery,
                    items: const [
                      DropdownMenuItem(
                        value: "CASH",
                        child: Text("Cash"),
                      ),
                      // DropdownMenuItem(
                      //   value: "Card",
                      //   child: Text("Card"),
                      // ),
                      DropdownMenuItem(
                        value: "UPI",
                        child: Text("UPI"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentTypeAtDelivery = value;
                        selectedReasonForRejection = null;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                    ),
                  ),
              ],
              ],
            ),
            

            // 🎯 Conditional Buttons
            actions: [
              if (!shouldShowReasons && !shouldShowPaymentType)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onOkPressed != null) onOkPressed();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              if ((shouldShowReasons && selectedReasonForRejection != null) || (shouldShowPaymentType && selectedPaymentTypeAtDelivery != null))
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Login.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onClickShopPhoto != null) onClickShopPhoto((selectedReasonForRejection ?? selectedPaymentTypeAtDelivery)!);
                  },
                  child: const Text(
                    "Click Shop Photo",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    },
  );
}

/// 📸 Captures an image, uploads it, updates order status, and returns the uploaded image URL.
Future<String?> handleCameraAndUpload(
  BuildContext context, {
  required Function(bool) setLoading,
  required String orderId,
  required String choice,
  required String status,
}) async {
  try {
    // Step 1️⃣ Capture image from camera
    final File? imageFile = await _captureImage(context);
    if (imageFile == null) return null;

    // Step 2️⃣ Start loading
    setLoading(true);

    // Step 3️⃣ Upload image to Firebase
    final String? imageUrl = await _uploadImageToFirebase(imageFile);
    if (imageUrl == null) {
      setLoading(false);
      showAlertDialog(
        context,
        "ERROR",
        "Image upload failed. Please try again.",
        shouldShowReasons: false,
        shouldShowPaymentType: false,
        onOkPressed: () => Navigator.of(context).pop(),
      );
      return null;
    }

    // Step 4️⃣ Update order status (for example)
    await _updateOrderStatus(orderId: orderId , imageUrl: imageUrl ,status : status, choice: choice , context: context);

    // Step 5️⃣ Stop loading
    setLoading(false);

    return imageUrl;
  } catch (e) {
    setLoading(false);
    showAlertDialog(
      context,
      "ERROR",
      "Error: $e",
      shouldShowReasons: false,
      shouldShowPaymentType: false,
      onOkPressed: () => Navigator.of(context).pop(),
    );
    return null;
  }
}

/// Step 1️⃣ – Open Camera and Capture Image
Future<File?> _captureImage(BuildContext context) async {
  final ImagePicker picker = ImagePicker();

  try {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
    );

    if (pickedFile == null) {
      print("No image captured.");
      return null;
    }

    return File(pickedFile.path);
  } catch (e) {
    showAlertDialog(
      context,
      "ERROR",
      "Failed to open camera: $e",
      shouldShowReasons: false,
      shouldShowPaymentType: false,
      onOkPressed: () => Navigator.of(context).pop(),
    );
    return null;
  }
}

/// Step 3️⃣ – Upload image to Firebase Storage and return its URL
Future<String?> _uploadImageToFirebase(File imageFile) async {
  try {
    final DateTime now = DateTime.now();
    final String year = now.year.toString();
    final String month = DateFormat('MM').format(now);
    final String day = DateFormat('dd').format(now);
    final String timestamp = now.millisecondsSinceEpoch.toString();

    final String filePath = 'rejections/$year/$month/$day/$timestamp.jpg';
    final Reference storageRef = FirebaseStorage.instance.ref().child(filePath);

    final UploadTask uploadTask = storageRef.putFile(imageFile);
    final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

    final String downloadUrl = await snapshot.ref.getDownloadURL();
    print("✅ Uploaded to: $filePath");
    return downloadUrl;
  } catch (e) {
    print("❌ Upload failed: $e");
    return null;
  }
}

/// Step 4️⃣ – Update order status (can call your API or Firebase DB)
Future<void> _updateOrderStatus({required String orderId, required String imageUrl , required String status , required String choice , required BuildContext context}) async {
  try {
    // Example placeholder logic:
    print("📦 Updating order $orderId with image URL: $imageUrl status : $status , choice : $choice");
    //add code here
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

    // Call provider function to update order
    if(status == "rejected")
    {
      bool updateStatus = await ordersProvider.rejectOrder(
      orderId,
      status,
      choice,
      imageUrl,
    );

    if(!updateStatus)
    {
      //snackbar to show order update failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to reject order.")),
      );
    }
    else
    {
      //snackbar to show order update success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Order rejected successfully.")),
      );
      Navigator.of(context).pop(); // Close the order details screen
    }
    
  }
  else
  {
    //order delivered.
      bool updateStatus = await ordersProvider.deliverOrder(
      orderId,
      status,
      choice,
      imageUrl,
    );
    if(!updateStatus)
    {
      //snackbar to show order update failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to deliver order.")),
      );
    }
    else
    {
      //snackbar to show order update success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Order delivered successfully.")),
      );
      Navigator.of(context).pop(); // Close the order details screen
    }
  }
    }
    catch(e)
    {
      print("❌ Failed to update order: $e");
    }
    
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isLoading = false;
  

  // same as Login.primaryColor
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> order =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<dynamic> items = order["items"] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Login.primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Order Detail",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        elevation: 2,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Login.primaryColor))
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏪 Shop Info (Minimal)
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order["shop"] ?? "",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Ordered By: ${order["orderedBy"] ?? ""}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 📦 Items (Simplified layout)
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Quantity × Item Name
                                Flexible(
                                  child: Text(
                                    "${item["quantity"]} × ${item["item"]}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                // Price after discount
                                Text(
                                  "₹${item["priceAfterDiscount"].toString()}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 💰 Total Bill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Login.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Bill",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "₹${order["totalPriceAfterDiscount"].toString()}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🚦 Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Handle collected payment
                            showAlertDialog(
                              context,
                              "PAYMENT COMPLETED?",
                              "payment ki photo lelo.",
                              shouldShowReasons: false,
                              shouldShowPaymentType: true,
                              onClickShopPhoto: (paymentType) => handleCameraAndUpload(
                                context,
                                setLoading: (loading) {
                                  setState(() {
                                    isLoading = loading;
                                  });
                                },
                                orderId: order["id"],
                                choice : paymentType,
                                status:"delivered",
                              ),
                            );
                          },
                          child: const Text(
                            "Collected Payment",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Handle order rejected
                            showAlertDialog(
                              context,
                              "REJECT ORDER?",
                              "Shop ki photo kheechke daalo",
                              shouldShowReasons: true,
                              shouldShowPaymentType: false,
                              onClickShopPhoto: (reason) => handleCameraAndUpload(
                                context,
                                setLoading: (loading) {
                                  setState(() {
                                    isLoading = loading;
                                  });
                                },
                                orderId: order["id"],
                                choice : reason,
                                status : "rejected",
                              ),
                            );
                          },
                          child: const Text(
                            "Order Rejected",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
