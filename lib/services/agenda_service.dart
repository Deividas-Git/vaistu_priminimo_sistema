import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_group.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';

class AgendaService {
  late final DateTime agendaDate;
  final List<UserMedication> medications;

  AgendaService({required DateTime date, required this.medications}) {
    agendaDate = _normalizedDate(date)!;
  }

  DateTime? _normalizedDate(DateTime? date) {
    if (date == null) return null;
    return DateTime(date.year, date.month, date.day);
  }

  bool _isMedicationInculded(MedicationSchedule schedule) {
    final DateTime startDate = _normalizedDate(schedule.startDate)!;
    final DateTime? endDate = _normalizedDate(schedule.endDate);

    //debugPrint("AGENDA DATE: $agendaDate, START DATE: $startDate");
    // debugPrint(
    //   "PRASIDEJO TA PACIA DIENA: ${startDate == agendaDate}, ${schedule.name}",
    // );
    if (endDate != null && endDate.isBefore(agendaDate)) return false;
    if (startDate.isBefore(agendaDate) || startDate == agendaDate) {
      //debugPrint("PRAEJO ${schedule.name}");
      if (schedule.medicationFrequencyType ==
              MedicationFrequencyType.selectedDays &&
          schedule.weekdays!.contains(
            Weekday.getWeekdayFromNumber(agendaDate.weekday),
          )) {
        return true;
      } else if (schedule.medicationFrequencyType ==
              MedicationFrequencyType.constantIntervals &&
          agendaDate.difference(startDate).inDays % schedule.intervalsDays! ==
              0) {
        return true;
      }
    }
    return false;
  }

  List<AgendaItem> _getAgenda() {
    List<AgendaItem> agenda = [];
    for (final UserMedication medication in medications) {
      if (medication.medicationSchedules == null) continue;
      for (final MedicationSchedule schedule
          in medication.medicationSchedules!) {
        if (!_isMedicationInculded(schedule)) {
          //debugPrint("NEPRAEJO ${medication.name}");
          continue;
        }
        for (MedicationConsumptionTimeWithAmount timeWithAmount
            in schedule.consumptionTimesWithAmount!) {
          final AgendaItem item = AgendaItem(
            medicationId: medication.id!,
            medicationName: medication.name!,
            amountToTake: timeWithAmount.consumptionAmount,
            medicationMealTiming: medication.medicationMealTiming!,
            medicationType: medication.medicationType!,
            time: timeWithAmount.time,
          );

          agenda.add(item);
        }
      }
    }

    agenda.sort((a, b) => a.time.compareTo(b.time));
    return agenda;
  }

  List<AgendaGroup> getGroupedAgenda() {
    final List<AgendaItem> agenda = _getAgenda();
    final Map<TimeOfDay, List<AgendaItem>> agendaGroups = {};
    for (AgendaItem item in agenda) {
      if (agendaGroups[item.time] == null) {
        agendaGroups[item.time] = [item];
      } else {
        agendaGroups[item.time]!.add(item);
      }
    }
    return agendaGroups.entries
        .map((group) => AgendaGroup(time: group.key, items: group.value))
        .toList();
  }
}
