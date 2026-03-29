import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_state_action_result.dart';
import 'package:vaistu_priminimo_sistema/widgets/amount_button.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/time_spinner_widget.dart';

class MedicationStateDialog extends StatefulWidget {
  const MedicationStateDialog({
    super.key,
    required this.agendaItem,
    required this.upcomingMedicationIntakeAt,
    required this.nextIntakeAt,
  });

  final AgendaItem agendaItem;
  final DateTime? upcomingMedicationIntakeAt;
  final DateTime? nextIntakeAt;

  @override
  State<MedicationStateDialog> createState() => _MedicationStateDialogState();
}

class _MedicationStateDialogState extends State<MedicationStateDialog> {
  bool _isTakingMedication = false;

  void _onSkipMedication() {
    final MedicationStateActionResult result = MedicationStateActionResult(
      state: MedicationRecordState.skipped,
    );
    Navigator.pop(context, result);
  }

  void _onTakeMedication() {
    setState(() {
      _isTakingMedication = true;
    });
  }

  void _onDelayMedication() async {
    DateTime? delayedUntil = await showDialog(
      context: context,
      builder: (context) => _TimeDelayDialog(
        agendaItem: widget.agendaItem,
        nextIntakeAt: widget.nextIntakeAt,
      ),
    );
    if (!mounted) return;
    if (delayedUntil == null) {
      setState(() {
        _isTakingMedication = false;
      });
      return;
    }
    final MedicationStateActionResult result = MedicationStateActionResult(
      state: MedicationRecordState.delayed,
      delayedUntil: delayedUntil,
    );
    Navigator.pop(context, result);
  }

  void _onMedicationTakenOnTime() {
    final MedicationStateActionResult result = MedicationStateActionResult(
      state: MedicationRecordState.taken,
      takenAt: widget.agendaItem.scheduledDate,
    );
    Navigator.pop(context, result);
  }

