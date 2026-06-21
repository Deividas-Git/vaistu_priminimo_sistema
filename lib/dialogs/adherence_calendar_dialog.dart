import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/day_adherence_status.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/agenda_service.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: TableCalendar(
              locale: "lt_LT",
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 14),
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: const {CalendarFormat.month: "Month"},
              calendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(isTodayHighlighted: false),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: 10),
                weekendStyle: TextStyle(fontSize: 10),
              ),
              focusedDay: now,
              firstDay: now.subtract(Duration(days: 365 * 5)),
              lastDay: now.add(Duration(days: 365 * 5)),
              onDaySelected: (selectedDay, focusedDay) =>
                  Navigator.pop(context, selectedDay),

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final AgendaService agendaService = AgendaService(
                    date: day,
                    medications: medications,
                    recordsMap: recordsMap,
                  );
                  final DayAdherenceStatus status =
                      DayAdherenceStatus.getStatus(items: agendaService.agenda);
                  return Padding(
                    padding: EdgeInsets.all(
                      DateHelper.normalizedDate(day) == now ? 3 : 7,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            status != DayAdherenceStatus.empty ||
                                status == DayAdherenceStatus.empty &&
                                    DateHelper.normalizedDate(day) == now
                            ? status.getColorForStateLabel.withValues(
                                alpha: DateHelper.normalizedDate(day) == now
                                    ? 0.75
                                    : 0.55,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          day.day.toString(),
                          style:
                              status != DayAdherenceStatus.empty ||
                                  status == DayAdherenceStatus.empty &&
                                      DateHelper.normalizedDate(day) == now
                              ? TextStyle(
                                  fontSize:
                                      DateHelper.normalizedDate(day) == now
                                      ? 16
                                      : 12,
                                  color: Colors.white,
                                  fontWeight:
                                      DateHelper.normalizedDate(day) == now
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
          ThemedContainerWidget(
            doesHeightExpand: true,
            child: Column(
              children: [
                ...DayAdherenceStatus.values.map(
                  (status) => _DayAdherenceStatusLegend(status: status),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayAdherenceStatusLegend extends StatelessWidget {
  const _DayAdherenceStatusLegend({required this.status});

  final DayAdherenceStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      //textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          status.getLabel,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 14,
            color: ColorScheme.of(context).onSurfaceVariant,
            fontWeight: FontWeight.normal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Container(
            height: 15,
            width: 15,
            color: status.getColorForStateLabel.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
