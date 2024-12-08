import 'package:deliveryapplication_mobile_driver/controllers/driver_controller.dart';
import 'package:deliveryapplication_mobile_driver/controllers/order_controller.dart';
import 'package:deliveryapplication_mobile_driver/screens/homepage_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/login_screen.dart';
import 'package:deliveryapplication_mobile_driver/services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

  void main() {
    Get.put(WebSocketService());
    Get.put(DriverController());
    Get.put(OrderController());
  runApp(const GetMaterialApp(
    home: DriverHomePage(),
  ));
}
