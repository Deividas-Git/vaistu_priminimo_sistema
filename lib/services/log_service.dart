import 'package:cloud_firestore/cloud_firestore.dart';

class LogService {
  final String uid;
  final _firestore = FirebaseFirestore.instance;

  static LogService? _instance;

  LogService._internal({required this.uid});

  static void init({required String uid}) {
    _instance = LogService._internal(uid: uid);
  }

  static LogService get instance {
    if (_instance == null) {
      throw Exception("LogService neinicializuotas");
    }
    return _instance!;
  }

  static void dispose() {
    _instance = null;
  }

  Future<void> log({
    required String level,
    required String action,
    required String details,
  }) async {
    await _firestore.collection("users").doc(uid).collection("logs").add({
      "timestamp": FieldValue.serverTimestamp(),
      "level": level,
      "action": action,
      "details": details,
    });
  }
}
