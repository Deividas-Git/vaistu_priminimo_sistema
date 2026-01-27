import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/weekdays.dart';

class MedicationSchedule {
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  MedicationFrequencyType medicationFrequencyType =
      MedicationFrequencyType.constantIntervals;
  int? intervalsDays;
  List<Weekdays>? weekdays = [];

  MedicationSchedule({
    required this.startDate,
    this.endDate,
    required this.medicationFrequencyType,
    this.intervalsDays,
    this.weekdays,
  });
}
