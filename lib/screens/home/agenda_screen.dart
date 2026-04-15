import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/dialogs/medication_state_dialog.dart';
import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_group.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_state_action_result.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
//import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/services/agenda_service.dart';
import 'package:vaistu_priminimo_sistema/widgets/arrow_button.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({
    super.key,
    required this.date,
    required this.medications,
    required this.medicationRecords,
  });

  final DateTime date;
  final List<UserMedication> medications;
  final Map<String, MedicationRecord> medicationRecords;

  @override
  Widget build(BuildContext context) {
    final AgendaService agendaService = AgendaService(
      date: date,
      medications: medications,
      recordsMap: medicationRecords,
    );

    final List<AgendaGroup> groupedAgenda = agendaService
        .getGroupedAgendaForUI();

    return groupedAgenda.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available,
                  size: 80,
                  color: ColorScheme.of(
                    context,
                  ).onSurfaceVariant.withValues(alpha: 0.9),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Paskirtų vaistų nėra",
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorScheme.of(context).onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: groupedAgenda
                    .map(
                      (group) => Provider(
                        create: (_) => agendaService,
                        child: _GroupedAgendaTile(group: group),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }
}

class _GroupedAgendaTile extends StatelessWidget {
  const _GroupedAgendaTile({required this.group});

  final AgendaGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "${group.time.hour.toString().padLeft(2, "0")}:${group.time.minute.toString().padLeft(2, "0")}",
            style: TextStyle(
              fontSize: 30,
              color: ColorScheme.of(context).onSurface,
            ),
          ),
        ),
        SizedBox(height: 5),
        ThemedContainerWidget(
          doesHeightExpand: true,
          child: Column(
            children: group.items
                .map((item) => _AgendaTile(item: item))
                .toList(),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class _AgendaTile extends StatelessWidget {
  const _AgendaTile({required this.item});

  final AgendaItem item;

  void _onTakeMedication(BuildContext context) async {
    final agendaService = context.read<AgendaService>();
    final MedicationStateActionResult? result = await showDialog(
      context: context,
      builder: (context) => MedicationStateDialog(
        photoUrl: item.photoUrl,
        agendaItem: item,
        upcomingMedicationIntakeAt: agendaService
            .getUpcomingIntakeForMedication(
              agendaService.getMedicationFromId(item.medicationId),
              DateTime.now(),
            ),
        nextIntakeAt: agendaService.getNextIntakeAfterDate(item),
      ),
    );

    if (result != null) {
      final MedicationRecord record = MedicationRecord(
        id: item.medicationRecordId,
        medicationId: item.medicationId,
        scheduledDate: item.scheduledDate,
        takenDate: result.takenAt,
        delayedUntil: result.delayedUntil,
        state: result.state,
      );
      if (!context.mounted) return;
      final String uid = context.read<UserProvider>().appUser!.uid;
      context.read<MedicationRecordsProvider>().saveMedicationRecord(
        uid,
        record,
      );

      // final UserMedication medication = context
      //     .read<MedicationProvider>()
      //     .getMedicationFromId(item.medicationId);
      // final double amountChange =
      //     medication.medicationType!.getQuantitySubtract * item.amountToTake;
      // final oldRecord = context
      //     .read<MedicationRecordsProvider>()
      //     .getRecordsMap()[item.medicationRecordId];

      // final wasTaken = oldRecord?.state == MedicationRecordState.taken;
      // final isTaken = result.state == MedicationRecordState.taken;

      // if (oldRecord == null) return;
      // if (oldRecord.state == result.state) return;
      // if (medication.currentQuantity == null) return;

      // if (isTaken && !wasTaken) {
      //   context.read<MedicationProvider>().updateMedication(
      //     medication.copyWith(
      //       currentQuantity: medication.currentQuantity! - amountChange,
      //     ),
      //     uid,
      //   );
      // } else if (!isTaken && wasTaken) {
      //   context.read<MedicationProvider>().updateMedication(
      //     medication.copyWith(
      //       currentQuantity: medication.currentQuantity! + amountChange,
      //     ),
      //     uid,
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "[${item.scheduleName}]",
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorScheme.of(context).onSurface,
                      ),
                    ),
                    Divider(thickness: 2),
                    Text(
                      item.medicationName,
                      style: TextStyle(
                        fontSize: 24,
                        color: ColorScheme.of(context).onSurface,
                      ),
                    ),
                    if (item.medicationMealTiming !=
                        MedicationMealTiming.unspecified)
                      Text(
                        "${item.medicationMealTiming.getLabel},",
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorScheme.of(context).onSurfaceVariant,
                        ),
                      ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorScheme.of(context).onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(text: item.medicationType.getDoseLabel),
                          TextSpan(
                            text: " ${item.amountToTake.toString()}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorScheme.of(context).onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: MedicationRecordState.getColorForStateLabel(
                          ColorScheme.of(context),
                          item.state,
                        ).withValues(alpha: 0.125),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  MedicationRecordState.getColorForStateLabel(
                                    ColorScheme.of(context),
                                    item.state,
                                  ),
                            ),
                            children: [
                              TextSpan(
                                text: item.delayedUntil == null
                                    ? item.state.getLabel
                                    : "${item.state.getLabel} ",
                              ),
                              if (item.delayedUntil != null)
                                TextSpan(
                                  text:
                                      "(${DateHelper.getFormattedTime(item.delayedUntil!)})",
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ArrowButton(onButtonPressed: () => _onTakeMedication(context)),
            ],
          ),
        ),
      ),
    );
  }
}
