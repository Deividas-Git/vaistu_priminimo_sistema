import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';

void main() {
  group('DateHelper Tests', () {
    test('formats date correctly', () {
      final date = DateTime(2026, 4, 20);

      expect(DateHelper.getFormattedDate(date), '2026-04-20');
    });

    test('formats time correctly', () {
      final date = DateTime(2026, 4, 20, 8, 5);

      expect(DateHelper.getFormattedTime(date), '08:05');
    });

    test('normalized date removes time', () {
      final date = DateTime(2026, 4, 20, 14, 55);

      final result = DateHelper.normalizedDate(date);

      expect(result, DateTime(2026, 4, 20));
    });

    test('deviation label works', () {
      expect(DateHelper.getConsumptioDeviationTime(125), ' 2 val. 5 min.');
    });
  });
}
