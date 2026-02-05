import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/checkbox_with_label_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_date_picker_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/dropdown_menu_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/spinner_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

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
  final List<DropdownMenuEntry<MedicationFrequencyType>>
  _medicationFrequencyTypes = MedicationFrequencyType.values
      .map((type) => DropdownMenuEntry(value: type, label: type.getLabel))
      .toList();
  final List<String> _intervalDaysLabels = [
    "Kiekvieną dieną",
    "Kas antrą dieną",
    "Kas trečią dieną",
    "Kas ketvirtą dieną",
    "Kas penktą dieną",
    "Kas šeštą dieną",
    "Kas savaitę",
  ];
  DateTime? _startDate;
  DateTime? _endDate;
  MedicationFrequencyType? _medicationFrequencyType;
  int? _intervalDays;
  List<Weekday>? _weekdays;
  bool _hasEndDate = false;

  void _onStartDatePicked(DateTime? date) {
    setState(() {
      _startDate = date;
      if (_hasEndDate && _startDate!.isAfter(_endDate!)) {
        _endDate = _startDate?.add(Duration(days: 7));
      }
      debugPrint(
        "PRADZIA: ${_startDate.toString()} PABAIGA: ${_endDate.toString()}",
      );
    });
  }

  void _onEndDatePicked(DateTime? date) {
    setState(() {
      _endDate = date;
    });
  }

  void _onEndDateCheckboxChecked(bool? isChecked) {
    if (isChecked == null) return;
    setState(() {
      _hasEndDate = !_hasEndDate;
      _endDate = _hasEndDate ? _startDate?.add(Duration(days: 7)) : null;
    });
  }

  void _onMedicationFrequncyTypeSelected(
    MedicationFrequencyType? selectedMedicationType,
  ) {
    setState(() {
      _medicationFrequencyType = selectedMedicationType;
    });
  }

  void _onConstantIntervalSelected(int index) {
    int selectedIntervalDays = index + 1; //index nuo 0, bet skaiciuosim nuo 1
    _intervalDays = selectedIntervalDays;
  }

  void _onContinuePressed() {}

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SectionTextWidget(label: "Pasirinkite vartojimo dažnumą"),
                DropdownMenuWidget<MedicationFrequencyType>(
                  initialSelection: _medicationFrequencyType,
                  entries: _medicationFrequencyTypes,
                  onEntrySelected: _onMedicationFrequncyTypeSelected,
                ),
                const SizedBox(height: 10),
                if (_medicationFrequencyType ==
                    MedicationFrequencyType.constantIntervals)
                  ThemedContainerWidget(
                    height: 120,
                    child: SpinnerWidget(
                      items: _intervalDaysLabels,
                      onSelectedItemChanged: _onConstantIntervalSelected,
                    ),
                  ),
                Divider(thickness: 2),
                SectionTextWidget(label: "Pasirinkite vartojimo laikotarpį"),
                MedicationDatePickerWidget(
                  label: "Pradžios data",
                  selectedDate: _startDate,
                  onDatePicked: _onStartDatePicked,
                ),
                CheckboxWithLabelWidget(
                  label: "Turi vartojimo pabaigą",
                  isChecked: _hasEndDate,
                  onChanged: _onEndDateCheckboxChecked,
                ),
                if (_endDate != null)
                  MedicationDatePickerWidget(
                    label: "Pabaigos data",
                    selectedDate: _endDate,
                    onDatePicked: _onEndDatePicked,
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ContinueButton(
        label: "Toliau",
        onContinuePressed: _onContinuePressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
