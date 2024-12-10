import 'package:deliveryapplication_mobile_driver/controllers/driver_controller.dart';
import 'package:deliveryapplication_mobile_driver/controllers/order_controller.dart';
import 'package:deliveryapplication_mobile_driver/controllers/user_controller.dart';
import 'package:deliveryapplication_mobile_driver/screens/homepage_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/login_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/register_screen.dart';
import 'package:deliveryapplication_mobile_driver/services/websocket_service.dart';
import 'package:deliveryapplication_mobile_driver/ultilities/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

  Future<void> main() async {
    Get.put(WebSocketService());
    Get.put(UserController());

    await _setupStripe();
  runApp(const GetMaterialApp(
    home: LoginPage(),
  ));
}

Future<void> _setupStripe() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = Constant.stripePublishableKey;
}

