import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_date_picker_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';

class AddConsumptionFrequencyScreen extends StatefulWidget {
  const AddConsumptionFrequencyScreen({
    super.key,
    this.prefilledMedicationSchedule,
  });
  final MedicationSchedule? prefilledMedicationSchedule;

  @override
  State<AddConsumptionFrequencyScreen> createState() =>
      _AddConsumptionFrequencyScreenState();
}

class _AddConsumptionFrequencyScreenState
    extends State<AddConsumptionFrequencyScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  MedicationFrequencyType? _medicationFrequencyType;
  int? _intervalDays;
  List<Weekday>? _weekdays;

  void _onStartDatePicked(DateTime? date) {}

  @override
  void initState() {
    super.initState();
    _startDate =
        widget.prefilledMedicationSchedule?.startDate ?? DateTime.now();
    _endDate = widget.prefilledMedicationSchedule?.endDate;
    _medicationFrequencyType =
        widget.prefilledMedicationSchedule?.medicationFrequencyType ??
        MedicationFrequencyType.constantIntervals;
    _intervalDays = widget.prefilledMedicationSchedule?.intervalsDays;
    _weekdays = widget
        .prefilledMedicationSchedule
        ?.weekdays; //cia tik read only, jei reiks editint - klonuok
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddMedicationAppBar(title: "Vartojimo dažnumas"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                SectionTextWidget(label: "Pasirinkite vartojimo dažnumą"),
                SectionTextWidget(label: "Pasirinkite vartojimo laikotarpį"),
                MedicationDatePickerWidget(
                  label: "Pradžios data",
                  onDatePicked: _onStartDatePicked,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
