import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication/add_type_selection_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/medication_preview_screen.dart';
import 'package:vaistu_priminimo_sistema/widgets/arrow_button.dart';
import 'package:vaistu_priminimo_sistema/widgets/root_app_bar.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onAddMedication() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTypeSelectionScreen()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<UserMedication> medications = context
        .watch<MedicationProvider>()
        .uerMedications;

    return Scaffold(
      appBar: RootAppBar(title: "Mano vaistai"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 40.0,
            left: 40.0,
            top: 20.0,
            bottom: 20.0,
          ),
          child: medications.isEmpty
              ? _NoMedicationsAddedNoticeWidget()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          hintText: "Pridėto vaisto paieška",
                        ),
                      ),
                      ...List.generate(
                        medications.length,
                        (int index) => _MedicationTile(
                          medication: medications.elementAt(index),
                        ),
                      ),
                      SizedBox(height: 55),
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: _onAddMedication,
          backgroundColor: ColorScheme.of(
            context,
          ).primary, //const Color.fromARGB(255, 9, 175, 14)
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _NoMedicationsAddedNoticeWidget extends StatelessWidget {
  const _NoMedicationsAddedNoticeWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medication_outlined,
            size: 100,
            color: ColorScheme.of(
              context,
            ).onSurfaceVariant.withValues(alpha: 0.9),
          ),
          Text(
            textAlign: TextAlign.center,
            "Neturite pridėtų vaistų",
            style: TextStyle(
              fontSize: 20,
              color: ColorScheme.of(context).onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicationTile extends StatelessWidget {
  const _MedicationTile({required this.medication});

  final UserMedication medication;

  void _onMedicationPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationPreviewScreen(medication: medication),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ThemedContainerWidget(
          doesHeightExpand: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name!,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorScheme.of(context).onSurfaceVariant,
                    ),
                  ),
                  Text(
                    medication.medicationType!.getLabel,
                    style: TextStyle(
                      fontSize: 20,
                      color: ColorScheme.of(context).onSurfaceVariant,
                    ),
                  ),
                  if (medication.currentQuantity != null)
                    Text(
                      "Likutis: ${medication.medicationType!.consumedAmoutIsInteger ? medication.currentQuantity!.toInt() : medication.currentQuantity} ${medication.medicationType!.getUnit}",
                      style: TextStyle(
                        fontSize: 20,
                        color: ColorScheme.of(context).onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              ArrowButton(onButtonPressed: () => _onMedicationPreview(context)),
            ],
          ),
        ),
      ],
    );
  }
}
