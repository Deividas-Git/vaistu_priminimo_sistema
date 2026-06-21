import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/day_adherence_status.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/agenda_service.dart';

class AdherenceCalendarDialog extends StatelessWidget {
  const AdherenceCalendarDialog({
    super.key,
    required this.now,
    required this.medications,
    required this.recordsMap,
  });
  final DateTime now;
  final List<UserMedication> medications;
  final Map<String, MedicationRecord> recordsMap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Vartojimo kalendorius", textAlign: TextAlign.center),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        child: TableCalendar(
          locale: "lt_LT",
          headerStyle: HeaderStyle(titleCentered: true),
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableCalendarFormats: const {CalendarFormat.month: "Month"},
          calendarFormat: CalendarFormat.month,
          calendarStyle: CalendarStyle(isTodayHighlighted: false),
          focusedDay: now,
          firstDay: now.subtract(Duration(days: 365 * 5)),
          lastDay: now.add(Duration(days: 365 * 5)),

          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final AgendaService agendaService = AgendaService(
                date: day,
                medications: medications,
                recordsMap: recordsMap,
              );
              final DayAdherenceStatus status = DayAdherenceStatus.getStatus(
                items: agendaService.agenda,
              );
              return Padding(
                padding: EdgeInsets.all(day == focusedDay ? 3 : 7),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status != DayAdherenceStatus.empty
                        ? status.getColorForStateLabel.withValues(
                            alpha: day == focusedDay ? 0.75 : 0.55,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: status != DayAdherenceStatus.empty
                          ? TextStyle(
                              fontSize: day == focusedDay ? 16 : 14,
                              color: Colors.white,
                              fontWeight: day == focusedDay
                                  ? FontWeight.bold
                                  : null,
                            )
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
