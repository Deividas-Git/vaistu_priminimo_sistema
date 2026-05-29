import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';

void main() {
  group('MedicationConsumptionTimeWithAmount', () {
    test('constructor sets values correctly', () {
      final time = TimeOfDay(hour: 8, minute: 30);
      final item = MedicationConsumptionTimeWithAmount(
        id: '1',
        time: time,
        consumptionAmount: 2,
      );
      expect(item.id, '1');
      expect(item.time, time);
      expect(item.consumptionAmount, 2);
    });

    test('toMap returns correct map', () {
      final time = TimeOfDay(hour: 8, minute: 30);
      final item = MedicationConsumptionTimeWithAmount(
        id: '1',
        time: time,
        consumptionAmount: 2,
      );
      expect(item.toMap(), {
        'id': '1',
        'time': {'hour': 8, 'minute': 30},
        'consumptionAmount': 2,
      });
    });

    test('fromMap creates instance correctly', () {
      final map = {
        'id': '1',
        'time': {'hour': 8, 'minute': 30},
        'consumptionAmount': 2,
      };
      final item = MedicationConsumptionTimeWithAmount.fromMap(map);
      expect(item.id, '1');
      expect(item.time.hour, 8);
      expect(item.time.minute, 30);
      expect(item.consumptionAmount, 2);
    });

    test('toString formats correctly', () {
      final time = TimeOfDay(hour: 8, minute: 30);
      final item = MedicationConsumptionTimeWithAmount(
        id: '1',
        time: time,
        consumptionAmount: 2,
      );
      expect(item.toString(), 'id: 1; laikas: 8:30; kiekis: 2');
    });
  });
}
