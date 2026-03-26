import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
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

  MedicationRecord _checkRecordIfWasDelayedAndExpired(MedicationRecord record) {
    if (record.state == MedicationRecordState.delayed &&
        record.delaydUntil!.isBefore(DateTime.now())) {
      final MedicationRecord updatedRecord = MedicationRecord(
        id: record.id,
        medicationId: record.medicationId,
        scheduledDate: record.scheduledDate,
        takenDate: null,
        delaydUntil: record.delaydUntil,
        state: MedicationRecordState.missed,
      );
      return updatedRecord;
    }
    return record;
  }

  Future<void> updateExpiredDelayedRecords(String uid) async {
    for (MedicationRecord record in _medicationRecords) {
      await _medicationRecordService.saveRecord(
        uid,
        _checkRecordIfWasDelayedAndExpired(record),
      );
    }
  }

  Future<void> saveMedicationRecord(String uid, MedicationRecord record) async {
    await _medicationRecordService.saveRecord(
      uid,
      _checkRecordIfWasDelayedAndExpired(record),
    );
  }

  Future<void> removeMedicationRecord(
    String uid,
    MedicationRecord record,
  ) async {
    await _medicationRecordService.removeRecord(uid, record);
  }

  Future<void> removeAllRecordsForMedication(
    String uid,
    String medicationId,
  ) async {
    final allMedicationRecords = _medicationRecords.where(
      (record) => record.medicationId == medicationId,
    );
    for (MedicationRecord record in allMedicationRecords) {
      await removeMedicationRecord(uid, record);
    }
  }
}
