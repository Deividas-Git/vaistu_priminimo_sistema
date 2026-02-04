import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';

class MedicationSchedule {
  final DateTime startDate;
  final DateTime? endDate;
  final MedicationFrequencyType medicationFrequencyType;
  final int? intervalsDays;
  final List<Weekday>? weekdays;

  MedicationSchedule({
    required this.startDate,
    this.endDate,
    required this.medicationFrequencyType,
    this.intervalsDays,
    this.weekdays,
  });
}
