import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_group.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/services/agenda_service.dart';
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
    //debugPrint("DIENOTVARKĖS ${agenda.length}");

    return SingleChildScrollView(
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
        Text("${group.time}", style: TextStyle(fontSize: 20)),
        ThemedContainerWidget(child: Text("${group.time}")),
      ],
    );
  }
}
