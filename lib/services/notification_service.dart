import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_group.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
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
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    debugPrint("VIETOVE: ${currentTimeZone.identifier}");
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
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
    required Map<String, MedicationRecord> recordsMap,
  }) async {
    await notificationsPlugin.cancelAll();

    final nowTz = tz.TZDateTime.now(tz.local);

    for (int i = 0; i < 7; i++) {
      final checkedDate = nowTz.add(Duration(days: i));
      AgendaService agendaService = AgendaService(
        date: DateTime(checkedDate.year, checkedDate.month, checkedDate.day),
        medications: medications,
        recordsMap: recordsMap,
      );

      final List<AgendaGroup> groupedAgenda = agendaService.getGroupedAgenda();
      for (AgendaGroup group in groupedAgenda) {
        final scheduledDateTz = tz.TZDateTime(
          tz.local,
          checkedDate.year,
          checkedDate.month,
          checkedDate.day,
          group.time.hour,
          group.time.minute,
        );
        //TODO Tikrinti ar jau suvartotas kad neschedulintu
        if (!scheduledDateTz.isAfter(nowTz)) continue;
        //debugPrint("NUMATYTA $scheduledDateTz, DABAR: $nowTz");
        final int id =
            (group.items[0].medicationId.hashCode +
                scheduledDateTz.millisecondsSinceEpoch) %
            2147483647;
        String groupedMedications = group.items[0].medicationName;
        if (group.items.length == 2) {
          groupedMedications =
              "$groupedMedications ir ${group.items[1].medicationName}";
        } else if (group.items.length > 2) {
          for (int i = 1; i < group.items.length - 1; i++) {
            groupedMedications =
                "$groupedMedications, ${group.items[i].medicationName}";
          }
          groupedMedications =
              "$groupedMedications ir ${group.items[group.items.length - 1].medicationName}";
        }
        await scheduleNotification(
          id: id,
          title: "Vaisto vartojimas",
          body: "Tavęs laukia $groupedMedications!",
          date: scheduledDateTz,
        );
      }
    }
    //await getPendingNotifications();
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

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await notificationsPlugin.pendingNotificationRequests();
    debugPrint("PENDING: ${pendingNotificationRequests.length.toString()}");
    return pendingNotificationRequests;
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
