import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';

class AgendaItem {
  final String medicationId;
  final String medicationName;
  final int amountToTake;
  final MedicationMealTiming medicationMealTiming;
  final TimeOfDay time;

  AgendaItem({
    required this.medicationId,
    required this.medicationName,
    required this.amountToTake,
    required this.medicationMealTiming,
    required this.time,
  });

  @override
  String toString() {
    return "Med ID: $medicationId, vaistas: $medicationName, laikas: $time, kiekis: $amountToTake, vartojama: $medicationMealTiming";
  }
}
