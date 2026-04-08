import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication_schedules/add_consumption_times_with_amount_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/checkbox_with_label_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_date_picker_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/selection_tile_button_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/dropdown_menu_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/spinner_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class AddConsumptionFrequencyScreen extends StatefulWidget {
  const AddConsumptionFrequencyScreen({
    super.key,
    this.prefilledMedicationSchedule,
    required this.medicationType,
    required this.onScheduleAdded,
  });
  final MedicationSchedule? prefilledMedicationSchedule;
  final MedicationType medicationType;
  final Function(MedicationSchedule) onScheduleAdded;

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
  final TextEditingController _scheduleNameController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  MedicationFrequencyType? _medicationFrequencyType;
  int? _intervalDays;
  List<Weekday>? _selectedWeekdays;
  bool _hasEndDate = false;

  void _onStartDatePicked(DateTime? date) {
    if (date == null) return;
    setState(() {
      _startDate = date;
      if (_hasEndDate && _startDate!.isAfter(_endDate!)) {
        _endDate =
            _startDate; //nebent galima prideti papildomus pasirinkimus +7 days, +1 month
      }
      debugPrint(
        "PRADZIA: ${_startDate.toString()} PABAIGA: ${_endDate.toString()}",
      );
    });
  }

  void _onEndDatePicked(DateTime? date) {
    if (date == null || _startDate == null) return;
    setState(() {
      if (date.isBefore(_startDate!)) {
        _endDate = _startDate;
        //TODO snackbar pranesimas kad pabaigos data negali but anksciau uz pradzia
      } else {
        _endDate = date;
      }
    });
  }

  void _onEndDateCheckboxChecked(bool? isChecked) {
    if (isChecked == null) return;
    setState(() {
      _hasEndDate = !_hasEndDate;
      _endDate = _hasEndDate ? _startDate : null;
    });
  }

  void _onMedicationFrequncyTypeSelected(
    MedicationFrequencyType? selectedMedicationType,
  ) {
    setState(() {
      _medicationFrequencyType = selectedMedicationType;
      if (_medicationFrequencyType ==
          MedicationFrequencyType.constantIntervals) {
        _intervalDays = 1;
        _selectedWeekdays = null;
      } else {
        _selectedWeekdays = [Weekday.monday];
        _intervalDays = null;
      }
    });
  }

  void _onConstantIntervalSelected(int index) {
    int selectedIntervalDays = index + 1; //index nuo 0, bet skaiciuosim nuo 1
    _intervalDays = selectedIntervalDays;
  }

  void _onWeekdayTileSelected(Weekday weekday) {
    if (_selectedWeekdays == null) return;
    setState(() {
      !_selectedWeekdays!.contains(weekday)
          ? _selectedWeekdays!.add(weekday)
          : _selectedWeekdays!.remove(weekday);
    });
  }

  void _onContinuePressed() {
    //TODO patikrinti ar jei pasirinktomis dienomis daznumas kad ar parinkta bent viena diena

    MedicationSchedule medicationSchedule =
        MedicationSchedule(
          startDate: _startDate!,
          endDate: _endDate,
          medicationFrequencyType: _medicationFrequencyType!,
          intervalsDays: _intervalDays,
          weekdays: _selectedWeekdays,
          name: _scheduleNameController.text.isEmpty
              ? ""
              : _scheduleNameController.text,
        ).copyWith(
          consumptionTimesWithAmount:
              widget.prefilledMedicationSchedule?.consumptionTimesWithAmount,
        );
    debugPrint("TVARKARASTIS: ${medicationSchedule.toString()}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddConsumptionTimesWithAmountScreen(
          medicationType: widget.medicationType,
          prefilledMedicationSchedule: medicationSchedule,
          onScheduleAdded: widget.onScheduleAdded,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startDate =
        widget.prefilledMedicationSchedule?.startDate ?? DateTime.now();
    _endDate = widget.prefilledMedicationSchedule?.endDate;
    _medicationFrequencyType =
        widget.prefilledMedicationSchedule?.medicationFrequencyType ??
        MedicationFrequencyType.constantIntervals;
    _intervalDays = widget.prefilledMedicationSchedule?.intervalsDays ?? 1;
    _selectedWeekdays = widget.prefilledMedicationSchedule?.weekdays != null
        ? List.from(widget.prefilledMedicationSchedule!.weekdays!)
        : null;
    _scheduleNameController.text =
        widget.prefilledMedicationSchedule?.name?.trim() ?? "";
    // debugPrint(
    //   "TVARKARASTIS: ${widget.prefilledMedicationSchedule.toString()}",
    // );
    _hasEndDate = _endDate == null ? false : true;
  }

  @override
  void dispose() {
    _scheduleNameController.dispose();
    super.dispose();
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
                const SizedBox(height: 10),
                TextField(
                  controller: _scheduleNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Tvarkaraščio pavadinimas",
                    hintText: "Įveskite tvarkaraščio pavadinimą",
                  ),
                ),
                const SizedBox(height: 10),
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
                      items: MedicationFrequencyType.intervalDaysLabels,
                      onSelectedItemChanged: _onConstantIntervalSelected,
                    ),
                  ),
                if (_medicationFrequencyType ==
                    MedicationFrequencyType.selectedDays)
                  ThemedContainerWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        MedicationFrequencyType.weekdays.length,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: SelectionTileButtonWidget<Weekday>(
                              isSelected: _selectedWeekdays!.contains(
                                MedicationFrequencyType.weekdays[index],
                              ),
                              label: MedicationFrequencyType
                                  .weekdays[index]
                                  .getLabel,
                              value: MedicationFrequencyType.weekdays[index],
                              onTap: () => _onWeekdayTileSelected(
                                MedicationFrequencyType.weekdays[index],
                              ),
                            ),
                          ),
                        ),
                      ),
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
                if (_hasEndDate)
                  MedicationDatePickerWidget(
                    label: "Pabaigos data",
                    selectedDate: _endDate,
                    onDatePicked: _onEndDatePicked,
                  ),
                SizedBox(height: 100),
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
