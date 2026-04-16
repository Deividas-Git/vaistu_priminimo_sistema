import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric.dart';
import 'package:vaistu_priminimo_sistema/models/log_level.dart';
import 'package:vaistu_priminimo_sistema/services/log_service.dart';

class HealthMetricsService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<HealthMetric>> healthMetricStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("health_metrics")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HealthMetric.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> saveHealthMetric({
    required String uid,
    required HealthMetric healthMetric,
  }) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("health_metrics")
          .doc(healthMetric.id)
          .set(healthMetric.toMap());
      await LogService.instance.log(
        level: LogLevel.info,
        action: "health metric saved",
        details: healthMetric.toMap().toString(),
      );
    } on FirebaseException catch (e) {
      await LogService.instance.log(
        level: LogLevel.error,
        action: "health metric not saved",
        details: "${e.message} ${e.code}",
      );
    }
  }

  Future<void> removeHealthMetric({
    required String uid,
    required HealthMetric healthMetric,
  }) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("health_metrics")
          .doc(healthMetric.id)
          .delete();
      await LogService.instance.log(
        level: LogLevel.info,
        action: "health metric removed",
        details: "health metric id: ${healthMetric.id}",
      );
    } on FirebaseException catch (e) {
      await LogService.instance.log(
        level: LogLevel.error,
        action: "health metric not removed",
        details: "${e.message} ${e.code}",
      );
    }
  }
}
