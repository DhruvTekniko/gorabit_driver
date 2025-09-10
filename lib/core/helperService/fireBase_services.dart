
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/newOrders/provider/provider.dart';
import '../../screens/newOrders/ui/newOrder_screen.dart';
import '../../Utils/custom_widgets/navigation_method.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _isInitialized = false;
  late BuildContext context;

  Future<void> init(BuildContext passedContext) async {
    if (_isInitialized) return;
    _isInitialized = true;

    context = passedContext;

    try {
      // 🔔 Request Firebase Notification Permission
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        print('⚠️ Notification permission not granted');
        return;
      }

      // ✅ Get FCM Token and store
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("deviceToken", token);
        print("📲 FCM Token: $token");
      }

      // 🎯 Foreground Notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Foreground Notification Received: ${message.notification?.title}");
        Provider.of<NewOrderViewModel>(context, listen: false).fetchNewOrders();
        if (message.notification != null) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              channelKey: 'basic_channel',
              title: message.notification?.title,
              body: message.notification?.body,
              notificationLayout: NotificationLayout.BigPicture,
              bigPicture: message.notification?.android?.imageUrl ?? message.data['image'],
              payload: {'screen': 'home'},
            ),
          );
        }
      });

      // Background / Terminated → App Opened
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("📲 App opened via notification");
        Provider.of<NewOrderViewModel>(context, listen: false).fetchNewOrders();
          Provider.of<NewOrderViewModel>(context, listen: false).fetchNewOrders();
      });
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: (ReceivedAction action) async {
          await handleNotificationAction(action, context);
        },
      );


    } catch (e) {
      print("❌ Firebase Notification Init Error: $e");
    }
  }
  Future<void> handleNotificationAction(ReceivedAction action, BuildContext context) async {
    if (action.payload?['screen'] == 'home') {
      Provider.of<NewOrderViewModel>(context, listen: false).fetchNewOrders();
      navPush(context: context, action: const NewOrderScreen());
    }
  }

}
