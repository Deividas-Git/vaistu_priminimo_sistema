import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';

const _noChange = Object();

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

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      "name": name,
      "medicationType": medicationType?.name,
      "medicationMealTiming": medicationMealTiming?.name,
    };

    if (currentQuantity != null) {
      map["currentQuantity"] = currentQuantity;
    }

    if (expirationDate != null) {
      map["expirationDate"] = Timestamp.fromDate(expirationDate!);
    }

    if (lastTimeTaken != null) {
      map["lastTimeTaken"] = Timestamp.fromDate(lastTimeTaken!);
    }

    if (medicationSchedules != null) {
      map["medicationSchedules"] = medicationSchedules!
          .map(((schedule) => schedule.toMap()))
          .toList();
    }

    return map;
  }

  factory UserMedication.fromMap(Map<String, dynamic> map, String id) {
    return UserMedication(
      id: id,
      name: map["name"],
      currentQuantity: map["currentQuantity"],
      medicationType: MedicationType.values.byName(map["medicationType"]),
      medicationMealTiming: MedicationMealTiming.values.byName(
        map["medicationMealTiming"],
      ),
      expirationDate: map["expirationDate"] != null
          ? (map["expirationDate"] as Timestamp).toDate()
          : null,
      lastTimeTaken: map["lastTimeTaken"] != null
          ? (map["lastTimeTaken"] as Timestamp).toDate()
          : null,
      medicationSchedules:
          (map["medicationSchedules"] as List<dynamic>?)?.isNotEmpty == true
          ? (map["medicationSchedules"] as List<dynamic>)
                .map(
                  ((schedule) => MedicationSchedule.fromMap(
                    schedule as Map<String, dynamic>,
                  )),
                )
                .toList()
          : null,
    );
  }

  factory UserMedication.empty() {
    return UserMedication();
  }

  UserMedication copyWith({
    Object? id = _noChange,
    Object? name = _noChange,
    Object? currentQuantity = _noChange,
    Object? medicationType = _noChange,
    Object? medicationMealTiming = _noChange,
    Object? expirationDate = _noChange,
    Object? lastTimeTaken = _noChange,
    Object? medicationSchedules = _noChange,
  }) {
    return UserMedication(
      id: id == _noChange ? this.id : id as String?,
      name: name == _noChange ? this.name : name as String?,
      currentQuantity: currentQuantity == _noChange
          ? this.currentQuantity
          : currentQuantity as double?,
      medicationType: medicationType == _noChange
          ? this.medicationType
          : medicationType as MedicationType?,
      medicationMealTiming: medicationMealTiming == _noChange
          ? this.medicationMealTiming
          : medicationMealTiming as MedicationMealTiming?,
      expirationDate: expirationDate == _noChange
          ? this.expirationDate
          : expirationDate as DateTime?,
      lastTimeTaken: lastTimeTaken == _noChange
          ? this.lastTimeTaken
          : lastTimeTaken as DateTime?,
      medicationSchedules: medicationSchedules == _noChange
          ? this.medicationSchedules
          : medicationSchedules as List<MedicationSchedule>?,
    );
  }

  @override
  String toString() {
    return "Vaistas: $name; Kiekis: ${currentQuantity.toString()}; Tipas: $medicationType; Vartojama: ${medicationMealTiming.toString()}; Galioja iki: ${expirationDate.toString().split(" ")[0]}; Vartota: ${lastTimeTaken.toString()}, tvarkarasciai: ${medicationSchedules.toString()}";
  }
}
