import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';

void main() {
  group('MedicationSchedule', () {
    test('constructor sets values correctly', () {
      final start = DateTime(2023, 1, 1);
      final end = DateTime(2023, 1, 31);
      final times = [
        MedicationConsumptionTimeWithAmount(
          id: '1',
          time: TimeOfDay(hour: 8, minute: 0),
          consumptionAmount: 1,
        ),
      ];
      final schedule = MedicationSchedule(
        startDate: start,
        endDate: end,
        medicationFrequencyType: MedicationFrequencyType.constantIntervals,
        intervalsDays: 1,
        weekdays: null,
        consumptionTimesWithAmount: times,
        name: 'Test',
      );
      expect(schedule.startDate, start);
      expect(schedule.endDate, end);
      expect(
        schedule.medicationFrequencyType,
        MedicationFrequencyType.constantIntervals,
      );
      expect(schedule.intervalsDays, 1);
      expect(schedule.weekdays, null);
      expect(schedule.consumptionTimesWithAmount, times);
      expect(schedule.name, 'Test');
    });

    test('copyWith updates values', () {
      final original = MedicationSchedule(
        startDate: DateTime(2023, 1, 1),
        medicationFrequencyType: MedicationFrequencyType.constantIntervals,
        name: 'Original',
      );
      final copied = original.copyWith(name: 'Copied');
      expect(copied.name, 'Copied');
      expect(copied.startDate, original.startDate);
    });

    test('toMap and fromMap roundtrip', () {
      final start = DateTime(2023, 1, 1);
      final end = DateTime(2023, 1, 31);
      final times = [
        MedicationConsumptionTimeWithAmount(
          id: '1',
          time: TimeOfDay(hour: 8, minute: 0),
          consumptionAmount: 1,
        ),
      ];
      final original = MedicationSchedule(
        startDate: start,
        endDate: end,
        medicationFrequencyType: MedicationFrequencyType.constantIntervals,
        intervalsDays: 1,
        consumptionTimesWithAmount: times,
        name: 'Test',
      );
      final map = original.toMap();
      final restored = MedicationSchedule.fromMap(map);
      expect(restored.startDate, start);
      expect(restored.endDate, end);
      expect(restored.name, 'Test');
    });

    test('toString formats correctly', () {
      final schedule = MedicationSchedule(
        startDate: DateTime(2023, 1, 1),
        medicationFrequencyType: MedicationFrequencyType.constantIntervals,
        name: 'Test',
      );
      expect(schedule.toString(), contains('Pavadinimas: Test'));
    });
  });
}
