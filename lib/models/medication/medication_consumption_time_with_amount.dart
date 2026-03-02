import 'package:flutter/material.dart';

class MedicationConsumptionTimeWithAmount {
  final TimeOfDay time;
  final int consumptionAmount;

  MedicationConsumptionTimeWithAmount({
    required this.time,
    required this.consumptionAmount,
  });

  @override
  String toString() {
    return "laikas: ${time.hour}:${time.minute}; kiekis: $consumptionAmount";
  }
}
