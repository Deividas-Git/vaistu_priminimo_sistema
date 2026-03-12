import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internalConstructor();

  static final NotificationService _notificationServiceInstance =
      NotificationService._internalConstructor();

  factory NotificationService() => _notificationServiceInstance;

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  //final StreamController _notificationStream = StreamController<String?>.broadcast();
  //Stream<String?> get notificationStream => _notificationStream.stream;

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
    tz.setLocalLocation(
      tz.getLocation("Europe/Vilnius"),
    ); //laikinai kol emuliatoriu naudoju
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "medication_channel",
        "Medication reminders",
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
  }

  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
  }) async {
    notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(date, tz.local),
      notificationDetails: notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> requestNotificationPermissions() async {
    final android = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    android?.requestNotificationsPermission();
  }

  Future<void> requestExactAlarmsPermission() async {
    final android = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    android?.requestExactAlarmsPermission();
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
