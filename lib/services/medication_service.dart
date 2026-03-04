import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';

class MedicationService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<UserMedication>> medicationsStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("medications")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserMedication.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addMedication(UserMedication medication, String uid) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("medications")
        .add(medication.toMap());
  }

  Future<void> updateMedication(UserMedication medication, String uid) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("medications")
        .doc(medication.id)
        .set(medication.toMap());
  }

  Future<void> removeMedication(String medicationid, String uid) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("medications")
        .doc(medicationid)
        .delete();
  }
}
