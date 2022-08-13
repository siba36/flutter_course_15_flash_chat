import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(context) {
    final initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? route) {
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'flash_chat',
          'flash chat channel',
          channelDescription: 'this is my channel',
          importance: Importance.max,
          priority: Priority.max,
        ),
      );
      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
