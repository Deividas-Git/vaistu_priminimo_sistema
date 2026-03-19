import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/services/notification_service.dart';

class NotificationManager {
  final NotificationService _notificationService = NotificationService();
  final MedicationProvider _medicationProvider;
  final MedicationRecordsProvider _medicationRecordsProvider;

  NotificationManager(
    this._medicationProvider,
    this._medicationRecordsProvider,
  ) {
    _medicationProvider.addListener(_scheduleMedications);
    _medicationRecordsProvider.addListener(_scheduleMedications);
    _scheduleMedications();
  }

  void _scheduleMedications() {
    final List<UserMedication> medications = _medicationProvider.uerMedications;
    final List<MedicationRecord> records =
        _medicationRecordsProvider.medicationRecords;
    final Map<String, MedicationRecord> recordsMap = {
      for (var r in records) r.id: r,
    };
    _notificationService.scheduleAllMedications(
      medications: medications,
      recordsMap: recordsMap,
    );
  }

  void dispose() {
    _medicationProvider.removeListener(_scheduleMedications);
    _medicationRecordsProvider.removeListener(_scheduleMedications);
  }
}
