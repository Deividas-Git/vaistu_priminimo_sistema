import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/dialogs/cholesterol_dialog.dart';
import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';
import 'package:vaistu_priminimo_sistema/models/chart_data.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/active_ingredient.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_progress.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/widgets/adherence_bar.dart';
import 'package:vaistu_priminimo_sistema/widgets/consumption_progress_pie_chart.dart';
import 'package:vaistu_priminimo_sistema/widgets/dropdown_menu_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/root_app_bar.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

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

  void _onAddCholesterolInfo() async {
    final Map<String, dynamic> result = await showDialog(
      context: context,
      builder: (context) => CholesterolDialog(),
    );
    final HealthMetric healthMetric = HealthMetric(
      medicationId: _selectedMedication!.id!,
      healthMetricType: HealthMetricType.cholesterolMTL,
      value: result["value"],
      dateMeasured: DateHelper.normalizedDate(result["date"])!,
    );
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
    final ColorScheme colorScheme = ColorScheme.of(context);

    debugPrint("PROGRESS: $medicationProgress");

    return Scaffold(
      appBar: RootAppBar(title: "Vartojimo progresas"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _selectedMedication == null || medicationProgress == null
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
                child: Column(
                  children: [
                    _TopPart(
                      selectedMedication: _selectedMedication,
                      medications: medications,
                      onSelectedMedication: _onMedicationSelected,
                    ),
                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    SizedBox(height: 5),
                    if (_selectedMedication!.activeIngredient ==
                        ActiveIngredient.statin)
                      ElevatedButton(
                        onPressed: _onAddCholesterolInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                        ),
                        child: Text(
                          "Pridėti cholesterolio kiekį",
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                      ),
                    SizedBox(height: 5),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorScheme.of(context).onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(text: "Laikotarpis:\n"),
                          TextSpan(
                            text: DateHelper.getFormattedDate(
                              medicationProgress.startDate,
                            ),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " iki "),
                          TextSpan(
                            text: DateHelper.getFormattedDate(
                              medicationProgress.endDate.subtract(
                                Duration(days: 1),
                              ),
                            ),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ThemedContainerWidget(
                      doesHeightExpand: true,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Vidutiniškai nukrypstate nuo nustatytų tvarkaraščių vartojimo:",
                              ),
                              TextSpan(
                                text: DateHelper.getConsumptioDeviationTime(
                                  medicationProgress.deviation,
                                ),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    AdherenceBar(percentage: medicationProgress.adherenceRate),
                    SizedBox(height: 20),
                    ConsumptionProgressPieChart(
                      data: [
                        if (medicationProgress.timesTaken > 0)
                          ChartData(
                            label: "Suvartota",
                            value: medicationProgress.timesTaken,
                            color: MedicationRecordState.getColorForStateLabel(
                              colorScheme,
                              MedicationRecordState.taken,
                            ),
                          ),
                        if (medicationProgress.timesSkipped > 0)
                          ChartData(
                            label: "Praleista",
                            value: medicationProgress.timesSkipped,
                            color: MedicationRecordState.getColorForStateLabel(
                              colorScheme,
                              MedicationRecordState.skipped,
                            ),
                          ),
                        if (medicationProgress.timesMissed > 0)
                          ChartData(
                            label: "Nevartota",
                            value: medicationProgress.timesMissed,
                            color: MedicationRecordState.getColorForStateLabel(
                              colorScheme,
                              MedicationRecordState.missed,
                            ),
                          ),
                      ],
                    ),
                  ],
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
