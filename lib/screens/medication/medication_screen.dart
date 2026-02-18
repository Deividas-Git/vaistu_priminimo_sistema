import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication/add_type_selection_screen.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  void _onAddMedication() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTypeSelectionScreen()),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  //TODO reikia pakrauti pridetus naudotojo vaistus
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().appUser;
    debugPrint("MEDICATION SKAICIUS: ${user?.userMedications.length}");
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(12.0), child: Column()),
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
