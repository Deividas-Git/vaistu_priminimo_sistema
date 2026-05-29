import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';

void main() {
  group('Weekday', () {
    test('monday has correct label', () {
      expect(Weekday.monday.getLabel, 'Pir');
    });

    test('tuesday has correct label', () {
      expect(Weekday.tuesday.getLabel, 'Ant');
    });

    test('wednesday has correct label', () {
      expect(Weekday.wednesday.getLabel, 'Tre');
    });

    test('thursday has correct label', () {
      expect(Weekday.thursday.getLabel, 'Ket');
    });

    test('friday has correct label', () {
      expect(Weekday.friday.getLabel, 'Pen');
    });

    test('saturday has correct label', () {
      expect(Weekday.saturday.getLabel, 'Šeš');
    });

    test('sunday has correct label', () {
      expect(Weekday.sunday.getLabel, 'Sek');
    });

    test('all enum values have labels', () {
      final expectedLabels = {
        Weekday.monday: 'Pir',
        Weekday.tuesday: 'Ant',
        Weekday.wednesday: 'Tre',
        Weekday.thursday: 'Ket',
        Weekday.friday: 'Pen',
        Weekday.saturday: 'Šeš',
        Weekday.sunday: 'Sek',
      };

      for (final weekday in Weekday.values) {
        expect(weekday.getLabel, expectedLabels[weekday]);
      }
    });

    test('getWeekdayFromNumber returns monday for 1', () {
      expect(Weekday.getWeekdayFromNumber(1), Weekday.monday);
    });

    test('getWeekdayFromNumber returns tuesday for 2', () {
      expect(Weekday.getWeekdayFromNumber(2), Weekday.tuesday);
    });

    test('getWeekdayFromNumber returns wednesday for 3', () {
      expect(Weekday.getWeekdayFromNumber(3), Weekday.wednesday);
    });

    test('getWeekdayFromNumber returns thursday for 4', () {
      expect(Weekday.getWeekdayFromNumber(4), Weekday.thursday);
    });

    test('getWeekdayFromNumber returns friday for 5', () {
      expect(Weekday.getWeekdayFromNumber(5), Weekday.friday);
    });

    test('getWeekdayFromNumber returns saturday for 6', () {
      expect(Weekday.getWeekdayFromNumber(6), Weekday.saturday);
    });

    test('getWeekdayFromNumber returns sunday for 7', () {
      expect(Weekday.getWeekdayFromNumber(7), Weekday.sunday);
    });

    test('getWeekdayFromNumber throws exception for 0', () {
      expect(() => Weekday.getWeekdayFromNumber(0), throwsException);
    });

    test('getWeekdayFromNumber throws exception for 8', () {
      expect(() => Weekday.getWeekdayFromNumber(8), throwsException);
    });

    test('getWeekdayFromNumber throws exception for negative number', () {
      expect(() => Weekday.getWeekdayFromNumber(-1), throwsException);
    });

    test('getWeekdayFromNumber throws exception for large number', () {
      expect(() => Weekday.getWeekdayFromNumber(100), throwsException);
    });

    test('getWeekdayFromNumber maps all valid numbers correctly', () {
      for (int i = 1; i <= 7; i++) {
        expect(Weekday.getWeekdayFromNumber(i), Weekday.values[i - 1]);
      }
    });

    test('enum has exactly 7 values', () {
      expect(Weekday.values.length, 7);
    });

    test('exception message contains the invalid number', () {
      expect(
        () => Weekday.getWeekdayFromNumber(10),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('10'),
          ),
        ),
      );
    });
  });
}
