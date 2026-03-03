import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/medication_service.dart';

class MedicationProvider extends ChangeNotifier {
  final MedicationService _medicationService;
  StreamSubscription? _streamSubscription;
  List<UserMedication> _userMedications = [];
  List<UserMedication> get uerMedications => _userMedications;

  MedicationProvider(this._medicationService);

  void startListening(String uid) {
    _streamSubscription?.cancel();
    _streamSubscription = _medicationService.medicationsStream(uid).listen((
      medications,
    ) {
      _userMedications = medications;
      debugPrint("VAISTAI: $medications");
      notifyListeners();
    });
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _userMedications = [];
  }

  void addMedication(UserMedication medication, String uid) {
    _medicationService.addMedication(medication, uid);
  }
}
