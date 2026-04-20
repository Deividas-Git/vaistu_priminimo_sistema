import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric_type.dart';

void main() {
  group('HealthMetric', () {
    test('constructor sets values correctly', () {
      final date = DateTime(2023, 1, 15, 10, 30);
      final metric = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: date,
      );

      expect(metric.id, '1');
      expect(metric.medicationId, 'med1');
      expect(metric.healthMetricType, HealthMetricType.cholesterolMTL);
      expect(metric.value, 150.5);
      expect(metric.dateMeasured, date);
    });

    test('toMap returns correct map', () {
      final date = DateTime(2023, 1, 15, 10, 30);
      final metric = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: date,
      );

      final map = metric.toMap();

      expect(map['medicationId'], 'med1');
      expect(map['healthMetricType'], 'cholesterolMTL');
      expect(map['value'], 150.5);
      expect((map['dateMeasured'] as Timestamp).toDate(), date);
    });

    test('toMap does not include id', () {
      final metric = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: DateTime(2023, 1, 15),
      );

      final map = metric.toMap();
      expect(map.containsKey('id'), false);
    });

    test('fromMap creates instance correctly', () {
      final date = DateTime(2023, 1, 15, 10, 30);
      final map = {
        'medicationId': 'med1',
        'healthMetricType': 'cholesterolMTL',
        'value': 150.5,
        'dateMeasured': Timestamp.fromDate(date),
      };

      final metric = HealthMetric.fromMap(map, 'id1');

      expect(metric.id, 'id1');
      expect(metric.medicationId, 'med1');
      expect(metric.healthMetricType, HealthMetricType.cholesterolMTL);
      expect(metric.value, 150.5);
      expect(metric.dateMeasured, date);
    });

    test('toMap and fromMap roundtrip', () {
      final date = DateTime(2023, 1, 15, 10, 30);
      final original = HealthMetric(
        id: 'id1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: date,
      );

      final map = original.toMap();
      final restored = HealthMetric.fromMap(map, original.id);

      expect(restored.id, original.id);
      expect(restored.medicationId, original.medicationId);
      expect(restored.healthMetricType, original.healthMetricType);
      expect(restored.value, original.value);
      expect(restored.dateMeasured, original.dateMeasured);
    });

    test('toString formats correctly', () {
      final date = DateTime(2023, 1, 15, 10, 30);
      final metric = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: date,
      );

      final str = metric.toString();
      expect(str, contains('medId: med1'));
      expect(str, contains('metrika: HealthMetricType.cholesterolMTL'));
      expect(str, contains('reiksme: 150.5'));
    });

    test('handles different metric values', () {
      final metric1 = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 100.0,
        dateMeasured: DateTime(2023, 1, 1),
      );

      final metric2 = HealthMetric(
        id: '2',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 200.5,
        dateMeasured: DateTime(2023, 1, 2),
      );

      expect(metric1.value, 100.0);
      expect(metric2.value, 200.5);
      expect(metric1.value, isNot(metric2.value));
    });

    test('handles zero value', () {
      final metric = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 0.0,
        dateMeasured: DateTime(2023, 1, 1),
      );

      expect(metric.value, 0.0);
      expect(metric.toMap()['value'], 0.0);
    });

    test('handles negative value', () {
      final metric = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: -50.5,
        dateMeasured: DateTime(2023, 1, 1),
      );

      expect(metric.value, -50.5);
    });

    test('handles large values', () {
      final metric = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 9999.99,
        dateMeasured: DateTime(2023, 1, 1),
      );

      expect(metric.value, 9999.99);
    });

    test('handles different medication ids', () {
      final metric1 = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: DateTime(2023, 1, 1),
      );

      final metric2 = HealthMetric(
        id: '2',
        medicationId: 'med2',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: DateTime(2023, 1, 1),
      );

      expect(metric1.medicationId, 'med1');
      expect(metric2.medicationId, 'med2');
    });

    test('handles different dates', () {
      final date1 = DateTime(2023, 1, 1, 8, 0);
      final date2 = DateTime(2023, 12, 31, 23, 59);

      final metric1 = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: date1,
      );

      final metric2 = HealthMetric(
        id: '2',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: date2,
      );

      expect(metric1.dateMeasured, date1);
      expect(metric2.dateMeasured, date2);
      expect(metric1.dateMeasured.isBefore(metric2.dateMeasured), true);
    });

    test('fromMap with cholesterolMTL type', () {
      final map = {
        'medicationId': 'med1',
        'healthMetricType': 'cholesterolMTL',
        'value': 150.5,
        'dateMeasured': Timestamp.fromDate(DateTime(2023, 1, 15)),
      };

      final metric = HealthMetric.fromMap(map, 'id1');
      expect(metric.healthMetricType, HealthMetricType.cholesterolMTL);
    });

    test('multiple instances are independent', () {
      final date = DateTime(2023, 1, 1);
      final metric1 = HealthMetric(
        id: '1',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 150.5,
        dateMeasured: date,
      );

      final metric2 = HealthMetric(
        id: '2',
        medicationId: 'med1',
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 200.0,
        dateMeasured: date,
      );

      expect(metric1.id, isNot(metric2.id));
      expect(metric1.value, isNot(metric2.value));
    });
  });
}
