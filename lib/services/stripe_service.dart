
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/paymentResponse_model.dart';
import '../ultilities/Constant.dart';

class StripeService {
  StripeService._();

  static final StripeService instance =  StripeService._();

  Future<String> makePayment(double amount) async {
    try {
      PaymentResponse? paymentResponse = await _createPaymentIntent(amount);
      if (paymentResponse?.clientSecret  == null) return "";
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentResponse?.clientSecret,
            merchantDisplayName: "NSERVE",
          ));
      try {
        await Stripe.instance.presentPaymentSheet();
        Get.snackbar("Payment", "Paid successfully");
        return paymentResponse!.paymentIntentId;

      } on StripeException catch (e) {
        print('Error: $e');
        return "";
      } catch (e) {
        print("Error in displaying");
        print('$e');
        return "";
      }

    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<PaymentResponse?> _createPaymentIntent(double amount) async {
    try {
      final Dio dio = Dio();

      String jwtToken = await getToken();

      Map<String, dynamic> data = {
        "amount": amount,
      };

      var response = await dio.post(
        "${Constant.ORDER_URL}/createPaymentIntent",
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            "Authorization": "Bearer $jwtToken",
          },
        ),
      );

      if (response.data != null && response.data['code'] == 1000) {
        return PaymentResponse.fromJson(response.data['result']);
      }
      return null;
    } catch (e) {
      print("Error in _createPaymentIntent: $e");
      return null;
    }
  }
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }


  String _calculateAmount(int amount){
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}

