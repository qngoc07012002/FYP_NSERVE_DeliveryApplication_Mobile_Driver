import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/driver_model.dart';
import '../models/food_model.dart';
import '../ultilities/Constant.dart';

class DriverController extends GetxController {
  Rx<Driver?> driver = Rx<Driver?>(null);
  RxBool isLoading = true.obs;
  RxBool isOnline = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchDriverInfo();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<void> fetchDriverInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', Constant.JWT);

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
          driver.value = Driver.fromJson(driverData);
          if (driver.value?.status == "ONLINE") {
            isOnline.value = true;
          } else if (driver.value?.status == "OFFLINE"){
            isOnline.value = false;
          }
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

  Future<void> updateDriverStatus() async {
    String token = await getToken();

    final url = Uri.parse('${Constant.DRIVER_STATUS_URL}/${driver.value?.status}');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Status updated successfully');
    } else {
      print('Failed to update status: ${response.statusCode}');
    }
  }

  Future<void> updateDriverLocation(double latitude, double longitude) async {
    String token = await getToken();

    final url = Uri.parse(Constant.DRIVER_LOCATION_URL);
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'latitude': latitude,
      'longitude': longitude,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 1000) {
          print('Driver location updated successfully');
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to update location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


}
