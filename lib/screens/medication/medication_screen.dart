import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication/add_type_selection_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/medication_preview_screen.dart';
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
    final medications = context.watch<MedicationProvider>().uerMedications;

    return Scaffold(
      appBar: RootAppBar(title: "Mano vaistai"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
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
                      //SizedBox(height: 10),
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
          backgroundColor: const Color.fromARGB(255, 9, 175, 14),
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
          Icon(Icons.medication_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text("Neturite pridėtų vaistų", style: TextStyle(fontSize: 18)),
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    medication.medicationType!.getLabel,
                    style: TextStyle(fontSize: 20),
                  ),
                  if (medication.currentQuantity != null)
                    Text(
                      "Likutis: ${medication.medicationType!.consumedAmoutIsInteger ? medication.currentQuantity!.toInt() : medication.currentQuantity} ${medication.medicationType!.getUnit}",
                      style: TextStyle(fontSize: 20),
                    ),
                ],
              ),
              IconButton(
                onPressed: () => _onMedicationPreview(context),
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorScheme.of(context).primary,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
