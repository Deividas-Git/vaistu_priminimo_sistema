import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';

class MedicationStateActionResult {
  final DateTime? delayedUntil;
  final DateTime? takenAt;
  final MedicationRecordState state;

  MedicationStateActionResult({
    this.delayedUntil,
    this.takenAt,
    required this.state,
  });

  @override
  String toString() {
    return "Atideta: $delayedUntil; suvartota: $takenAt; busena: $state";
  }
}
