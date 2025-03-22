// lib/controllers/quote_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteController extends GetxController {
  var likedQuotes = <String>{}.obs;




  void handleLikeDislike(String quoteId, String? currentUserId) {
    if (likedQuotes.contains(quoteId)) {
      FirebaseFirestore.instance.collection("Quotes").doc(quoteId).update({
        'isLiked': FieldValue.arrayRemove([currentUserId])
      });
      likedQuotes.remove(quoteId);
    } else {
      FirebaseFirestore.instance.collection("Quotes").doc(quoteId).update({
        'isLiked': FieldValue.arrayUnion([currentUserId])
      });
      likedQuotes.add(quoteId);
    }
  }
}