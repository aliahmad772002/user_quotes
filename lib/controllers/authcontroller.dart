import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_quotes/model/user_model.dart';
import 'package:user_quotes/views/auth/name_screen.dart';
import 'package:user_quotes/views/home/home_screen.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  String? dropdownValue;

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  FirebaseMessaging firebasemessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    checkAndFetchUserData();
    _initializeMessaging();
  }

  Future<void> _initializeMessaging() async {
    await getToken(); // Get initial token
    firebasemessaging.onTokenRefresh.listen((newToken) {
      StaticData.tokenId = newToken;
      print('Token updated: $newToken');
      _updateTokenInFirestore(newToken);
    });
  }

  Future<void> getToken() async {
    String? token = await firebasemessaging.getToken();
    if (token != null) {
      StaticData.tokenId = token;
      print('Token fetched: $token');
    }
  }

  Future<void> _updateTokenInFirestore(String token) async {
    if (currentUser.value != null && currentUser.value!.uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(currentUser.value!.uid)
            .update({'tokenID': token});
        print("Token updated in Firestore.");
      } catch (e) {
        print("Error updating token in Firestore: $e");
      }
    }
  }

  Future<void> checkAndFetchUserData() async {
    final savedUid = await getStoredUid();
    if (savedUid != null) {
      await fetchUserData(savedUid);
    }
  }

  Future<String?> getStoredUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('User').doc(uid).get();

      if (documentSnapshot.exists) {
        currentUser.value =
            UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void useradd() async {
    DateTime nowInPakistan = DateTime.now().toUtc().add(Duration(hours: 5));

    UserModel model = UserModel(
      name: nameController.text,
      category: dropdownValue!,
      uid: StaticData.uid,
      premiumExpiry: nowInPakistan.add(Duration(days: 30)),
      tokenID: StaticData.tokenId, // Add tokenID here
      isPremium: false,
      createdAt: nowInPakistan,
    );

    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('User')
          .add(model.toMap());

      model.uid = docRef.id;

      await docRef.update(model.toMap());

      currentUser.value = model;

      await saveUidToPrefs(model.uid);

      SnackBar(content: Text('User data saved successfully.'));
      Get.to(() => HomeScreen());
    } catch (e) {
      SnackBar(content: Text('Error saving user data: $e'));
    }
  }

  Future<void> saveUidToPrefs(String? uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (uid != null) {
      await prefs.setString('uid', uid);
    } else {
      print("Error: UID is null.");
    }
  }

  void signOut() async {
    try {
      await auth.signOut();
      currentUser.value = null;
      print("User signed out successfully.");
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.getKeys();
      sharedPreferences.clear();
      Get.off(NameScreen());
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}

class StaticData {
  static String uid = '';
  static String tokenId = '';
}
