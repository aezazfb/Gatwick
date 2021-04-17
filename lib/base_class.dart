import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zippy_rider/models/CfgCustAppModel.dart';
import 'package:zippy_rider/requests/map_screen/cfgCustApp_request.dart';

import 'package:zippy_rider/utils/util.dart' as util;

class BaseClass{

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static String generatedToken;
  static CfgCustAppModel cfgCustAppModel;
  String serverKey =
      "AAAAYERewgI:APA91bFx4JRXZQgAeyNrFiB80hc8rLi_-s0WrElxOhMqbBdd_FYa2ZOlT0nodo6614rvbUZTn73Y9LqPFj-TYMGG5_rXER5Nk0BN9nkKajLWHFhqKvYnY1njEcLK6qn_ivxlFF4gBl9t";


  getToken() {
    messaging.getToken().then((value) {
      assert(value != null);
      generatedToken = value;
      print('TOKEN: $generatedToken');
    });
  }

  setCfgCustAppModel() async {
    cfgCustAppModel = await CfgCustAppRequest.getCgfCustApp('CYP');
  }

  listenMessages(){
    FirebaseMessaging.instance.getInitialMessage().then((message) => {
      if (message != null) {print("printed Initial Message: $message")}
    });
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initSettings);

    FirebaseMessaging.onMessage.listen((event) {
      AndroidNotification androidNotification = event.notification.android;
      if (androidNotification != null) {
        showNotification(event.notification.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      AndroidNotification androidNotification = event.notification.android;
      if (androidNotification != null) {
        showNotification(event.notification.body);
      }
    });
  }

  showNotification(String message) async {
    var android = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        priority: Priority.high, importance: Importance.max);
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
        0, '$message', 'FCM Body', platform,
        payload: 'This is the payload');
  }

  String constructFCMPayLoad(String generatedToken) {
    return jsonEncode({
      "to": "$generatedToken",
      "token": "$generatedToken",
      "data": {"via": "FlutterFire Cloud Messaging!!!"},
      "notification": {
        "title": "Hello FlutterFCM",
        "body": "This notification is sent by fcm"
      }
    });
  }

  Future<void> pushNotification() async {
    print('serverkey: ${util.fcmserverKey}');
    print('sendingtoken: $generatedToken}');
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "key=${util.fcmserverKey}",
    };
    if (generatedToken == null) {
      print('Unable to send FCM message, no token exists.');
      return null;
    }
    try {
      var response = await HttpUtils.postForJson('https://fcm.googleapis.com/fcm/send',
          body: constructFCMPayLoad(generatedToken), headers: headers);

      print('Response: ${response}');
      print('Response: ${response.toString()}');

    } catch (e) {
      print(e);
    }
  }
}