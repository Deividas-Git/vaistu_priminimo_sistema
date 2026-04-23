import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';

import 'package:vaistu_priminimo_sistema/services/medication_progress_service.dart';

import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';

void main() {
  late MedicationProgressService service;

  setUp(() {
    service = MedicationProgressService();
  });

  UserMedication buildMedication({
    required DateTime startDate,
    DateTime? endDate,
  }) {
    return UserMedication(
      id: 'med1',
      medicationSchedules: [
        MedicationSchedule(
          name: 'Test',
          startDate: startDate,
          endDate: endDate,
          intervalsDays: 1,
          medicationFrequencyType: MedicationFrequencyType.constantIntervals,
          consumptionTimesWithAmount: [
            MedicationConsumptionTimeWithAmount(
              id: 'time1',
              time: TimeOfDay(hour: 8, minute: 0),
              consumptionAmount: 1,
            ),
          ],
        ),
      ],
    );
  }

  group('MedicationProgressService Tests', () {
    test('returns null when medication starts today', () {
      final medication = buildMedication(startDate: DateTime.now());

      final result = service.getMedicationProgress(
        records: [],
        medication: medication,
      );

      expect(result, null);
    });

    test('returns zero adherence when no records exist', () {
      final medication = buildMedication(
        startDate: DateTime.now().subtract(const Duration(days: 3)),
      );

      final result = service.getMedicationProgress(
        records: [],
        medication: medication,
      );

      expect(result, isNotNull);
      expect(result!.timesTaken, 0);
      expect(result.adherenceRate, 0);
    });

    test('counts taken records correctly', () {
      final medication = buildMedication(
        startDate: DateTime.now().subtract(const Duration(days: 5)),
      );

      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
        takenDate: DateTime.now().subtract(const Duration(days: 2)),
        state: MedicationRecordState.taken,
        delayedUntil: null,
      );

      final result = service.getMedicationProgress(
        records: [record],
        medication: medication,
      );

      expect(result!.timesTaken, 1);
    });

    test('counts skipped records correctly', () {
      final medication = buildMedication(
        startDate: DateTime.now().subtract(const Duration(days: 5)),
      );

      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
        state: MedicationRecordState.skipped,
        takenDate: null,
        delayedUntil: null,
      );

      final result = service.getMedicationProgress(
        records: [record],
        medication: medication,
      );

      expect(result!.timesSkipped, 1);
    });

    test('counts delayed records correctly', () {
      final medication = buildMedication(
        startDate: DateTime.now().subtract(const Duration(days: 5)),
      );

      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
        delayedUntil: DateTime.now(),
        state: MedicationRecordState.delayed,
        takenDate: null,
      );

      final result = service.getMedicationProgress(
        records: [record],
        medication: medication,
      );

      expect(result!.timesDelayed, 1);
    });

    test('counts missed records correctly', () {
      final medication = buildMedication(
        startDate: DateTime.now().subtract(const Duration(days: 5)),
      );

      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
        state: MedicationRecordState.missed,
        takenDate: null,
        delayedUntil: null,
      );

      final result = service.getMedicationProgress(
        records: [record],
        medication: medication,
      );

      expect(result!.timesMissed >= 1, true);
    });

    test('calculates adherence rate correctly', () {
      final medication = buildMedication(
        startDate: DateTime.now().subtract(const Duration(days: 3)),
      );

      final records = [
        MedicationRecord(
          id: '1',
          medicationId: 'med1',
          scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
          takenDate: DateTime.now().subtract(const Duration(days: 2)),
          delayedUntil: null,
          state: MedicationRecordState.taken,
        ),
        MedicationRecord(
          id: '2',
          medicationId: 'med1',
          scheduledDate: DateTime.now().subtract(const Duration(days: 1)),
          state: MedicationRecordState.skipped,
          takenDate: null,
          delayedUntil: null,
        ),
      ];

      final result = service.getMedicationProgress(
        records: records,
        medication: medication,
      );

      expect(result!.adherenceRate, 50);
    });

    test('calculates average deviation in minutes', () {
      final medication = buildMedication(
        startDate: DateTime.now().subtract(const Duration(days: 3)),
      );

      final scheduled = DateTime.now().subtract(const Duration(days: 2));

      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: scheduled,
        takenDate: scheduled.add(const Duration(minutes: 10)),
        state: MedicationRecordState.taken,
        delayedUntil: null,
      );

      final result = service.getMedicationProgress(
        records: [record],
        medication: medication,
      );

      expect(result!.deviation, 10);
    });

    test('uses medication endDate when ended in past', () {
      final medication = buildMedication(
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().subtract(const Duration(days: 5)),
      );

      final result = service.getMedicationProgress(
        records: [],
        medication: medication,
      );

      expect(result!.endDate.isBefore(DateTime.now()), true);
    });
  });
}
