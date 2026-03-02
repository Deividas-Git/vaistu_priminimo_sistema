import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';

class MedicationSchedule {
  final DateTime startDate;
  final DateTime? endDate;
  final MedicationFrequencyType medicationFrequencyType;
  final int? intervalsDays;
  final List<Weekday>? weekdays;
  final List<MedicationConsumptionTimeWithAmount>? consumptionTimesWithAmount;
  final String? name;

  MedicationSchedule({
    required this.startDate,
    this.endDate,
    required this.medicationFrequencyType,
    this.intervalsDays,
    this.weekdays,
    this.consumptionTimesWithAmount,
    required this.name,
  });

  MedicationSchedule copyWith({
    DateTime? startDate,
    DateTime? endDate,
    MedicationFrequencyType? medicationFrequencyType,
    int? intervalsDays,
    List<Weekday>? weekdays,
    List<MedicationConsumptionTimeWithAmount>? consumptionTimesWithAmount,
    String? name,
  }) {
    return MedicationSchedule(
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

  @override
  String toString() {
    return "Pavadinimas: $name, Pradzia: $startDate, Pabaiga: $endDate, Daznumo tipas: $medicationFrequencyType, Intervalai: $intervalsDays, Pasirinktos dienos: $weekdays, Laikai ir kiekiai: $consumptionTimesWithAmount";
  }
}
