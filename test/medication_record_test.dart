import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';

void main() {
  group('MedicationRecord', () {
    test('constructor sets values correctly', () {
      final scheduled = DateTime(2023, 1, 1, 8, 0);
      final taken = DateTime(2023, 1, 1, 8, 5);
      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: scheduled,
        takenDate: taken,
        delayedUntil: null,
        state: MedicationRecordState.taken,
      );
      expect(record.id, '1');
      expect(record.medicationId, 'med1');
      expect(record.scheduledDate, scheduled);
      expect(record.takenDate, taken);
      expect(record.delayedUntil, null);
      expect(record.state, MedicationRecordState.taken);
    });

    test('toMap returns correct map', () {
      final scheduled = DateTime(2023, 1, 1, 8, 0);
      final taken = DateTime(2023, 1, 1, 8, 5);
      final record = MedicationRecord(
        id: '1',
        medicationId: 'med1',
        scheduledDate: scheduled,
        takenDate: taken,
        delayedUntil: null,
        state: MedicationRecordState.taken,
      );
      final map = record.toMap();
      expect(map['medicationId'], 'med1');
      expect((map['scheduledDate'] as Timestamp).toDate(), scheduled);
      expect((map['takenDate'] as Timestamp).toDate(), taken);
      expect(map['state'], 'taken');
      expect(map.containsKey('delayedUntil'), false);
    });

    test('fromMap creates instance correctly', () {
      final scheduled = DateTime(2023, 1, 1, 8, 0);
      final taken = DateTime(2023, 1, 1, 8, 5);
      final map = {
        'medicationId': 'med1',
        'scheduledDate': Timestamp.fromDate(scheduled),
        'takenDate': Timestamp.fromDate(taken),
        'state': 'taken',
      };
      final record = MedicationRecord.fromMap(map, '1');
      expect(record.id, '1');
      expect(record.medicationId, 'med1');
      expect(record.scheduledDate, scheduled);
      expect(record.takenDate, taken);
      expect(record.state, MedicationRecordState.taken);
    });

    test('buildId generates correct id', () {
      final date = DateTime(2023, 1, 1);
      final id = MedicationRecord.buildId(
        medicationId: 'med1',
        timeId: 'time1',
        date: date,
      );
      expect(id, 'med1_time1_20230101');
    });
  });
}
