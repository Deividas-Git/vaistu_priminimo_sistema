import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric.dart';
import 'package:vaistu_priminimo_sistema/services/health_metrics_service.dart';

class HealthMetricsProvider extends ChangeNotifier {
  final HealthMetricsService _healthMetricsService;
  StreamSubscription? _streamSubscription;
  List<HealthMetric> _healthMetrics = [];
  List<HealthMetric> get healthMetrics => _healthMetrics;

  HealthMetricsProvider(this._healthMetricsService);

  void startListening(String uid) {
    _streamSubscription?.cancel();
    _streamSubscription = _healthMetricsService.healthMetricStream(uid).listen((
      healthMetrics,
    ) {
      _healthMetrics = healthMetrics;
      notifyListeners();
    });
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _healthMetrics = [];
  }

  Future<void> saveHealthMetric(String uid, HealthMetric healthMetric) async {
    await _healthMetricsService.saveHealthMetric(
      uid: uid,
      healthMetric: healthMetric,
    );
  }

  Future<void> removeHealthMetric(String uid, HealthMetric healthMetric) async {
    await _healthMetricsService.removeHealthMetric(
      uid: uid,
      healthMetric: healthMetric,
    );
  }
}
