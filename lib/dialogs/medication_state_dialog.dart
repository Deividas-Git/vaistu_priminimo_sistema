import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_state_action_result.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/time_spinner_widget.dart';

class MedicationStateDialog extends StatefulWidget {
  const MedicationStateDialog({
    super.key,
    required this.agendaItem,
    required this.date,
  });

  final AgendaItem agendaItem;
  final DateTime date;

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
    TimeOfDay? selectedTime = await showDialog(
      context: context,
      builder: (context) => _TimeSelectionDialog(),
    );
    if (!mounted) return;
    if (selectedTime == null) {
      setState(() {
        _isTakingMedication = false;
      });
      return;
    }
    final MedicationStateActionResult result = MedicationStateActionResult(
      state: MedicationRecordState.pending,
      delayedUntil: DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );
    Navigator.pop(context, result);
  }

  void _onMedicationTakenOnTime() {
    final MedicationStateActionResult result = MedicationStateActionResult(
      state: MedicationRecordState.taken,
      takenAt: DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        widget.agendaItem.time.hour,
        widget.agendaItem.time.minute,
      ),
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
        widget.date.year,
        widget.date.month,
        widget.date.day,
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
        height: _isTakingMedication ? 200 : 150,
        child: Column(
          children: [
            Divider(thickness: 2),
            Text("Paskutinį kartą išgertą: "),
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
                        "Laiku (${widget.agendaItem.time.hour.toString().padLeft(2, '0')}:${widget.agendaItem.time.minute.toString().padLeft(2, '0')})",
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: _onMedicationTakenOnCustomTime,
                      style: TextButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Pasirinkti laiką",
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
          ],
        ),
      ),
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
