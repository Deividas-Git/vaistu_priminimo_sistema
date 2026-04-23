import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';

void main() {
  group('MedicationFrequencyType', () {
    test('constantIntervals has correct label', () {
      expect(
        MedicationFrequencyType.constantIntervals.getLabel,
        'Pastovūs intervalai',
      );
    });

    test('selectedDays has correct label', () {
      expect(
        MedicationFrequencyType.selectedDays.getLabel,
        'Pasirinktomis dienomis',
      );
    });

    test('intervalDaysLabels is correct', () {
      expect(MedicationFrequencyType.intervalDaysLabels, [
        'Kiekvieną dieną',
        'Kas antrą dieną',
        'Kas trečią dieną',
        'Kas ketvirtą dieną',
        'Kas penktą dieną',
        'Kas šeštą dieną',
        'Kas savaitę',
      ]);
    });

    test('weekdays is correct', () {
      expect(MedicationFrequencyType.weekdays, Weekday.values);
    });
  });
}
