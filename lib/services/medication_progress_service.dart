import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_progress.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';

class MedicationProgressService {
  MedicationProgress getMedicationProgress({
    required List<MedicationRecord> records,
    required UserMedication medication,
  }) {
    final Map<String, MedicationRecord> recordsMap = {
      for (var record in records) record.id: record,
    };
    final DateTime progressStartDate = DateHelper.normalizedDate(
      medication.getConsumptionStartDate(),
    )!;
    final DateTime? consumptionEndDate = medication.getConsumptionEndDate();

    final DateTime progressEndDate =
        (consumptionEndDate != null &&
                consumptionEndDate.isAfter(DateTime.now()) ||
            consumptionEndDate == null)
        ? DateHelper.normalizedDate(DateTime.now())!
        : DateHelper.normalizedDate(consumptionEndDate)!;

    final int consumptionPeriodInDays = progressEndDate
        .difference(progressStartDate)
        .inDays
        .abs();

    final int timesTaken = records
        .where(
          (record) =>
              record.state == MedicationRecordState.taken &&
              record.scheduledDate.isBefore(progressEndDate),
        )
        .length;
    final int timesDelayed = records
        .where(
          (record) =>
              record.state == MedicationRecordState.delayed &&
              record.scheduledDate.isBefore(progressEndDate),
        )
        .length;
    final int timesSkipped = records
        .where(
          (record) =>
              record.state == MedicationRecordState.skipped &&
              record.scheduledDate.isBefore(progressEndDate),
        )
        .length;
    int timesMissed = records
        .where(
          (record) =>
              record.state == MedicationRecordState.missed &&
              record.scheduledDate.isBefore(progressEndDate),
        )
        .length;
    for (int i = 0; i < consumptionPeriodInDays; i++) {
      for (MedicationSchedule schedule in medication.medicationSchedules!) {
        final DateTime now = progressStartDate.add(Duration(days: i));
        if (!medication.isInculdedInSchedule(schedule, now)) {
          continue;
        }
        //debugPrint("DABAR ${now.day}");
        for (var time in schedule.consumptionTimesWithAmount!) {
          final String recordId = MedicationRecord.buildId(
            medicationId: medication.id!,
            timeId: time.id,
            date: now,
          );
          if (!recordsMap.containsKey(recordId)) {
            timesMissed += 1;
          }
        }
      }
    }

    final int totalRecords = timesSkipped + timesMissed + timesTaken;
    final double adherenceRate = totalRecords == 0
        ? 0
        : timesTaken / totalRecords * 100;

    int differencesCount = 0;
    int sum = 0;
    for (var record in records) {
      if (record.state != MedicationRecordState.taken) continue;
      final int difference = record.takenDate!
          .difference(record.scheduledDate)
          .inMinutes;
      differencesCount += 1;
      sum += difference;
    }
    final int deviation = differencesCount == 0 ? 0 : sum ~/ differencesCount;

    return MedicationProgress(
      startDate: progressStartDate,
      endDate: progressEndDate,
      timesTaken: timesTaken,
      timesDelayed: timesDelayed,
      timesSkipped: timesSkipped,
      timesMissed: timesMissed,
      adherenceRate: adherenceRate,
      deviation: deviation,
    );
  }
}
