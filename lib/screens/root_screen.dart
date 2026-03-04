import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/home/home_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/medication_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/profile/profile_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, this.initialScreenIndex});
  final int? initialScreenIndex;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<Widget> _navBarScreens = [
    HomeScreen(),
    MedicationScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];
  int? _selectedScreenIndex;

  void _onNavMenuSelected(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    final String? uid = context.read<UserProvider>().appUser?.uid;
    if (uid != null) {
      context.read<MedicationProvider>().startListening(uid);
    }

    _selectedScreenIndex = widget.initialScreenIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Pagrindinis"),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: "Vaistai",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Progresas",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Paskyra"),
        ],
        currentIndex: _selectedScreenIndex!,
        onTap: _onNavMenuSelected,
      ),
      body: _navBarScreens[_selectedScreenIndex!],
    );
  }
}
