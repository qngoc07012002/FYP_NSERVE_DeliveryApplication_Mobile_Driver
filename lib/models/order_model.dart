import 'package:deliveryapplication_mobile_driver/models/restaurant_model.dart';
import 'package:deliveryapplication_mobile_driver/models/user_model.dart';
import 'package:intl/intl.dart'; // For date formatting and parsing
import 'location_model.dart';

class Order {
  String? id;
  String orderCode;
  String orderType;
  Restaurant? restaurantInfo;
  User userInfo;
  Location startLocation;
  Location endLocation;
  String orderStatus;
  double shippingFee;
  DateTime createdAt;

  Order({
    this.id,
    required this.orderCode,
    required this.orderType,
    this.restaurantInfo,
    required this.userInfo,
    required this.startLocation,
    required this.endLocation,
    required this.orderStatus,
    required this.shippingFee,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {

    String dateString = json['createdAt'];
    DateTime createdAt = DateTime.parse(dateString).toLocal();

    return Order(
      id: json['id'] ?? '',
      orderCode: json['orderCode'],
      orderType: json['orderType'],
      restaurantInfo: json['restaurantInfo'] != null
          ? Restaurant.fromJson(json['restaurantInfo'])
          : null,
      userInfo: User.fromJson(json['userInfo']),
      startLocation: Location.fromJson(json['startLocation']),
      endLocation: Location.fromJson(json['endLocation']),
      orderStatus: json['orderStatus'],
      shippingFee: json['shippingFee'].toDouble(),
      createdAt: createdAt,
    );
  }

  String get formattedCreatedAt {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);
  }
}
