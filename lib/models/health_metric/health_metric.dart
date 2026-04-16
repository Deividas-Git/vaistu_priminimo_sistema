import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric_type.dart';

class HealthMetric {
  final String id;
  final String medicationId;
  final HealthMetricType healthMetricType;
  final double value;
  final DateTime dateMeasured;

  HealthMetric({
    required this.id,
    required this.medicationId,
    required this.healthMetricType,
    required this.value,
    required this.dateMeasured,
  });

  Map<String, dynamic> toMap() {
    return {
      "medicationId": medicationId,
      "healthMetricType": healthMetricType.name,
      "value": value,
      "dateMeasured": Timestamp.fromDate(dateMeasured),
    };
  }

  factory HealthMetric.fromMap(Map<String, dynamic> map, String id) {
    return HealthMetric(
      id: id,
      medicationId: map["medicationId"],
      healthMetricType: HealthMetricType.values.byName(map["healthMetricType"]),
      value: map["value"],
      dateMeasured: (map["dateMeasured"] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return "medId: $medicationId; metrika: $healthMetricType; reiksme: $value; data: $dateMeasured";
  }
}
