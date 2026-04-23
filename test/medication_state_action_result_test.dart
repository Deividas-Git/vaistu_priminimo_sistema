import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_state_action_result.dart';

void main() {
  group('MedicationStateActionResult', () {
    test('constructor sets values correctly', () {
      final delayed = DateTime(2023, 1, 1, 9, 0);
      final taken = DateTime(2023, 1, 1, 8, 0);
      final result = MedicationStateActionResult(
        delayedUntil: delayed,
        takenAt: taken,
        state: MedicationRecordState.delayed,
      );
      expect(result.delayedUntil, delayed);
      expect(result.takenAt, taken);
      expect(result.state, MedicationRecordState.delayed);
    });

    test('toString formats correctly', () {
      final delayed = DateTime(2023, 1, 1, 9, 0);
      final result = MedicationStateActionResult(
        delayedUntil: delayed,
        state: MedicationRecordState.delayed,
      );
      expect(result.toString(), contains('Atideta:'));
      expect(result.state, MedicationRecordState.delayed);
    });
  });
}
