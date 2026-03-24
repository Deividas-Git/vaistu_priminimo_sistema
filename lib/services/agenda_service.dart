import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_group.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';

class AgendaService {
  late final DateTime agendaDate;
  final List<UserMedication> medications;
  final Map<String, MedicationRecord> recordsMap;

  AgendaService({
    required DateTime date,
    required this.medications,
    required this.recordsMap,
  }) {
    agendaDate = _normalizedDate(date)!;
  }

  DateTime? _normalizedDate(DateTime? date) {
    if (date == null) return null;
    return DateTime(date.year, date.month, date.day);
  }

  bool _isMedicationInculded(MedicationSchedule schedule, DateTime date) {
    final DateTime startDate = _normalizedDate(schedule.startDate)!;
    final DateTime? endDate = _normalizedDate(schedule.endDate);

    if (endDate != null && endDate.isBefore(date)) return false;
    if (startDate.isBefore(date) || startDate == date) {
      if (schedule.medicationFrequencyType ==
              MedicationFrequencyType.selectedDays &&
          schedule.weekdays!.contains(
            Weekday.getWeekdayFromNumber(date.weekday),
          )) {
        return true;
      } else if (schedule.medicationFrequencyType ==
              MedicationFrequencyType.constantIntervals &&
          date.difference(startDate).inDays % schedule.intervalsDays! == 0) {
        return true;
      }
    }
    return false;
  }

  DateTime? _getUpcomingIntakeForSchedule(
    MedicationSchedule schedule,
    DateTime now,
  ) {
    for (int i = 0; i <= 7; i++) {
      final DateTime checkedDate = now.add(Duration(days: i));
      if (!_isMedicationInculded(schedule, checkedDate)) continue;
      schedule.consumptionTimesWithAmount!.sort(
        (a, b) => checkedDate
            .add(Duration(hours: a.time.hour, minutes: a.time.minute))
            .compareTo(
              checkedDate.add(
                Duration(hours: b.time.hour, minutes: b.time.minute),
              ),
            ),
      );
      for (var timeWithAmount in schedule.consumptionTimesWithAmount!) {
        final DateTime nearestNextTime = DateTime(
          checkedDate.year,
          checkedDate.month,
          checkedDate.day,
          timeWithAmount.time.hour,
          timeWithAmount.time.minute,
        );
        if (nearestNextTime.isAfter(now)) {
          return nearestNextTime;
        }
      }
    }
    return null;
  }

  DateTime? _getUpcomingIntakeForMedication(
    UserMedication medication,
    DateTime from,
  ) {
    if (medication.medicationSchedules == null) return null;
    final List<DateTime> nearestTimesFromEachSchedule = [];
    for (var schedule in medication.medicationSchedules!) {
      final DateTime? possibleNearestTime = _getUpcomingIntakeForSchedule(
        schedule,
        from,
      );
      if (possibleNearestTime != null) {
        nearestTimesFromEachSchedule.add(possibleNearestTime);
      }
    }
    if (nearestTimesFromEachSchedule.isEmpty) return null;
    nearestTimesFromEachSchedule.sort((a, b) => a.compareTo(b));
    return nearestTimesFromEachSchedule.first;
  }

  Map<String, DateTime?> _getUpcomingIntakesForMedicationsMap() {
    final Map<String, DateTime?> upcomingIntakesForMedication = {};
    for (UserMedication medication in medications) {
      upcomingIntakesForMedication[medication.id!] =
          _getUpcomingIntakeForMedication(medication, DateTime.now());
    }
    return upcomingIntakesForMedication;
  }

  List<AgendaItem> _getAgenda() {
    final Map<String, DateTime?> upcomingIntakesForMedication =
        _getUpcomingIntakesForMedicationsMap();
    final List<AgendaItem> agenda = [];
    for (final UserMedication medication in medications) {
      if (medication.medicationSchedules == null) continue;
      for (final MedicationSchedule schedule
          in medication.medicationSchedules!) {
        if (!_isMedicationInculded(schedule, agendaDate)) {
          continue;
        }
        for (MedicationConsumptionTimeWithAmount timeWithAmount
            in schedule.consumptionTimesWithAmount!) {
          final String recordId = MedicationRecord.buildId(
            medicationId: medication.id!,
            timeId: timeWithAmount.id,
            date: agendaDate,
          );
          final MedicationRecordState? state = recordsMap[recordId]?.state;
          final AgendaItem item = AgendaItem(
            medicationId: medication.id!,
            medicationName: medication.name!,
            amountToTake: timeWithAmount.consumptionAmount,
            medicationMealTiming: medication.medicationMealTiming!,
            medicationType: medication.medicationType!,
            scheduledDate: agendaDate.add(
              Duration(
                hours: timeWithAmount.time.hour,
                minutes: timeWithAmount.time.minute,
              ),
            ),
            scheduleName: schedule.name!,
            medicationRecordId: recordId,
            lastTimeTaken: medication.lastTimeTaken,
            state:
                state ??
                (agendaDate
                        .add(
                          Duration(
                            hours: timeWithAmount.time.hour,
                            minutes: timeWithAmount.time.minute,
                          ),
                        )
                        .isBefore(DateTime.now())
                    ? MedicationRecordState.missed
                    : MedicationRecordState.pending),
            upcomingIntakeAt: upcomingIntakesForMedication[medication.id],
            delayedUntil: recordsMap[recordId]?.delaydUntil,
          );

          agenda.add(item);
        }
      }
    }

    agenda.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    return agenda;
  }

  List<AgendaGroup> getGroupedAgenda() {
    final List<AgendaItem> agenda = _getAgenda();
    final Map<DateTime, List<AgendaItem>> agendaGroups = {};
    for (AgendaItem item in agenda) {
      if (agendaGroups[item.scheduledDate] == null) {
        agendaGroups[item.scheduledDate] = [item];
      } else {
        agendaGroups[item.scheduledDate]!.add(item);
      }
    }
    return agendaGroups.entries
        .map(
          (group) => AgendaGroup(
            time: TimeOfDay(hour: group.key.hour, minute: group.key.minute),
            items: group.value,
          ),
        )
        .toList();
  }
}
