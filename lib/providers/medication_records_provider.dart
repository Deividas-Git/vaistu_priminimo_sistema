import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/services/medication_record_service.dart';

class MedicationRecordsProvider extends ChangeNotifier {
  final MedicationRecordService _medicationRecordService;
  StreamSubscription? _streamSubscription;
  List<MedicationRecord> _medicationRecords = [];
  List<MedicationRecord> get medicationRecords => _medicationRecords;

  MedicationRecordsProvider(this._medicationRecordService);

  void startListening(String uid) {
    _streamSubscription?.cancel();
    _streamSubscription = _medicationRecordService
        .medicationRecordsStream(uid)
        .listen((medicationRecords) {
          _medicationRecords = medicationRecords;
          notifyListeners();
        });
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _medicationRecords = [];
  }

  Map<String, MedicationRecord> getRecordsMap() {
    return {for (var record in medicationRecords) record.id: record};
  }

  Future<void> saveMedicationRecord(String uid, MedicationRecord record) async {
    //final recordsMap = getRecordsMap();
    await _medicationRecordService.saveRecord(uid, record);
  }

  Future<void> removeMedicationRecord(
    String uid,
    MedicationRecord record,
  ) async {
    await _medicationRecordService.removeRecord(uid, record);
  }
}
