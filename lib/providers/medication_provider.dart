import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/medication_service.dart';
import 'package:vaistu_priminimo_sistema/services/notification_service.dart';

class MedicationProvider extends ChangeNotifier {
  final MedicationService _medicationService;
  final _notificationService = NotificationService();
  StreamSubscription? _streamSubscription;
  List<UserMedication> _userMedications = [];
  List<UserMedication> get uerMedications => _userMedications;

  MedicationProvider(this._medicationService);

  void startListening(String uid) {
    _streamSubscription?.cancel();
    _streamSubscription = _medicationService.medicationsStream(uid).listen((
      medications,
    ) async {
      _userMedications = medications;
      debugPrint("VAISTAI: $medications");
      notifyListeners();

      await _notificationService.scheduleAllMedications(
        medications: medications,
      );
    });
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _userMedications = [];
  }

  Future<void> addMedication(UserMedication medication, String uid) async {
    await _medicationService.addMedication(medication, uid);
  }

  Future<void> updateMedication(UserMedication medication, String uid) async {
    await _medicationService.updateMedication(medication, uid);
  }

  Future<void> removeMedication(String medicationid, String uid) async {
    await _medicationService.removeMedication(medicationid, uid);
  }
}
