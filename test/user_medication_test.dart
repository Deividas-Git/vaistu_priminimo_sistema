import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';

void main() {
  group('UserMedication Logic', () {
    test('gets earliest consumption start date', () {
      final med = UserMedication(
        medicationSchedules: [
          MedicationSchedule(
            startDate: DateTime(2026, 5, 1),
            medicationFrequencyType: MedicationFrequencyType.constantIntervals,
            intervalsDays: 1,
            name: 'A',
          ),
          MedicationSchedule(
            startDate: DateTime(2026, 4, 20),
            medicationFrequencyType: MedicationFrequencyType.constantIntervals,
            intervalsDays: 1,
            name: 'B',
          ),
        ],
      );

      expect(med.getConsumptionStartDate(), DateTime(2026, 4, 20));
    });

    test('gets latest end date', () {
      final med = UserMedication(
        medicationSchedules: [
          MedicationSchedule(
            startDate: DateTime(2026, 4, 1),
            endDate: DateTime(2026, 4, 15),
            medicationFrequencyType: MedicationFrequencyType.constantIntervals,
            intervalsDays: 1,
            name: 'A',
          ),
          MedicationSchedule(
            startDate: DateTime(2026, 4, 1),
            endDate: DateTime(2026, 4, 30),
            medicationFrequencyType: MedicationFrequencyType.constantIntervals,
            intervalsDays: 1,
            name: 'B',
          ),
        ],
      );

      expect(med.getConsumptionEndDate(), DateTime(2026, 4, 30));
    });

    test('included in selected weekday schedule', () {
      final schedule = MedicationSchedule(
        startDate: DateTime(2026, 4, 1),
        medicationFrequencyType: MedicationFrequencyType.selectedDays,
        weekdays: [Weekday.monday],
        name: 'Test',
      );

      final med = UserMedication();

      final monday = DateTime(2026, 4, 20);

      expect(med.isInculdedInSchedule(schedule, monday), true);
    });

    test('included in every 2 day interval', () {
      final schedule = MedicationSchedule(
        startDate: DateTime(2026, 4, 20),
        medicationFrequencyType: MedicationFrequencyType.constantIntervals,
        intervalsDays: 2,
        name: 'Test',
      );

      final med = UserMedication();

      expect(med.isInculdedInSchedule(schedule, DateTime(2026, 4, 22)), true);
    });
  });
}
