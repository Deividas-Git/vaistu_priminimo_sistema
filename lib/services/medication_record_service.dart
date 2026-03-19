import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';

class MedicationRecordService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<MedicationRecord>> medicationRecordsStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("medication_records")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MedicationRecord.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> saveRecord(String uid, MedicationRecord record) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("medication_records")
        .doc(record.id)
        .set(record.toMap());
  }

  Future<void> removeRecord(String uid, MedicationRecord record) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("medication_records")
        .doc(record.id)
        .delete();
  }
}
