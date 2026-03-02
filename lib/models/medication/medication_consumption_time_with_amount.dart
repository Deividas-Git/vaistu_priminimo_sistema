import 'package:flutter/material.dart';

class MedicationConsumptionTimeWithAmount {
  final TimeOfDay time;
  final int consumptionAmount;

  MedicationConsumptionTimeWithAmount({
    required this.time,
    required this.consumptionAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      "time": {"hour": time.hour, "minute": time.minute},
      "consumptionAmount": consumptionAmount,
    };
  }

  factory MedicationConsumptionTimeWithAmount.fromMap(
    Map<String, dynamic> map,
  ) {
    return MedicationConsumptionTimeWithAmount(
      time: TimeOfDay(hour: map["time"]["hour"], minute: map["time"]["minute"]),
      consumptionAmount: map["consumptionAmount"],
    );
  }

  @override
  String toString() {
    return "laikas: ${time.hour}:${time.minute}; kiekis: $consumptionAmount";
  }
}
