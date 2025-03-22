import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String category;
  String uid;
  DateTime premiumExpiry;
 String tokenID;
  bool isPremium;
  DateTime createdAt;

  UserModel({
    required this.name,
    required this.category,
    required this.uid,
    required this.premiumExpiry,
    required this.tokenID,
    required this.isPremium,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      category: map['category'],
      uid: map['uid'],
      premiumExpiry: (map['premiumExpiry'] as Timestamp).toDate().toUtc().add(Duration(hours: 5)),
      tokenID: map['tokenID'],
      isPremium: map['isPremium'],
      createdAt: (map['createdAt'] as Timestamp).toDate().toUtc().add(Duration(hours: 5)),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'uid': uid,
      'premiumExpiry': premiumExpiry,
       'tokenID': tokenID,
      'isPremium': isPremium,
      'createdAt': createdAt,
    };
  }

  // Add the copyWith method
  UserModel copyWith({
    String? name,
    String? category,
    String? uid,
    DateTime? premiumExpiry,
    String? tokenID,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      category: category ?? this.category,
      uid: uid ?? this.uid,
      premiumExpiry: premiumExpiry ?? this.premiumExpiry,
      tokenID: tokenID ?? this.tokenID,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
