import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/dialogs/confirmation_dialog.dart';
import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/home/agenda_screen.dart';
import 'package:vaistu_priminimo_sistema/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  final DateTime now = DateHelper.normalizedDate(DateTime.now())!;
  late final List<DateTime> _dates;

  Future<void> _updateExpiredDelayedMedicationRecords() async {
    final String? uid = context.read<UserProvider>().appUser?.uid;
    if (uid != null) {
      await context
          .read<MedicationRecordsProvider>()
          .updateExpiredDelayedRecords(uid);
    }
  }

  Future<bool> _areNotificationsAllowed() async {
    return await _notificationService.areNotificationsAllowed();
  }

  Future<void> _requestNotificationPermission() async {
    final bool allowsNotifications = await _areNotificationsAllowed();
    if (allowsNotifications || !mounted) return;
    final AppUser? user = context.read<UserProvider>().appUser;
    if (user == null) return;
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

    if (didConfirm == true) {
      await _notificationService.requestNotificationPermissions();
      await _notificationService.requestExactAlarmsPermission();
      if (!mounted) return;
      _notificationService.scheduleAllMedications(
        medications: context.read<MedicationProvider>().uerMedications,
        recordsMap: context.read<MedicationRecordsProvider>().getRecordsMap(),
      );
    }
  }

  void updateLastTimeTaken(List<MedicationRecord> medicationRecords) {
    setState(() {
      context.read<MedicationProvider>().updateLastTimeTaken(medicationRecords);
    });
  }

  @override
  void initState() {
    super.initState();

    _dates = [now.subtract(Duration(days: 1)), now, now.add(Duration(days: 1))];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestNotificationPermission();
      _updateExpiredDelayedMedicationRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<UserMedication> medications = context
        .watch<MedicationProvider>()
        .uerMedications;
    final List<MedicationRecord> medicationRecords = context
        .watch<MedicationRecordsProvider>()
        .medicationRecords;
    final Map<String, MedicationRecord> recordsMap = context
        .read<MedicationRecordsProvider>()
        .getRecordsMap();

    updateLastTimeTaken(medicationRecords);

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
          children: _dates
              .map(
                (date) => AgendaScreen(
                  date: date,
                  medications: medications,
                  medicationRecords: recordsMap,
                ),
              )
              .toList(),
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
    final DateTime today = DateHelper.normalizedDate(now)!;

    if (date == today) return "Šiandien";
    if (date == today.subtract(Duration(days: 1))) return "Vakar";
    if (date == today.add(Duration(days: 1))) return "Rytoj";

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
