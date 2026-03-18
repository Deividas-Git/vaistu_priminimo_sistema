import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';

class MedicationRecord {
  final String medicationId;
  final String scheduleId;
  final String timeId;
  final DateTime scheduledDate;
  final DateTime? takenDate;
  final MedicationRecordState state;

  MedicationRecord({
    required this.medicationId,
    required this.scheduleId,
    required this.timeId,
    required this.scheduledDate,
    required this.takenDate,
    required this.state,
  });
}
