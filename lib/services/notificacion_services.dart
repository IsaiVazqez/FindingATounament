import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificacionsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = new SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}

class PushNotificacionService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream =
      new StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
/*     print('onBackgroundHandler ${message.messageId}'); */
    print(message.data);
    _messageStream.add(message.data['Producto'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
/*     print('onMessageHandler${message.messageId}'); */
    print(message.data);
    _messageStream.add(message.data['Producto'] ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
/*     print('onMessageOpenApp Handler ${message.messageId}'); */
    print(message.data);
    _messageStream.add(message.data['Producto'] ?? 'No data');
  }

//PushNotificacionService
  static Future initializeApp() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
