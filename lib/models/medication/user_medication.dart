import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';

class UserMedication {
  final String? id;
  final String? name;
  final double? currentQuantity;
  final MedicationType? medicationType; // = MedicationType.other;
  final MedicationMealTiming?
  medicationMealTiming; // = MedicationMealTiming.unspecified;
  final DateTime? expirationDate;
  final DateTime? lastTimeTaken;
  final List<MedicationSchedule>? medicationSchedules;

  UserMedication({
    this.id,
    this.name,
    this.currentQuantity,
    this.medicationType,
    this.medicationMealTiming,
    this.expirationDate,
    this.lastTimeTaken,
    this.medicationSchedules,
  });

  factory UserMedication.empty() {
    return UserMedication();
  }

  UserMedication copyWith({
    String? id,
    String? name,
    double? currentQuantity,
    MedicationType? medicationType,
    MedicationMealTiming? medicationMealTiming,
    DateTime? expirationDate,
    DateTime? lastTimeTaken,
    List<MedicationSchedule>? medicationSchedules,
  }) {
    return UserMedication(
      id: id ?? this.id,
      name: name ?? this.name,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      medicationType: medicationType ?? this.medicationType,
      medicationMealTiming: medicationMealTiming ?? this.medicationMealTiming,
      expirationDate: expirationDate ?? this.expirationDate,
      lastTimeTaken: lastTimeTaken ?? this.lastTimeTaken,
      medicationSchedules: medicationSchedules ?? this.medicationSchedules,
    );
  }

  UserMedication merge({UserMedication? medicationFromWhichUpdating}) {
    if (medicationFromWhichUpdating == null) {
      return this;
    }

    return copyWith(
      id: medicationFromWhichUpdating.id,
      name: medicationFromWhichUpdating.name,
      currentQuantity: medicationFromWhichUpdating.currentQuantity,
      medicationType: medicationFromWhichUpdating.medicationType,
      medicationMealTiming: medicationFromWhichUpdating.medicationMealTiming,
      expirationDate: medicationFromWhichUpdating.expirationDate,
      lastTimeTaken: medicationFromWhichUpdating.lastTimeTaken,
      medicationSchedules: medicationFromWhichUpdating.medicationSchedules,
    );
  }

  @override
  String toString() {
    return "Vaistas: $name; Kiekis: ${currentQuantity.toString()}; Tipas: ${medicationType.toString()}; Vartojama: ${medicationMealTiming.toString()}; Galioja iki: ${expirationDate.toString().split(" ")[0]}; Vartota: ${lastTimeTaken.toString()}";
  }
}
