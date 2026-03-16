import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:flutter_timezone/timezone_info.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/agenda_service.dart';

class NotificationService {
  NotificationService._internalConstructor();

  static final NotificationService _notificationServiceInstance =
      NotificationService._internalConstructor();

  factory NotificationService() => _notificationServiceInstance;

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  // final StreamController<String?> _notificationStream =
  //     StreamController<String?>.broadcast();
  // Stream<String?> get notificationStream => _notificationStream.stream;

  Future<void> initializeNotificationService() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    const initSettings = InitializationSettings(android: initSettingsAndroid);

    await notificationsPlugin.initialize(
      settings: initSettings,
      // onDidReceiveNotificationResponse: (details) =>
      //     _notificationStream.add("Notification opened"),
    );

    tz.initializeTimeZones();
    // final TimezoneInfo currentTimeZone =
    //     await FlutterTimezone.getLocalTimezone();
    // debugPrint("VIETOVE: ${currentTimeZone.localizedName?.name}");
    // tz.setLocalLocation(
    //   tz.getLocation(currentTimeZone.localizedName?.name ?? "Europe/Vilnius"),
    // ); //laikinai kol emuliatoriu naudoju
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "medication_channel",
        "Medication reminders",
        channelDescription: "Notifications for medication reminders",
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
  }

  // Future<void> showNotification({
  //   required int id,
  //   required String? title,
  //   required String? body,
  // }) async {
  //   notificationsPlugin.show(
  //     id: id,
  //     title: title,
  //     body: body,
  //     notificationDetails: notificationDetails(),
  //   );
  // }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime date,
  }) async {
    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: date,
      notificationDetails: notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleAllMedications({
    required List<UserMedication> medications,
  }) async {
    await notificationsPlugin.cancelAll();

    final nowTz = tz.TZDateTime.now(tz.local);

    for (int i = 0; i < 7; i++) {
      final checkedDate = nowTz.add(Duration(days: i));
      AgendaService agendaService = AgendaService(
        date: DateTime(checkedDate.year, checkedDate.month, checkedDate.day),
        medications: medications,
      );

      final List<AgendaItem> agenda = agendaService.getAgenda();
      for (AgendaItem item in agenda) {
        final scheduledDateTz = tz.TZDateTime(
          tz.local,
          checkedDate.year,
          checkedDate.month,
          checkedDate.day,
          item.time.hour,
          item.time.minute,
        );

        if (!scheduledDateTz.isAfter(nowTz)) continue;
        debugPrint("NUMATYTA $scheduledDateTz, DABAR: $nowTz");
        final int id =
            (item.medicationId.hashCode +
                scheduledDateTz.millisecondsSinceEpoch) %
            2147483647;
        await scheduleNotification(
          id: id,
          title: "Vaisto vartojimas",
          body: "Tavęs laukia ${item.medicationName}!",
          date: scheduledDateTz,
        );
      }
    }
    await getPendingNotifications();
  }

  Future<void> requestNotificationPermissions() async {
    final android = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.requestNotificationsPermission();
  }

  Future<void> requestExactAlarmsPermission() async {
    final android = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.requestExactAlarmsPermission();
  }

  Future<void> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await notificationsPlugin.pendingNotificationRequests();
    debugPrint("PENDING: ${pendingNotificationRequests.length.toString()}");
  }

  Future<bool> areNotificationsAllowed() async {
    final android = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }
    return true;
  }
}
