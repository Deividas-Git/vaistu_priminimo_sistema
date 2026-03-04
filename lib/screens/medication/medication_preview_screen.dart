import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/dialogs/delete_confirmation_dialog.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication/add_medication_info_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_date_picker_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_quantity_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/schedule_tile_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class MedicationPreviewScreen extends StatelessWidget {
  const MedicationPreviewScreen({super.key, required this.medication});

  final UserMedication medication;

  void _onEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddMedicationInfoScreen(prefilledMedication: medication),
      ),
    );
  }

  void _onDelete(BuildContext context) async {
    final bool? didConfirm = await showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        message: "Ar tikrai norite pašalinti pasirinktą vaistą?",
        title: "Vaisto šalinimas",
      ),
    );

    if (!context.mounted) return;

    if (didConfirm == true) {
      final String uid = context.read<UserProvider>().appUser!.uid;
      context.read<MedicationProvider>().removeMedication(medication.id!, uid);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Vaisto peržiūra", style: TextStyle(color: Colors.white)),
        backgroundColor: ColorScheme.of(context).primary.withValues(alpha: 0.7),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () => _onEdit(context),
              icon: Icon(Icons.edit),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () => _onDelete(context),
              icon: Icon(
                Icons.delete,
                //color: const Color.fromARGB(110, 255, 17, 0),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SectionTextWidget(label: "Bendra informacija"),
              _LabelValueTile(label: "Pavadinimas", value: medication.name!),
              _LabelValueTile(
                label: "Vaisto tipas",
                value: medication.medicationType!.getLabel,
              ),
              _LabelValueTile(
                label: "Vartojama",
                value: medication.medicationMealTiming!.getLabel,
              ),
              MedicationDatePickerWidget(
                label: "Galioja iki",
                selectedDate: medication.expirationDate,
                onDatePicked: null,
              ),
              SizedBox(height: 5),
              MedicationQuantityWidget(
                medicationType: medication.medicationType!,
                previewAmount: medication.currentQuantity,
              ),
              Divider(thickness: 2, color: ColorScheme.of(context).primary),
              SizedBox(height: 5),
              SectionTextWidget(label: "Vartojimo tvarkaraščiai"),
              if (medication.medicationSchedules != null)
                ...medication.medicationSchedules!.map(
                  (schedule) => ScheduleTileWidget(
                    medicationType: medication.medicationType!,
                    schedule: schedule,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelValueTile extends StatelessWidget {
  const _LabelValueTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemedContainerWidget(
          child: Row(
            children: [
              Text("$label: ", style: TextStyle(fontSize: 16)),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
