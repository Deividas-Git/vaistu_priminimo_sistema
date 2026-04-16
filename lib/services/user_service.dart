import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addNewUser({required AppUser user}) async {
    await _firestore.collection("users").doc(user.uid).set(user.toMap());
  }

  Future<String?> deleteUserData({required String? uid}) async {
    if (uid == null) return "Nerasta naudotojo ID";
    final userDoc = _firestore.collection("users").doc(uid);

    //trinam vaistus
    try {
      final medications = await userDoc.collection("medications").get();
      for (var medDoc in medications.docs) {
        await medDoc.reference.delete();
      }
    } on FirebaseException catch (e) {
      return e.message;
    }

    //trinam vaistu irasus
    try {
      final medicationRecords = await userDoc
          .collection("medication_records")
          .get();
      for (var medRecordDoc in medicationRecords.docs) {
        await medRecordDoc.reference.delete();
      }
    } on FirebaseException catch (e) {
      return e.message;
    }

    //trinam health metrics
    try {
      final healthMetrics = await userDoc.collection("health_metrics").get();
      for (var healthMetric in healthMetrics.docs) {
        await healthMetric.reference.delete();
      }
    } on FirebaseException catch (e) {
      return e.message;
    }

    //trinam logus
    try {
      final logs = await userDoc.collection("logs").get();
      for (var log in logs.docs) {
        await log.reference.delete();
      }
    } on FirebaseException catch (e) {
      return e.message;
    }

    //trinam pati user
    try {
      await userDoc.delete();
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
