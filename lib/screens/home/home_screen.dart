import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/dialogs/confirmation_dialog.dart';
import 'package:vaistu_priminimo_sistema/screens/home/agenda_screen.dart';
import 'package:vaistu_priminimo_sistema/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  late final bool _allowsNotifications;
  final List<DateTime> _dates = [
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
  ];

  Future<bool> _areNotificationsAllowed() async {
    return await _notificationService.areNotificationsAllowed();
  }

  Future<void> _requestNotificationPermission() async {
    //await _notificationService.getPendingNotifications();
    _allowsNotifications = await _areNotificationsAllowed();
    if (_allowsNotifications || !mounted) return;
    bool? didConfirm = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        message: "Ar norėtumėte gauti priminimus vaistų vartojimui?",
        title: "Vaistų priminimai",
        rightOptionText: "Noriu gauti",
        leftOptionText: "Ne dabar",
        rightSideHighlighted: true,
      ),
    );

    debugPrint("PASIRINKIMAS $didConfirm");

    if (didConfirm == true) {
      await _notificationService.requestNotificationPermissions();
      await _notificationService.requestExactAlarmsPermission();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestNotificationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Center(
            child: Text("Dienotvarkė", style: TextStyle(color: Colors.white)),
          ),
          backgroundColor: ColorScheme.of(
            context,
          ).primary.withValues(alpha: 0.7),
          bottom: TabBar(
            dividerColor: Colors.white,
            labelStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            unselectedLabelStyle: TextStyle(
              color: ColorScheme.of(context).onSurfaceVariant,
              fontSize: 16,
              //fontWeight: FontWeight.bold,
            ),
            tabs: _dates.map((date) => _DateTab(date: date)).toList(),
          ),
        ),
        body: TabBarView(
          children: _dates.map((date) => AgendaScreen(date: date)).toList(),
        ),
      ),
    );
  }
}

class _DateTab extends StatelessWidget {
  const _DateTab({required this.date});

  final DateTime date;

  String getDayLabel() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime target = DateTime(date.year, date.month, date.day);

    if (target == today) return "Šiandien";
    if (target == today.subtract(const Duration(days: 1))) return "Vakar";
    if (target == today.add(const Duration(days: 1))) return "Rytoj";

    return "";
  }

  String getMonthDayLabel() {
    return "${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 70,
      child: Text(
        "${getDayLabel()}\n${getMonthDayLabel()}",
        textAlign: TextAlign.center,
      ),
    );
  }
}
