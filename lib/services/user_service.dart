import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addNewUser({required AppUser user}) async {
    await _firestore.collection("users").doc(user.uid).set(user.toMap());
  }

  Future<String?> deleteUserData({required String? uid}) async {
    if (uid == null) return "Nera uid";
    try {
      await _firestore.collection("users").doc(uid).delete();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<AppUser?> retrieveUserData({required String uid}) async {
    final userDataDoc = await _firestore.collection("users").doc(uid).get();

    if (userDataDoc.data() == null) {
      return null;
    }

    return AppUser.fromMap(userDataDoc.data()!, uid);
  }
}
