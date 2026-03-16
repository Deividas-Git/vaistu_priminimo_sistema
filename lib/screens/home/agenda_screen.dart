import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_group.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/services/agenda_service.dart';
import 'package:vaistu_priminimo_sistema/widgets/arrow_button.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key, required this.date});

  final DateTime date;

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  @override
  Widget build(BuildContext context) {
    final List<UserMedication> medications = context
        .watch<MedicationProvider>()
        .uerMedications;
    final AgendaService agendaService = AgendaService(
      date: widget.date,
      medications: medications,
    );

    final List<AgendaGroup> groupedAgenda = agendaService.getGroupedAgenda();

    return groupedAgenda.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  "Pasirinktai dienai neturite paskirtų vaistų",
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorScheme.of(context).onSurface,
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
                    .map((group) => _GroupedAgendaTile(group: group))
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

  void _onTakeMedication() {}

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
                    Row(
                      children: [
                        Text(
                          item.medicationType.getDoseLabel,
                          style: TextStyle(
                            fontSize: 18,
                            color: ColorScheme.of(context).onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          item.amountToTake.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorScheme.of(context).onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ArrowButton(onButtonPressed: _onTakeMedication),
            ],
          ),
        ),
      ),
    );
  }
}
