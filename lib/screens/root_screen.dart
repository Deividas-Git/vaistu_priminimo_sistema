import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/managers/notification_manager.dart';
import 'package:vaistu_priminimo_sistema/providers/health_metrics_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/home/home_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/medication_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/profile/profile_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/statistics/statistics_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, this.initialScreenIndex});
  final int? initialScreenIndex;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late NotificationManager _notificationManager;
  final List<Widget> _navBarScreens = [
    HomeScreen(),
    MedicationScreen(),
    StatisticsScreen(),
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
      context.read<MedicationRecordsProvider>().startListening(uid);
      context.read<HealthMetricsProvider>().startListening(uid);

      _notificationManager = NotificationManager(
        context.read<MedicationProvider>(),
        context.read<MedicationRecordsProvider>(),
      );
    }

    _selectedScreenIndex = widget.initialScreenIndex ?? 0;
  }

  @override
  void dispose() {
    _notificationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _selectedScreenIndex == 0
                ? Icon(Icons.home)
                : Icon(Icons.home_outlined),
            label: "Pagrindinis",
          ),
          BottomNavigationBarItem(
            icon: _selectedScreenIndex == 1
                ? Icon(Icons.medication)
                : Icon(Icons.medication_outlined),
            label: "Vaistai",
          ),
          BottomNavigationBarItem(
            icon: _selectedScreenIndex == 2
                ? Icon(Icons.insert_chart)
                : Icon(Icons.insert_chart_outlined),
            label: "Progresas",
          ),
          BottomNavigationBarItem(
            icon: _selectedScreenIndex == 3
                ? Icon(Icons.person)
                : Icon(Icons.person_outline),
            label: "Paskyra",
          ),
        ],
        currentIndex: _selectedScreenIndex!,
        onTap: _onNavMenuSelected,
      ),
      body: _navBarScreens[_selectedScreenIndex!],
    );
  }
}
