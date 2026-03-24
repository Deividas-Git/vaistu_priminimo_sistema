import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';

class AgendaItem {
  final String medicationId;
  final String medicationName;
  final int amountToTake;
  final MedicationMealTiming medicationMealTiming;
  final MedicationType medicationType;
  final DateTime scheduledDate;
  final String scheduleName;
  final MedicationRecordState state;
  final String medicationRecordId;
  final DateTime? lastTimeTaken;
  final DateTime? upcomingIntakeAt;
  final DateTime? delayedUntil;

  AgendaItem({
    required this.medicationId,
    required this.medicationName,
    required this.amountToTake,
    required this.medicationMealTiming,
    required this.medicationType,
    required this.scheduledDate,
    required this.scheduleName,
    required this.state,
    required this.medicationRecordId,
    required this.lastTimeTaken,
    required this.upcomingIntakeAt,
    required this.delayedUntil,
  });

  @override
  String toString() {
    return "Med ID: $medicationId, recordId: $medicationRecordId, vaistas: $medicationName, data: $scheduledDate, kiekis: $amountToTake, vartojama: $medicationMealTiming, tvarkarastis: $scheduleName, busena: $state, vartota $lastTimeTaken";
  }
}