  void _onMedicationTakenOnCustomTime() async {
    TimeOfDay? selectedTime = await showDialog(
      context: context,
      builder: (context) => _TimeSelectionDialog(),
    );
    if (!mounted || selectedTime == null) return;
    final MedicationStateActionResult result = MedicationStateActionResult(
      state: MedicationRecordState.taken,
      takenAt: DateTime(
        widget.agendaItem.scheduledDate.year,
        widget.agendaItem.scheduledDate.month,
        widget.agendaItem.scheduledDate.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return AlertDialog(
      title: Center(child: Text(widget.agendaItem.medicationName)),
      content: SizedBox(
        height: _isTakingMedication ? 270 : 210,
        child: Column(
          children: [
            Divider(thickness: 2),
            _MedicationDateTimeWidget(
              date: widget.agendaItem.lastTimeTaken,
              label: "Paskutinį kartą vartota\n",
              alternativeLabel: "Anksčiau vartota nebuvo",
            ),
            SizedBox(height: 10),
            ThemedContainerWidget(
              doesHeightExpand: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StateButton(
                    label: "Praleisti",
                    icon: Icons.cancel_outlined,
                    color: Colors.redAccent,
                    onButtonPressed: _onSkipMedication,
                  ),
                  _StateButton(
                    label: "Suvartoti",
                    icon: Icons.check_circle,
                    color: Colors.green,
                    onButtonPressed: _onTakeMedication,
                  ),
                  _StateButton(
                    label: "Atidėti",
                    icon: Icons.schedule,
                    onButtonPressed: _onDelayMedication,
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            if (_isTakingMedication)
              ThemedContainerWidget(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _onMedicationTakenOnTime,
                      style: TextButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Laiku (${widget.agendaItem.scheduledDate.hour.toString().padLeft(2, '0')}:${widget.agendaItem.scheduledDate.minute.toString().padLeft(2, '0')})",
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                    ),
                    SizedBox(width: 2),
                    TextButton(
                      onPressed: _onMedicationTakenOnCustomTime,
                      style: TextButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Rinktis laiką",
                        style: TextStyle(
                          color: colorScheme.onSecondary.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 5),
            _MedicationDateTimeWidget(
              date: widget.upcomingMedicationIntakeAt,
              label: "Artimiausias vartojimas\n",
              alternativeLabel: "Nėra kito numatomo vartojimo",
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicationDateTimeWidget extends StatelessWidget {
  const _MedicationDateTimeWidget({
    required this.label,
    required this.alternativeLabel,
    required this.date,
  });

  final String label;
  final String alternativeLabel;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return date != null
        ? RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: ColorScheme.of(context).onSurfaceVariant,
              ),
              children: [
                TextSpan(text: label),
                TextSpan(
                  text: DateHelper.getFormattedDateTime(date!),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        : Text(alternativeLabel, style: TextStyle(fontSize: 16));
  }
}

class _TimeDelayDialog extends StatefulWidget {
  const _TimeDelayDialog({
    required this.agendaItem,
    required this.nextIntakeAt,
  });

  final AgendaItem agendaItem;
  final DateTime? nextIntakeAt;

  @override
  State<_TimeDelayDialog> createState() => _TimeDelayDialogState();
}

class _TimeDelayDialogState extends State<_TimeDelayDialog> {
  late final DateTime _scheduledDate;
  late final DateTime _maxDelayUntil;
  final int _delayeMins = 15;
  int _delayTimes = 1;
  late DateTime _selectedDelayUntil;

  int _maxDelayPresses() {
    final remainingMinutes = _maxDelayUntil
        .difference(_scheduledDate)
        .inMinutes;
    final steps = remainingMinutes ~/ _delayeMins;

    return steps > 0 ? steps : 1;
  }

  void _updateSelectedDelayDate() {
    _selectedDelayUntil = _maxDelayUntil == _selectedDelayUntil
        ? _maxDelayUntil
        : _scheduledDate.add(Duration(minutes: _delayTimes * _delayeMins));
  }

  void _onAmountDecline() {
    setState(() {
      _delayTimes -= 1;
      _updateSelectedDelayDate();
    });
  }

  void _onAmountAdd() {
    setState(() {
      _delayTimes += 1;
      _updateSelectedDelayDate();
    });
  }

  void _onConfirmTime(BuildContext context) {
    Navigator.pop(context, _selectedDelayUntil);
  }

  void _onCancel(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _scheduledDate = widget.agendaItem.scheduledDate;
    if (widget.nextIntakeAt != null &&
        widget.nextIntakeAt!.day == _scheduledDate.day) {
      _maxDelayUntil = widget.nextIntakeAt!;
    } else {
      _maxDelayUntil = DateTime(
        _scheduledDate.year,
        _scheduledDate.month,
        _scheduledDate.day,
        23,
        59,
      );
    }
    _selectedDelayUntil =
        _scheduledDate.add(Duration(minutes: 15)).day != _scheduledDate.day
        ? _maxDelayUntil
        : _scheduledDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Center(child: Text("Vartojimo atidėjimas")),
      content: SizedBox(
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(child: SectionTextWidget(label: "15 min. pokytis:")),
                AmountButton(
                  icon: Icons.remove,
                  onTap: _onAmountDecline,
                  isDisabled: _delayTimes == 1,
                ),
                SizedBox(width: 5),
                AmountButton(
                  icon: Icons.add,
                  onTap: _onAmountAdd,
                  isDisabled: _delayTimes >= _maxDelayPresses(),
                ),
              ],
            ),
            ThemedContainerWidget(
              doesHeightExpand: true,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      color: ColorScheme.of(context).secondary,
                    ),
                    children: [
                      TextSpan(text: "Atidėti iki: "),
                      TextSpan(
                        text: DateHelper.getFormattedDateTime(
                          _selectedDelayUntil,
                        ),
                        style: TextStyle(
                          //fontSize: 18,
                          color: ColorScheme.of(context).secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: ColorScheme.of(context).onSurfaceVariant,
                ),
                children: [
                  TextSpan(
                    text:
                        widget.nextIntakeAt != null &&
                            widget.nextIntakeAt!.day == _scheduledDate.day
                        ? "Atidėti galima iki kito vartojimo\n"
                        : "Atidėti galima iki\n",
                  ),
                  TextSpan(
                    text: DateHelper.getFormattedDateTime(_maxDelayUntil),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _onCancel(context),
          child: Text("Atšaukti"),
        ),
        ElevatedButton(
          onPressed: () => _onConfirmTime(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorScheme.of(context).primary,
          ),
          child: Text(
            "Pasirinkti",
            style: TextStyle(color: ColorScheme.of(context).onPrimary),
          ),
        ),
      ],
    );
  }
}

class _TimeSelectionDialog extends StatefulWidget {
  const _TimeSelectionDialog();

  @override
  State<_TimeSelectionDialog> createState() => _TimeSelectionDialogState();
}

class _TimeSelectionDialogState extends State<_TimeSelectionDialog> {
  int _hour = TimeOfDay.now().hour;
  int _minute = TimeOfDay.now().minute;

  void _onHourSelected(int index) {
    _hour = index;
  }

  void _onMinSelected(int index) {
    _minute = index;
  }

  void _onConfirmTime(BuildContext context) {
    Navigator.pop(context, TimeOfDay(hour: _hour, minute: _minute));
  }

  void _onCancel(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Center(child: Text("Laiko pasirinkimas")),
      content: SizedBox(
        height: 100,
        child: TimeSpinnerWidget(
          onHourSelected: _onHourSelected,
          onMinSelected: _onMinSelected,
          initialHour: _hour,
          initialMin: _minute,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _onCancel(context),
          child: Text("Atšaukti"),
        ),
        ElevatedButton(
          onPressed: () => _onConfirmTime(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorScheme.of(context).primary,
          ),
          child: Text(
            "Pasirinkti",
            style: TextStyle(color: ColorScheme.of(context).onPrimary),
          ),
        ),
      ],
    );
  }
}

class _StateButton extends StatelessWidget {
  const _StateButton({
    required this.label,
    required this.icon,
    this.color,
    required this.onButtonPressed,
  });

  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 55,
          height: 55,
          child: Card(
            child: IconButton(
              onPressed: onButtonPressed,
              icon: Icon(icon, color: color),
            ),
          ),
        ),
        Text(label),
      ],
    );
  }
}
