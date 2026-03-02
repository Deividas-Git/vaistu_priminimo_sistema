import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';

class MedicationService {
  final _firestore = FirebaseFirestore.instance;
  //final _authService = AuthService();

  Future<List<UserMedication>> retrieveAllUserMedications() async {
    String? uid; // = _authService.getUid();

    if (uid == null) {
      return [];
    }

    final medicationsDataCollection = await _firestore
        .collection("users")
        .doc(uid)
        .collection("medications")
        .get();

    return medicationsDataCollection.docs
        .map((doc) => UserMedication.fromMap(doc.data()))
        .toList();
  }

  Future<void> addMedication(UserMedication medication) async {
    String? uid; //= _authService.getUid();

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
