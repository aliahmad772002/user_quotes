import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createSubscription(String userId, double amount) async {
    try {
      // Simulate Stripe payment (add actual API integration here)
      final subscriptionId = 'stripe_subscription_id'; // Replace with actual Stripe ID
      final now = DateTime.now();
      final expiry = now.add(Duration(days: 30)); // 1-month subscription

      // Save subscription details to Firestore
      await firestore.collection('subscriptions').add({
        'userId': userId,
        'amountPaid': amount,
        'startDate': now,
        'endDate': expiry,
      });

      // Update user as premium
      await firestore.collection('users').doc(userId).update({
        'isPremium': true,
        'premiumExpiry': expiry,
      });

      Get.snackbar("Success", "Premium subscription activated!");
    } catch (e) {
      Get.snackbar("Error", "Failed to create subscription: $e");
    }
  }

  Future<void> validateSubscription(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final premiumExpiry = (userDoc.data()?['premiumExpiry'] as Timestamp?)?.toDate();
        if (premiumExpiry != null && premiumExpiry.isBefore(DateTime.now())) {
          await firestore.collection('users').doc(userId).update({'isPremium': false});
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to validate subscription: $e");
    }
  }
}
