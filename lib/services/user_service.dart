import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addNewUser({required AppUser user}) async {
    await _firestore
        .collection("users")
        .doc(user.userCredentials!.uid)
        .set(user.toMap());
  }

  Future<String?> deleteUserData({required User? userCredentials}) async {
    if (userCredentials == null) return "Nera user credentials";
    try {
      await _firestore.collection("users").doc(userCredentials.uid).delete();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<AppUser?> retrieveUserData({required User? userCredentials}) async {
    if (userCredentials == null) {
      return null;
    }

    final userDataDoc = await _firestore
        .collection("users")
        .doc(userCredentials.uid)
        .get();

    if (userDataDoc.data() == null) {
      return null;
    }

    //reiks gaut is medication service
    final List<UserMedication> userMedications = [];

    return AppUser.fromMap(
      userDataDoc.data()!,
      userCredentials,
      userMedications,
    );
  }
}
