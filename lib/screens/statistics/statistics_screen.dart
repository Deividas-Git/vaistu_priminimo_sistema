import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_progress.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/widgets/dropdown_menu_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/root_app_bar.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  UserMedication? _selectedMedication;

  void _onMedicationSelected(UserMedication? medication) {
    setState(() {
      _selectedMedication = medication;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MedicationProvider medicationProvider = context
        .watch<MedicationProvider>();
    final MedicationRecordsProvider medicationRecordsProvider = context
        .watch<MedicationRecordsProvider>();
    final List<UserMedication> medications = medicationProvider.uerMedications;
    final MedicationProgress? medicationProgress = medicationRecordsProvider
        .getMedicationProgress(_selectedMedication);

    debugPrint("PROGRESS: $medicationProgress");

    return Scaffold(
      appBar: RootAppBar(title: "Vartojimo progresas"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _selectedMedication == null
            ? Column(
                children: [
                  _TopPart(
                    selectedMedication: _selectedMedication,
                    medications: medications,
                    onSelectedMedication: _onMedicationSelected,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart,
                          size: 100,
                          color: ColorScheme.of(
                            context,
                          ).onSurfaceVariant.withValues(alpha: 0.9),
                        ),
                        Text(
                          "Nėra duomenų",
                          style: TextStyle(
                            fontSize: 20,
                            color: ColorScheme.of(context).onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: _TopPart(
                  selectedMedication: _selectedMedication,
                  medications: medications,
                  onSelectedMedication: _onMedicationSelected,
                ),
              ),
      ),
    );
  }
}

class _TopPart extends StatelessWidget {
  const _TopPart({
    required this.selectedMedication,
    required this.medications,
    required this.onSelectedMedication,
  });

  final UserMedication? selectedMedication;
  final List<UserMedication> medications;
  final Function(UserMedication?) onSelectedMedication;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTextWidget(label: "Pasirinkite vaistą peržiūrai"),
        DropdownMenuWidget(
          initialSelection: selectedMedication,
          entries: medications
              .map((med) => DropdownMenuEntry(value: med, label: med.name!))
              .toList(),
          onEntrySelected: onSelectedMedication,
        ),
      ],
    );
  }
}
