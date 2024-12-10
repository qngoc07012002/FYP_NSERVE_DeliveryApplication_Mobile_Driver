
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../screens/homepage_screen.dart';
import '../screens/login_screen.dart';
import '../ultilities/Constant.dart';
import 'driver_controller.dart';
import 'order_controller.dart';

class UserController extends GetxController {
  var phoneNumber = "".obs;

  Future<void> logout() async {
    final String token = await getToken();
    const url = Constant.LOGOUT_URL;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'You have logged out successfully');
    }
    Get.offAll(const LoginPage());
  }

  Future<void> checkTokenValidity() async {
    final String token = await getToken();

    const url = Constant.INTROSPECT_URL;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final bool isValid = responseBody['result']['valid'];

      if (isValid) {
        Get.put(DriverController());

        Get.put(OrderController());
        Get.offAll(DriverHomePage());
      }
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }
}
