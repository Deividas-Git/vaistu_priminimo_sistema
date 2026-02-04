import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/weekdays.dart';

class MedicationSchedule {
  final DateTime startDate;
  final DateTime? endDate;
  final MedicationFrequencyType medicationFrequencyType;
  final int? intervalsDays;
  final List<Weekdays>? weekdays;

  MedicationSchedule({
    required this.startDate,
    this.endDate,
    required this.medicationFrequencyType,
    this.intervalsDays,
    this.weekdays,
  });
}
