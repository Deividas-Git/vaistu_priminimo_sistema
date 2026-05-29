import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric_type.dart';

import 'package:vaistu_priminimo_sistema/providers/health_metrics_provider.dart';
import 'package:vaistu_priminimo_sistema/services/health_metrics_service.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric.dart';

class MockHealthMetricsService extends Mock implements HealthMetricsService {}

void main() {
  late MockHealthMetricsService service;
  late HealthMetricsProvider provider;

  setUp(() {
    service = MockHealthMetricsService();
    provider = HealthMetricsProvider(service);
  });

  group('HealthMetricsProvider Tests', () {
    test('initial healthMetrics list is empty', () {
      expect(provider.healthMetrics, isEmpty);
    });

    test('startListening updates healthMetrics list from stream', () async {
      final controller = StreamController<List<HealthMetric>>();

      when(
        () => service.healthMetricStream('uid1'),
      ).thenAnswer((_) => controller.stream);

      provider.startListening('uid1');

      final metric = HealthMetric(
        id: '1',
        medicationId: "med1",
        healthMetricType: HealthMetricType.cholesterolMTL,
        value: 120,
        dateMeasured: DateTime.now(),
      );

      controller.add([metric]);

      await Future.delayed(Duration.zero);

      expect(provider.healthMetrics.length, 1);
      expect(provider.healthMetrics.first.id, '1');

      await controller.close();
    });

    test('startListening cancels previous subscription', () async {
      final controller1 = StreamController<List<HealthMetric>>();
      final controller2 = StreamController<List<HealthMetric>>();

      when(
        () => service.healthMetricStream('uid1'),
      ).thenAnswer((_) => controller1.stream);

      when(
        () => service.healthMetricStream('uid2'),
      ).thenAnswer((_) => controller2.stream);

      provider.startListening('uid1');
      provider.startListening('uid2');

      final metric = HealthMetric(
        id: '2',
        value: 80,
        medicationId: "med1",
        healthMetricType: HealthMetricType.cholesterolMTL,
        dateMeasured: DateTime.now(),
      );

      controller2.add([metric]);

      await Future.delayed(Duration.zero);

      expect(provider.healthMetrics.length, 1);
      expect(provider.healthMetrics.first.id, '2');

      await controller1.close();
      await controller2.close();
    });

    test('stopListening clears healthMetrics list', () async {
      final controller = StreamController<List<HealthMetric>>();

      when(
        () => service.healthMetricStream('uid1'),
      ).thenAnswer((_) => controller.stream);

      provider.startListening('uid1');

      controller.add([
        HealthMetric(
          id: '1',
          value: 100,
          medicationId: "med1",
          healthMetricType: HealthMetricType.cholesterolMTL,
          dateMeasured: DateTime.now(),
        ),
      ]);

      await Future.delayed(Duration.zero);

      provider.stopListening();

      expect(provider.healthMetrics, isEmpty);

      await controller.close();
    });

    test('saveHealthMetric calls service', () async {
      final metric = HealthMetric(
        id: '1',
        value: 95,
        medicationId: "med1",
        healthMetricType: HealthMetricType.cholesterolMTL,
        dateMeasured: DateTime.now(),
      );

      when(
        () => service.saveHealthMetric(uid: 'uid1', healthMetric: metric),
      ).thenAnswer((_) async {});

      await provider.saveHealthMetric('uid1', metric);

      verify(
        () => service.saveHealthMetric(uid: 'uid1', healthMetric: metric),
      ).called(1);
    });

    test('removeHealthMetric calls service', () async {
      final metric = HealthMetric(
        id: '1',
        value: 95,
        medicationId: "med1",
        healthMetricType: HealthMetricType.cholesterolMTL,
        dateMeasured: DateTime.now(),
      );

      when(
        () => service.removeHealthMetric(uid: 'uid1', healthMetric: metric),
      ).thenAnswer((_) async {});

      await provider.removeHealthMetric('uid1', metric);

      verify(
        () => service.removeHealthMetric(uid: 'uid1', healthMetric: metric),
      ).called(1);
    });

    test('notifyListeners triggered when stream updates', () async {
      final controller = StreamController<List<HealthMetric>>();

      when(
        () => service.healthMetricStream('uid1'),
      ).thenAnswer((_) => controller.stream);

      var notified = false;

      provider.addListener(() {
        notified = true;
      });

      provider.startListening('uid1');

      controller.add([
        HealthMetric(
          id: '1',
          value: 77,
          medicationId: "med1",
          healthMetricType: HealthMetricType.cholesterolMTL,
          dateMeasured: DateTime.now(),
        ),
      ]);

      await Future.delayed(Duration.zero);

      expect(notified, true);

      await controller.close();
    });
  });
}
