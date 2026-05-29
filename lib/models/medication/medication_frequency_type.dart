import 'package:vaistu_priminimo_sistema/models/weekday.dart';

enum MedicationFrequencyType {
  constantIntervals,
  selectedDays;

  static final List<String> intervalDaysLabels = [
    "Kiekvieną dieną",
    "Kas antrą dieną",
    "Kas trečią dieną",
    "Kas ketvirtą dieną",
    "Kas penktą dieną",
    "Kas šeštą dieną",
    "Kas savaitę",
  ];
  static final List<Weekday> weekdays = Weekday.values.toList();

  String get getLabel {
    switch (this) {
      case MedicationFrequencyType.constantIntervals:
        return "Pastovūs intervalai";
      case MedicationFrequencyType.selectedDays:
        return "Pasirinktomis dienomis";
    }
  }
}
