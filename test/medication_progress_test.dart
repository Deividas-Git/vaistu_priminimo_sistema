import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_progress.dart';

void main() {
  group('MedicationProgress', () {
    test('constructor sets values correctly', () {
      final start = DateTime(2023, 1, 1);
      final end = DateTime(2023, 1, 31);
      final progress = MedicationProgress(
        startDate: start,
        endDate: end,
        timesTaken: 10,
        timesDelayed: 2,
        timesSkipped: 1,
        timesMissed: 0,
        adherenceRate: 0.8,
        deviation: 5,
      );
      expect(progress.startDate, start);
      expect(progress.endDate, end);
      expect(progress.timesTaken, 10);
      expect(progress.timesDelayed, 2);
      expect(progress.timesSkipped, 1);
      expect(progress.timesMissed, 0);
      expect(progress.adherenceRate, 0.8);
      expect(progress.deviation, 5);
    });

    test('toString formats correctly', () {
      final start = DateTime(2023, 1, 1);
      final end = DateTime(2023, 1, 31);
      final progress = MedicationProgress(
        startDate: start,
        endDate: end,
        timesTaken: 10,
        timesDelayed: 2,
        timesSkipped: 1,
        timesMissed: 0,
        adherenceRate: 0.8,
        deviation: 5,
      );
      expect(progress.toString(), contains('Taken: 10'));
      expect(progress.toString(), contains('adherence 0.8'));
    });
  });
}
