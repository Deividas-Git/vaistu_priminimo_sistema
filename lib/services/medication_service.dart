import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';

class MedicationService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<UserMedication>> retrieveAllUserMedications(String? uid) async {
    if (uid == null) {
      return [];
    }

    final medicationsDataCollection = await _firestore
        .collection("users")
        .doc(uid)
        .collection("medications")
        .get();

    final List<UserMedication> medications = medicationsDataCollection.docs
        .map((doc) => UserMedication.fromMap(doc.data(), doc.id))
        .toList();

    return medications;
  }

  Future<void> addMedication(UserMedication medication, String? uid) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("medications")
        .doc(medication.id)
        .set(medication.toMap());
  }

  void updateMedication(UserMedication medication) {}

  void removeMedication(UserMedication medication) {}
}
