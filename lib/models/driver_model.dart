import 'package:flutter/material.dart';

class Driver {
  String? driverId;
  String? userId;
  String? driverName;
  String? imgUrl;
  String? status;
  double? balance;

  Driver({
    this.driverId,
    this.userId,
    this.driverName,
    this.imgUrl,
    this.status,
    this.balance,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: json['driverId'],
      userId: json['userId'],
      driverName: json['driverName'],
      imgUrl: json['imgUrl'],
      status: json['status'],
      balance: (json['balance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'userId': userId,
      'driverName': driverName,
      'imgUrl': imgUrl,
      'status': status,
      'balance': balance,
    };
  }
}
