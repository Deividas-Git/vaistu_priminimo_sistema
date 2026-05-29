import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/log_level.dart';

void main() {
  group('LogLevel', () {
    test('info has correct label', () {
      expect(LogLevel.info.getLabel, 'INFO');
    });

    test('warning has correct label', () {
      expect(LogLevel.warning.getLabel, 'WARNING');
    });

    test('error has correct label', () {
      expect(LogLevel.error.getLabel, 'ERROR');
    });

    test('debug has correct label', () {
      expect(LogLevel.debug.getLabel, 'DEBUG');
    });

    test('critical has correct label', () {
      expect(LogLevel.critical.getLabel, 'CRITICAL');
    });

    test('all enum values have labels', () {
      final expectedLabels = {
        LogLevel.info: 'INFO',
        LogLevel.warning: 'WARNING',
        LogLevel.error: 'ERROR',
        LogLevel.debug: 'DEBUG',
        LogLevel.critical: 'CRITICAL',
      };

      for (final level in LogLevel.values) {
        expect(level.getLabel, expectedLabels[level]);
      }
    });

    test('getLabel returns uppercase version of name', () {
      expect(LogLevel.info.name, 'info');
      expect(LogLevel.info.getLabel, 'INFO');
      expect(LogLevel.warning.name, 'warning');
      expect(LogLevel.warning.getLabel, 'WARNING');
    });

    test('enum has exactly 5 values', () {
      expect(LogLevel.values.length, 5);
    });
  });
}
