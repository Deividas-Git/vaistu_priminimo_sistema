import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric_type.dart';

class HealthMetric {
  final String medicationId;
  final HealthMetricType healthMetricType;
  final double value;
  final DateTime dateMeasured;

  HealthMetric({
    required this.medicationId,
    required this.healthMetricType,
    required this.value,
    required this.dateMeasured,
  });

  @override
  String toString() {
    return "medId: $medicationId; metrika: $healthMetricType; reiksme: $value; data: $dateMeasured";
  }
}
