import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  final String quoteId;
  final String text;
  final String category;
  final DateTime createdAt;

  QuoteModel({
    required this.quoteId,
    required this.text,
    required this.category,
    required this.createdAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json, String quoteId) {
    return QuoteModel(
      quoteId: quoteId,
      text: json['text'],
      category: json['category'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'category': category,
      'createdAt': createdAt,
    };
  }
}
