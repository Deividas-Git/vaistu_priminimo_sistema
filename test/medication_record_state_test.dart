import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';

void main() {
  group('MedicationRecordState', () {
    test('taken has correct label', () {
      expect(MedicationRecordState.taken.getLabel, 'Suvartota');
    });

    test('missed has correct label', () {
      expect(MedicationRecordState.missed.getLabel, 'Nevartota');
    });

    test('pending has correct label', () {
      expect(MedicationRecordState.pending.getLabel, 'Laukiama');
    });

    test('skipped has correct label', () {
      expect(MedicationRecordState.skipped.getLabel, 'Praleista');
    });

    test('delayed has correct label', () {
      expect(MedicationRecordState.delayed.getLabel, 'Atidėta');
    });

    test('getColorForStateLabel returns correct colors', () {
      final colorScheme = ColorScheme.light();
      expect(
        MedicationRecordState.getColorForStateLabel(
          colorScheme,
          MedicationRecordState.taken,
        ),
        const Color.fromARGB(255, 55, 133, 56),
      );
      expect(
        MedicationRecordState.getColorForStateLabel(
          colorScheme,
          MedicationRecordState.missed,
        ),
        colorScheme.error,
      );
      expect(
        MedicationRecordState.getColorForStateLabel(
          colorScheme,
          MedicationRecordState.pending,
        ),
        colorScheme.onSurfaceVariant,
      );
      expect(
        MedicationRecordState.getColorForStateLabel(
          colorScheme,
          MedicationRecordState.skipped,
        ),
        const Color.fromARGB(255, 198, 150, 4),
      );
      expect(
        MedicationRecordState.getColorForStateLabel(
          colorScheme,
          MedicationRecordState.delayed,
        ),
        Colors.blue,
      );
    });
  });
}
