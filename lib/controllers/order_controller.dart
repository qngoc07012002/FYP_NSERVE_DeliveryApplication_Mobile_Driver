import 'package:deliveryapplication_mobile_driver/controllers/driver_controller.dart';
import 'package:deliveryapplication_mobile_driver/screens/homepage_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/orderdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/order_model.dart';
import '../services/websocket_service.dart';
import '../ultilities/Constant.dart';

class OrderController extends GetxController {
  var isLoading = true.obs;
  var orders = <Order>[].obs;
  var currentOrder = Rx<Order?>(null);
  final WebSocketService _webSocketService = Get.find();
  final DriverController _driverController = Get.find();
  var driverId = "".obs;


  @override
  void onInit() async{
    await fetchDriverId();
    fetchOrders();
    subscribeReceiveOrder();
    super.onInit();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<void> fetchOrders() async {
    try {
      String? jwtToken = await getToken();

      isLoading(true);
      var response = await http.get(
          Uri.parse(Constant.ORDER_DRIVER_URL),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        if (data['code'] == 1000) {
          var fetchedOrders = (data['result'] as List)
              .map((item) => Order.fromJson(item))
              .where((order) => order.orderStatus != "CANCELED")
              .toList();


          orders.value = fetchedOrders;

          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
      } else {
        print('Failed to fetch orders');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  void subscribeReceiveOrder(){

    print("DRIVER ID: ${driverId.value}");
    _webSocketService.subscribe(
      '/queue/driver/order/${driverId.value}',
          (frame) async {
        if (frame.body != null) {
          Map<String, dynamic> jsonData = jsonDecode(frame.body!);
          print('Received message: $jsonData');

          if (jsonData['action'] == "RESTAURANT_REQUEST_DRIVER"){
            showNotificationDialog(jsonData);
          }
          if (jsonData['action'] == "RESTAURANT_PREPARED_ORDER"){
            print("Restaurant PREAPRED ORDER");
            Get.snackbar("Restaurant Notification", "The restaurant has prepared the order.");
            await fetchOrders();
            for (var order in orders) {
              print("${order.id}");
              if (order.id == currentOrder.value?.id) {

                currentOrder.value = order;
                print(currentOrder.value?.orderStatus);
              }
            }
          }



          if (jsonData['action'] == "RESTAURANT_DECLINE_ORDER"){
            Get.defaultDialog(
              title: "Notification",
              middleText: "Restaurant canceled this order.",
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                fetchOrders();
                Get.back();
                Get.back();
              },
              barrierDismissible: false,
            );
          }
        }
      },
    );
  }

  void sendOrderStatusUpdate(String orderId, String driverId, String action) {
    Map<String, dynamic> body = {
      'orderId': orderId,
      'driverId': driverId,
      'action': action,
    };

    _webSocketService.sendMessage('/app/order/driver/', body);
  }

  Future<void> fetchDriverId() async {

    String? jwtToken = await getToken();
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(Constant.DRIVER_INFO_URL),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 1000) {
          final driverData = data['result'];
          driverId.value = driverData['driverId'];
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load driver info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showNotificationDialog(Map<String, dynamic> orderData) {
    String orderId = orderData['body']['orderId'];
    String orderType = orderData['body']['orderType'];
    String startLocation = orderData['body']['startLocation']['address'];
    String endLocation = orderData['body']['endLocation']['address'];
    double shippingFee = orderData['body']['shippingFee'];

    // Hiển thị Dialog với giao diện đẹp hơn
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'New Order Notification',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      orderType == 'FOOD' ? Icons.fastfood : Icons.directions_car,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Order Type: $orderType',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Start Location: $startLocation',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'End Location: $endLocation',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Shipping Fee: \$${shippingFee.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              sendOrderStatusUpdate(orderId, driverId.value, "DRIVER_DECLINE_ORDER");
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Decline',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: () async {
              Get.back();
              sendOrderStatusUpdate(orderId, driverId.value, "DRIVER_ACCEPT_ORDER");
              await fetchOrderById(orderId);
              Get.to(OrderDetailPage());
              //print(_driverController.driver.value?.driverId);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Accept',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchOrderById(String orderId) async {
    String jwtToken = await getToken();

    final response = await http.get(
      Uri.parse('${Constant.ORDER_DRIVER_URL}/$orderId'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);


      final Map<String, dynamic> data = json.decode(responseBody);
      final Order order = Order.fromJson(data['result']);
      print(order);
      currentOrder.value = order;
      currentOrder.value?.id = orderId;
      fetchOrders();
      isLoading.value = false;
    } else {
      isLoading.value = false;
      print('Failed to load order by ID: ${response.statusCode}');
    }
  }


}
