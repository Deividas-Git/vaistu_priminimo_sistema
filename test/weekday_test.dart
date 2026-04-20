import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';

void main() {
  group('Weekday Tests', () {
    test('returns monday from 1', () {
      expect(Weekday.getWeekdayFromNumber(1), Weekday.monday);
    });

    test('returns sunday from 7', () {
      expect(Weekday.getWeekdayFromNumber(7), Weekday.sunday);
    });

    test('returns label ket from 4', () {
      expect(Weekday.getWeekdayFromNumber(4), Weekday.thursday);
    });

    test('throws exception on invalid number', () {
      expect(() => Weekday.getWeekdayFromNumber(8), throwsException);
    });
  });
}
