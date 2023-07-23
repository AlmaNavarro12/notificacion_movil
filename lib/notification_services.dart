import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/calcifer');

  const DarwinInitializationSettings initializationSettingsAndroidIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsAndroidIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> mostrarNotificacion(String titulo, String data) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('channel_id', 'channel_name',
          channelDescription: 'Descripción del canal',
          importance: Importance.high,
          playSound: true,
          color: Colors.teal,
          icon: '@mipmap/calcifer');

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
      1, titulo, data, notificationDetails);
}
