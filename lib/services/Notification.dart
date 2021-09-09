import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:genius/apps/module/request/RequestLeaveDetail.dart';

import 'package:genius/apps/welcome/home_screen.dart';

class NotificationPush {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var context;
  var screen;
  var arguments;

  Future onSelectNotification(payload) {
    var arguments = json.encode(this.arguments);
    if(screen == '/request_leave_detail'){
      Navigator.of(this.context).push(MaterialPageRoute(builder: (_) {
        return RequestLeaveDetail(id: this.arguments);
      }));
    }
    else{
      Navigator.of(this.context).push(MaterialPageRoute(builder: (_) {
        return HomeScreen();
      }));
    }
    // Navigator.of(this.context).push(MaterialPageRoute(builder: (_) {
    //   return screen;
    // }));
  }

  void initialization(context, screen, arguments) {
    this.context = context;
    this.screen = screen;
    this.arguments = arguments;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  showNotification(id, title, subtitle, payload) async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(id, title, subtitle, platform,
        payload: payload);
  }
}
