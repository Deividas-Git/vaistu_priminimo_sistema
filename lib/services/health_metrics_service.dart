import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric.dart';

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
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("health_metrics")
        .doc(healthMetric.id)
        .set(healthMetric.toMap());
  }

  Future<void> removeHealthMetric({
    required String uid,
    required HealthMetric healthMetric,
  }) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("health_metrics")
        .doc(healthMetric.id)
        .delete();
  }
}
