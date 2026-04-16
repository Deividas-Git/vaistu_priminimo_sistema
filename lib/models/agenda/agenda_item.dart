import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_form.dart';

class AgendaItem {
  final String medicationId;
  final String medicationName;
  final int amountToTake;
  final MedicationMealTiming medicationMealTiming;
  final MedicationForm medicationForm;
  final DateTime scheduledDate;
  final String scheduleName;
  final MedicationRecordState state;
  final String medicationRecordId;
  final DateTime? lastTimeTaken;
  final DateTime? delayedUntil;
  final String? photoUrl;

  AgendaItem({
    required this.medicationId,
    required this.medicationName,
    required this.amountToTake,
    required this.medicationMealTiming,
    required this.medicationForm,
    required this.scheduledDate,
    required this.scheduleName,
    required this.state,
    required this.medicationRecordId,
    required this.lastTimeTaken,
    required this.delayedUntil,
    required this.photoUrl,
  });

  @override
  String toString() {
    return "Med ID: $medicationId, recordId: $medicationRecordId, vaistas: $medicationName, data: $scheduledDate, kiekis: $amountToTake, vartojama: $medicationMealTiming, tvarkarastis: $scheduleName, busena: $state, vartota $lastTimeTaken";
  }
}
