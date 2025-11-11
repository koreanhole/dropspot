import 'dart:io';

import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class ActivityRecognitionHandler {
  static final ActivityRecognitionHandler _instance =
      ActivityRecognitionHandler._internal();
  factory ActivityRecognitionHandler() => _instance;
  ActivityRecognitionHandler._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (!Platform.isAndroid) {
      return;
    }

    await _initNotifications();
    await _requestPermission();
    _startTracking();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _requestPermission() async {
    await Permission.activityRecognition.request();
    await Permission.notification.request();
  }

  void _startTracking() {
    FlutterActivityRecognition.instance.activityStream
        .listen((Activity activity) {
      if (activity.type == ActivityType.IN_VEHICLE &&
          activity.confidence == ActivityConfidence.HIGH) {
        // The user is in a vehicle, we can listen for the exit
        _listenForExit(activity);
      }
    });
  }

  void _listenForExit(Activity vehicleActivity) {
    FlutterActivityRecognition.instance.activityStream
        .firstWhere((Activity activity) =>
            activity.type != ActivityType.IN_VEHICLE &&
            activity.confidence == ActivityConfidence.HIGH)
        .then((_) => _showNotification());
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'vehicle_exit_channel',
      'Vehicle Exit',
      channelDescription: 'Notifications for when you exit a vehicle',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(
      0,
      '차량에서 내리셨나요?',
      '주차 위치를 기록하려면 탭하세요.',
      platformChannelSpecifics,
    );
  }
}
