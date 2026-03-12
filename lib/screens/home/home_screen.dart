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
  final DateTime _today = DateTime.now();
  final DateTime _tomorrow = DateTime.now().add(Duration(days: 1));
  final DateTime _yesterday = DateTime.now().subtract(Duration(days: 1));
  final NotificationService _notificationService = NotificationService();
  late final bool _allowsNotifications;

  Future<bool> _areNotificationsAllowed() async {
    return await _notificationService.areNotificationsAllowed();
  }

  Future<void> _requestNotificationPermission() async {
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
            tabs: [
              Tab(text: "Vakar"),
              Tab(text: "Šiandien"),
              Tab(text: "Rytoj"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AgendaScreen(date: _yesterday),
            AgendaScreen(date: _today),
            AgendaScreen(date: _tomorrow),
          ],
        ),
      ),
    );
  }
}
