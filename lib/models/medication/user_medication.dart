import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';

class UserMedication {
  String? name;
  double? currentQuantity;
  MedicationType medicationType = MedicationType.other;
  MedicationMealTiming medicationMealTiming = MedicationMealTiming.unspecified;
  DateTime? expirationDate;
  DateTime? lastTimeTaken;
  List<MedicationSchedule> medicationSchedules = [];
}
