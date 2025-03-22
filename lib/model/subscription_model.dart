import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  final String subscriptionId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final double amountPaid;

  SubscriptionModel({
    required this.subscriptionId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.amountPaid,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json, String id) {
    return SubscriptionModel(
      subscriptionId: id,
      userId: json['userId'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      amountPaid: json['amountPaid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
      'amountPaid': amountPaid,
    };
  }
}
