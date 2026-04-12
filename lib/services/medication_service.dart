import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';

class MedicationService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Stream<List<UserMedication>> medicationsStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("medications")
        .orderBy("addedAt", descending: true)
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

  Future<UserMedication?> getMedicationFromRegistrationCode(
    String registrationNr,
  ) async {
    var snapshot = await _firestore
        .collection("medications")
        .where("registrationNr", isEqualTo: registrationNr)
        .limit(1)
        .get();
    var doc = snapshot.docs.firstOrNull;
    if (doc == null) return null;
    final Map<String, dynamic> data = doc.data();
    final UserMedication medication = UserMedication(
      name: data["name"],
      currentQuantity: data["quantity"],
      medicationType: MedicationType.values.byName(data["medicationType"]),
      registrationNr: data["registrationNr"],
    );
    return medication;
  }

  Future<String?> getPhotoUrlFromDocument(String? registrationNr) async {
    try {
      if (registrationNr == null) {
        return null;
      }
      var snapshot = await _firestore
          .collection("medications")
          .where("registrationNr", isEqualTo: registrationNr)
          .limit(1)
          .get();
      var doc = snapshot.docs.firstOrNull;
      if (doc == null) return null;
      final Map<String, dynamic> data = doc.data();
      return data["photoUrl"];
    } catch (e) {
      debugPrint("KLAIDA gaunant foto: $e");
      return null;
    }
  }

  Future<String?> getPhotoUrlFromStorage(String? registrationNr) async {
    try {
      String path = "";

      if (registrationNr == null) {
        return null; //TODO kol naudotojas pats negali prideti foto
      } else {
        path =
            "medication_photos/prefilled_medication_photos/${registrationNr.replaceAll("/", "-")}.png";
      }
      final Reference ref = _storage.ref().child(path);
      final String url = await ref.getDownloadURL().timeout(
        Duration(seconds: 5),
      );
      debugPrint("URL: $url");
      return url;
    } catch (e) {
      debugPrint("KLAIDA gaunant foto: $e");
      return null;
    }
  }
}
