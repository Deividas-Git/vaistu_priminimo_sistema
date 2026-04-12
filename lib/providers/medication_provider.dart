import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
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
    ) async {
      _userMedications = medications;
      notifyListeners();

      for (int i = 0; i < medications.length; i++) {
        final String? url = await _medicationService.getPhotoUrlFromDocument(
          medications[i].registrationNr,
        );
        //debugPrint("URL: $url");
        medications[i] = medications[i].copyWith(photoUrl: url);
      }
      notifyListeners();
    });
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _userMedications = [];
  }

  void updateLastTimeTaken(List<MedicationRecord> records) {
    final Map<String, DateTime> lastTakenTimeForMedications = {};

    for (MedicationRecord record in records) {
      if (record.takenDate == null) continue;
      final String medId = record.medicationId;
      if (!lastTakenTimeForMedications.containsKey(medId) ||
          record.takenDate!.isAfter(lastTakenTimeForMedications[medId]!)) {
        lastTakenTimeForMedications[medId] = record.takenDate!;
      }
    }

    for (int i = 0; i < _userMedications.length; i++) {
      final UserMedication medication = _userMedications[i];
      _userMedications[i] = medication.copyWith(
        lastTimeTaken: lastTakenTimeForMedications[medication.id],
      );
    }
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

  Future<UserMedication?> getMedicationFromRegistrationCode(
    String registrationNr,
  ) async {
    return await _medicationService.getMedicationFromRegistrationCode(
      registrationNr,
    );
  }

  // Future<String?> getMedicationPhoto(String? registrationNr) async {
  //   return await _medicationService.getMedicationPhoto(registrationNr);
  // }
}
