import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/active_ingredient.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_form.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';

void main() {
  group('UserMedication', () {
    test('constructor sets values correctly', () {
      final med = UserMedication(
        id: '1',
        name: 'Aspirin',
        currentQuantity: 100.0,
        medicationForm: MedicationForm.pills,
        activeIngredient: ActiveIngredient.ibuprofen,
        medicationMealTiming: MedicationMealTiming.beforeMeal,
        expirationDate: DateTime(2024, 1, 1),
        addedAt: DateTime(2023, 1, 1),
        registrationNr: '123',
      );
      expect(med.id, '1');
      expect(med.name, 'Aspirin');
      expect(med.currentQuantity, 100.0);
      expect(med.medicationForm, MedicationForm.pills);
      expect(med.activeIngredient, ActiveIngredient.ibuprofen);
      expect(med.medicationMealTiming, MedicationMealTiming.beforeMeal);
      expect(med.expirationDate, DateTime(2024, 1, 1));
      expect(med.addedAt, DateTime(2023, 1, 1));
      expect(med.registrationNr, '123');
    });

    test('empty factory creates empty instance', () {
      final med = UserMedication.empty();
      expect(med.id, null);
      expect(med.name, null);
    });

    test('copyWith updates values', () {
      final original = UserMedication(name: 'Original');
      final copied = original.copyWith(name: 'Copied');
      expect(copied.name, 'Copied');
    });

    test('toMap and fromMap roundtrip', () {
      final med = UserMedication(
        name: 'Aspirin',
        medicationForm: MedicationForm.pills,
        activeIngredient: ActiveIngredient.ibuprofen,
        medicationMealTiming: MedicationMealTiming.beforeMeal,
        currentQuantity: 100.0,
        expirationDate: DateTime(2024, 1, 1),
        addedAt: DateTime(2023, 1, 1),
        registrationNr: '123',
      );
      final map = med.toMap();
      final restored = UserMedication.fromMap(map, '1');
      expect(restored.name, 'Aspirin');
      expect(restored.medicationForm, MedicationForm.pills);
    });

    test('getConsumptionStartDate returns earliest start', () {
      final med = UserMedication(
        medicationSchedules: [
          MedicationSchedule(
            startDate: DateTime(2023, 1, 2),
            medicationFrequencyType: MedicationFrequencyType.constantIntervals,
            name: 'A',
          ),
          MedicationSchedule(
            startDate: DateTime(2023, 1, 1),
            medicationFrequencyType: MedicationFrequencyType.constantIntervals,
            name: 'B',
          ),
        ],
      );
      expect(med.getConsumptionStartDate(), DateTime(2023, 1, 1));
    });

    test('getConsumptionEndDate returns latest end', () {
      final med = UserMedication(
        medicationSchedules: [
          MedicationSchedule(
            startDate: DateTime(2023, 1, 1),
            endDate: DateTime(2023, 1, 15),
            medicationFrequencyType: MedicationFrequencyType.constantIntervals,
            name: 'A',
          ),
          MedicationSchedule(
            startDate: DateTime(2023, 1, 1),
            endDate: DateTime(2023, 1, 30),
            medicationFrequencyType: MedicationFrequencyType.constantIntervals,
            name: 'B',
          ),
        ],
      );
      expect(med.getConsumptionEndDate(), DateTime(2023, 1, 30));
    });

    test('isInculdedInSchedule works for constant intervals', () {
      final schedule = MedicationSchedule(
        startDate: DateTime(2023, 1, 1),
        medicationFrequencyType: MedicationFrequencyType.constantIntervals,
        intervalsDays: 2,
        name: 'Test',
      );
      final med = UserMedication(medicationSchedules: [schedule]);
      expect(med.isInculdedInSchedule(schedule, DateTime(2023, 1, 1)), true);
      expect(med.isInculdedInSchedule(schedule, DateTime(2023, 1, 3)), true);
      expect(med.isInculdedInSchedule(schedule, DateTime(2023, 1, 2)), false);
    });

    test('toString formats correctly', () {
      final med = UserMedication(name: 'Aspirin');
      expect(med.toString(), contains('Vaistas: Aspirin'));
    });
  });
}
