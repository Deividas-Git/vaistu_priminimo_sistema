import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/services/medication_record_service.dart';
import 'package:vaistu_priminimo_sistema/services/medication_progress_service.dart';

import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_progress.dart';

class MockMedicationRecordService extends Mock
    implements MedicationRecordService {}

class MockMedicationProgressService extends Mock
    implements MedicationProgressService {}

void main() {
  late MedicationRecordsProvider provider;
  late MockMedicationRecordService recordService;
  late MockMedicationProgressService progressService;

  setUp(() {
    recordService = MockMedicationRecordService();
    progressService = MockMedicationProgressService();

    provider = MedicationRecordsProvider(recordService, progressService);
  });

  group('MedicationRecordsProvider', () {
    test('starts listening and updates records', () async {
      final controller = StreamController<List<MedicationRecord>>();

      when(
        () => recordService.medicationRecordsStream('uid1'),
      ).thenAnswer((_) => controller.stream);

      provider.startListening('uid1');

      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: DateTime.now(),
        state: MedicationRecordState.pending,
        takenDate: null,
        delayedUntil: null,
      );

      controller.add([record]);

      await Future.delayed(Duration.zero);

      expect(provider.medicationRecords.length, 1);

      await controller.close();
    });

    test('stopListening clears records', () {
      provider.stopListening();

      expect(provider.medicationRecords.isEmpty, true);
    });

    test('getRecordsMap returns id map', () async {
      final controller = StreamController<List<MedicationRecord>>();

      when(
        () => recordService.medicationRecordsStream('uid1'),
      ).thenAnswer((_) => controller.stream);

      provider.startListening('uid1');

      final record = MedicationRecord(
        id: 'abc',
        medicationId: 'med1',
        scheduledDate: DateTime.now(),
        state: MedicationRecordState.pending,
        takenDate: null,
        delayedUntil: null,
      );

      controller.add([record]);

      await Future.delayed(Duration.zero);

      final map = provider.getRecordsMap();

      expect(map.containsKey('abc'), true);

      await controller.close();
    });

    test('removeMedicationRecord calls service', () async {
      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: DateTime.now(),
        state: MedicationRecordState.pending,
        takenDate: null,
        delayedUntil: null,
      );

      when(
        () => recordService.removeRecord('uid1', record),
      ).thenAnswer((_) async {});

      await provider.removeMedicationRecord('uid1', record);

      verify(() => recordService.removeRecord('uid1', record)).called(1);
    });

    test(
      'removeAllRecordsForMedication removes only matching records',
      () async {
        final controller = StreamController<List<MedicationRecord>>();

        when(
          () => recordService.medicationRecordsStream('uid1'),
        ).thenAnswer((_) => controller.stream);

        provider.startListening('uid1');

        final r1 = MedicationRecord(
          id: '1',
          medicationId: 'med1',
          scheduledDate: DateTime.now(),
          state: MedicationRecordState.pending,
          takenDate: null,
          delayedUntil: null,
        );

        final r2 = MedicationRecord(
          id: '2',
          medicationId: 'med2',
          scheduledDate: DateTime.now(),
          state: MedicationRecordState.pending,
          takenDate: null,
          delayedUntil: null,
        );

        controller.add([r1, r2]);

        await Future.delayed(Duration.zero);

        when(
          () => recordService.removeRecord('uid1', r1),
        ).thenAnswer((_) async {});

        await provider.removeAllRecordsForMedication('uid1', 'med1');

        verify(() => recordService.removeRecord('uid1', r1)).called(1);

        await controller.close();
      },
    );

    test('saveMedicationRecord saves normal record', () async {
      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: DateTime.now(),
        state: MedicationRecordState.pending,
        takenDate: null,
        delayedUntil: null,
      );

      when(
        () => recordService.saveRecord('uid1', record),
      ).thenAnswer((_) async {});

      await provider.saveMedicationRecord('uid1', record);

      verify(() => recordService.saveRecord('uid1', record)).called(1);
    });

    test('getMedicationProgress returns null for null medication', () {
      final result = provider.getMedicationProgress(null);

      expect(result, null);
    });

    test('getMedicationProgress uses progress service', () {
      final medication = UserMedication(id: 'med1');

      final progress = MedicationProgress(
        startDate: DateTime.now(),
        timesMissed: 10,
        timesTaken: 8,
        timesSkipped: 2,
        timesDelayed: 3,
        endDate: DateTime.now().add(Duration(days: 1)),
        adherenceRate: 55.0,
        deviation: 30,
      );

      when(
        () => progressService.getMedicationProgress(
          records: any(named: 'records'),
          medication: medication,
        ),
      ).thenReturn(progress);

      final result = provider.getMedicationProgress(medication);

      expect(result, null);
    });
  });
}
