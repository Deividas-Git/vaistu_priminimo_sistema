import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';

class MedicationSchedule {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final MedicationFrequencyType medicationFrequencyType;
  final int? intervalsDays;
  final List<Weekday>? weekdays;
  final List<MedicationConsumptionTimeWithAmount>? consumptionTimesWithAmount;
  final String? name;

  MedicationSchedule({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.medicationFrequencyType,
    this.intervalsDays,
    this.weekdays,
    this.consumptionTimesWithAmount,
    required this.name,
  });

  MedicationSchedule copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    MedicationFrequencyType? medicationFrequencyType,
    int? intervalsDays,
    List<Weekday>? weekdays,
    List<MedicationConsumptionTimeWithAmount>? consumptionTimesWithAmount,
    String? name,
  }) {
    return MedicationSchedule(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      medicationFrequencyType:
          medicationFrequencyType ?? this.medicationFrequencyType,
      intervalsDays: intervalsDays ?? this.intervalsDays,
      weekdays: weekdays ?? this.weekdays,
      consumptionTimesWithAmount:
          consumptionTimesWithAmount ?? this.consumptionTimesWithAmount,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "startDate": Timestamp.fromDate(startDate),
      "medicationFrequencyType": medicationFrequencyType.name,
      "name": name,
    };

    if (endDate != null) {
      map["endDate"] = Timestamp.fromDate(endDate!);
    }

    if (intervalsDays != null) {
      map["intervalDays"] = intervalsDays;
    }

    if (weekdays != null) {
      map["weekdays"] = weekdays!.map((weekday) => weekday.name).toList();
    }

    if (consumptionTimesWithAmount != null) {
      map["consumptionTimesWithAmount"] = consumptionTimesWithAmount!
          .map((e) => e.toMap())
          .toList();
    }

    return map;
  }

  factory MedicationSchedule.fromMap(Map<String, dynamic> map) {
    return MedicationSchedule(
      id: map["id"] ?? "",
      startDate: (map["startDate"] as Timestamp).toDate(),
      endDate: map["endDate"] != null
          ? (map["endDate"] as Timestamp).toDate()
          : null,
      medicationFrequencyType: MedicationFrequencyType.values.byName(
        map["medicationFrequencyType"],
      ),
      intervalsDays: map["intervalDays"],
      weekdays: (map["weekdays"] as List<dynamic>?)?.isNotEmpty == true
          ? (map["weekdays"] as List<dynamic>)
                .map((weekday) => Weekday.values.byName(weekday as String))
                .toList()
          : null,
      consumptionTimesWithAmount:
          (map["consumptionTimesWithAmount"] as List<dynamic>)
              .map(
                (e) => MedicationConsumptionTimeWithAmount.fromMap(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      name: map["name"],
    );
  }

  @override
  String toString() {
    return "id: $id, Pavadinimas: $name, Pradzia: $startDate, Pabaiga: $endDate, Daznumo tipas: $medicationFrequencyType, Intervalai: $intervalsDays, Pasirinktos dienos: $weekdays, Laikai ir kiekiai: $consumptionTimesWithAmount";
  }
}
