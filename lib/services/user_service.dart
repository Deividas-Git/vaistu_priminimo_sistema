import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/medication_service.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;
  final _medicationService = MedicationService();

  Future<void> addNewUser({required AppUser user}) async {
    await _firestore
        .collection("users")
        .doc(user.userCredentials!.uid)
        .set(user.toMap());
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

  Future<AppUser?> retrieveUserData({required User? userCredentials}) async {
    if (userCredentials == null) {
      return null;
    }

    //try catch?
    final userDataDoc = await _firestore
        .collection("users")
        .doc(userCredentials.uid)
        .get();

    if (userDataDoc.data() == null) {
      return null;
    }

    //reiks gaut is medication service
    final List<UserMedication> userMedications = await _medicationService
        .retrieveAllUserMedications();

    return AppUser.fromMap(
      userDataDoc.data()!,
      userCredentials,
      userMedications,
    );
  }
}
