import 'package:flutter/material.dart';

class MedicationConsumptionTimeWithAmount {
  final String id;
  final TimeOfDay time;
  final int consumptionAmount;

  MedicationConsumptionTimeWithAmount({
    required this.id,
    required this.time,
    required this.consumptionAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "time": {"hour": time.hour, "minute": time.minute},
      "consumptionAmount": consumptionAmount,
    };
  }

  factory MedicationConsumptionTimeWithAmount.fromMap(
    Map<String, dynamic> map,
  ) {
    return MedicationConsumptionTimeWithAmount(
      id: map["id"] ?? "",
      time: TimeOfDay(hour: map["time"]["hour"], minute: map["time"]["minute"]),
      consumptionAmount: map["consumptionAmount"],
    );
  }

  @override
  String toString() {
    return "id: $id; laikas: ${time.hour}:${time.minute}; kiekis: $consumptionAmount";
  }
}
