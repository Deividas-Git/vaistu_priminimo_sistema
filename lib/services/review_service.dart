import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/review.dart';

class ReviewService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveReview({required String uid, required Review review}) async {
    await _firestore.collection("reviews").doc(uid).set(review.toMap());
  }
}
