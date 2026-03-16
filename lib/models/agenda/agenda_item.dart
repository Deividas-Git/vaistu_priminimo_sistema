import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';

class AgendaItem {
  final String medicationId;
  final String medicationName;
  final int amountToTake;
  final MedicationMealTiming medicationMealTiming;
  final MedicationType medicationType;
  final TimeOfDay time;
  final String scheduleName;

  AgendaItem({
    required this.medicationId,
    required this.medicationName,
    required this.amountToTake,
    required this.medicationMealTiming,
    required this.medicationType,
    required this.time,
    required this.scheduleName,
  });

  @override
  String toString() {
    return "Med ID: $medicationId, vaistas: $medicationName, laikas: $time, kiekis: $amountToTake, vartojama: $medicationMealTiming, tvarkarastis: $scheduleName";
  }
}
