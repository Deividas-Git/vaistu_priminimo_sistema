import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/log_level.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/services/log_service.dart';

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
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("medication_records")
          .doc(record.id)
          .set(record.toMap());
      await LogService.instance.log(
        level: LogLevel.info,
        action: "medication record saved",
        details: record.toMap().toString(),
      );
    } on FirebaseException catch (e) {
      await LogService.instance.log(
        level: LogLevel.error,
        action: "medication record not saved",
        details: "${e.message} ${e.code}",
      );
    }
  }

  Future<void> removeRecord(String uid, MedicationRecord record) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("medication_records")
          .doc(record.id)
          .delete();
      await LogService.instance.log(
        level: LogLevel.info,
        action: "medication record removed",
        details: "medication record id: ${record.id}",
      );
    } on FirebaseException catch (e) {
      await LogService.instance.log(
        level: LogLevel.error,
        action: "medication record not removed",
        details: "${e.message} ${e.code}",
      );
    }
  }
}
