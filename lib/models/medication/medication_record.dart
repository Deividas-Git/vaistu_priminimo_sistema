import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';

class MedicationRecord {
  final String id;
  final String medicationId;
  final DateTime scheduledDate;
  final DateTime? takenDate;
  final DateTime? delayedUntil;
  final MedicationRecordState state;

  MedicationRecord({
    required this.id,
    required this.medicationId,
    required this.scheduledDate,
    required this.takenDate,
    required this.delayedUntil,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      "medicationId": medicationId,
      "scheduledDate": Timestamp.fromDate(scheduledDate),
      "state": state.name,
    };

    if (takenDate != null) {
      map["takenDate"] = takenDate;
    }

    if (delayedUntil != null) {
      map["delayedUntil"] = delayedUntil;
    }

    return map;
  }

  factory MedicationRecord.fromMap(Map<String, dynamic> map, String id) {
    return MedicationRecord(
      id: id,
      medicationId: map["medicationId"],
      scheduledDate: (map["scheduledDate"] as Timestamp).toDate(),
      takenDate: map["takenDate"] != null
          ? (map["takenDate"] as Timestamp).toDate()
          : null,
      delayedUntil: map["delayedUntil"] != null
          ? (map["delayedUntil"] as Timestamp).toDate()
          : null,
      state: MedicationRecordState.values.byName(map["state"]),
    );
  }

  static String buildId({
    required String medicationId,
    required String timeId,
    required DateTime date,
  }) {
    return "${medicationId}_${timeId}_${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
  }
}
