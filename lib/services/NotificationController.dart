import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:shahan/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Class-level variable to store the user role
  String _userRole = 'All';

  Future<String> fetchUserRole(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('accounts').doc(uid).get();

      if (snapshot.exists) {
        return snapshot.data()?['role'] ?? 'All';
      } else {
        print('User not found in Firestore');
        return 'All';
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return 'All';
    }
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
    print('Title : ${message.notification?.title}');
    print('Body : ${message.notification?.body}');
    print('Payload : ${message.data}');
  }

  Future<void> initNotification() async {
    try {
      NotificationSettings _notifySettings =
          await FirebaseMessaging.instance.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
      );

      if (_notifySettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        print('User granted permission');
      } else {
        // Open app settings or handle accordingly
      }

      var fcmToken = await FirebaseMessaging.instance.getToken();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      User? user = _auth.currentUser;

      if (user != null) {
        _userRole = await fetchUserRole(user.uid);

        print('Fetched user role: $_userRole');

        if (_userRole == 'user') {
          await FirebaseMessaging.instance.subscribeToTopic('user');
          await FirebaseMessaging.instance.subscribeToTopic('All');
          print('Subscribed to topic: user');
        } else if (_userRole == 'worker') {
          await FirebaseMessaging.instance.subscribeToTopic('worker');
          await FirebaseMessaging.instance.subscribeToTopic('All');
          print('Subscribed to topic: worker');
        } else {
          print('Unknown user role: $_userRole');
        }

        print('Current user role: $_userRole');
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print('Error in initNotification: $e');
    }
  }

  Future<void> unsubscribeFromTopics() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userRole = await fetchUserRole(user.uid);

        if (userRole == 'user') {
          await FirebaseMessaging.instance.unsubscribeFromTopic('user');
          await FirebaseMessaging.instance.unsubscribeFromTopic('All');
          print('Unsubscribed from topic: user');
        } else if (userRole == 'worker') {
          await FirebaseMessaging.instance.unsubscribeFromTopic('worker');
          await FirebaseMessaging.instance.unsubscribeFromTopic('All');
          print('Unsubscribed from topic: worker');
        } else {
          print('Unknown user role: $userRole');
        }
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print('Error in unsubscribeFromTopics: $e');
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;

      print("Notification title: ${notification!.title}");
      print("Notification title: ${notification.body}");
      print("Data: ${message.data.toString()}");

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInitSettings = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (payload) {
      // handleMesssage(context, message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            message.notification!.android!.channelId.toString(),
            message.notification!.android!.channelId.toString(),
            importance: Importance.max,
            showBadge: true,
            playSound: true);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(androidNotificationChannel.id.toString(),
            androidNotificationChannel.name.toString(),
            channelDescription: 'Flutter Notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker',
            sound: androidNotificationChannel.sound);

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {}

    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "shahan-app",
      "private_key_id": "bf545f382ecae13500594f987a641fdcd54049c7",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCXIOFpEwCqCiLv\nXY6hA+3tjxEG6Nk6v6LAGx6gzc+i3nPfokMWpRlD0ZA7ZGT/uDq4FOcV5J9IYwQZ\nbLOsE7HBpn+YLok25pP0HNH9UgrprI5zJn2463DahcV8q+HzUOJT96pRYzunRW/k\nB1obeIadYHjIo7LD1Vp3gWVdnnzs7Nlnwrgc8AqdQNTRh8pkec7xMaPdesFo3tHw\na1v6CCvyDZebX7JECKnWrP95zULELg1Bj8k/+hLuvi0FhaUJpuWnfVyDLckUWz//\ngydKCN23cmcVwFBLnPi3Sh9y1+uM/oC9X7b6OE+h23D+h0HDDh/hJ7COyKVYji9E\ngY8dYz29AgMBAAECggEAGCnXMJQruoRFYq08RU1aCO4jhE3NkcGbNYkAhCh0Bu/3\nae3JOUErgXbrzzs1lNdxeAZLjmoP96RxPtls/tnlRXeoFf52zPLf/BtxjcXE3ejL\nm+ivGFZ4pE/YLB9VULCBh3hlYH7zxkJpafWs+BB0wYvvs/DMf9hIjyv+t5HEGqNj\nFi2H455UkYBci26lB95i0jUAoExqBtcBhZEU8/1rR9D4rSsh5Y8At6h2HUU1bkn2\nAn5Pq4b/n9sFm/phitFyDVilWIdbiz16QRLKQwC9e0mgMW/zpSh4zcK66AJ0Mzmi\nkMrnhCo8fRNSdi8Bkh5rLJGvrKL65WWj8HbKUvByZwKBgQDHAnlaqW5iu1I18XfD\nVkvlvSVLW00u9Zpk3oUzAIGxcV3+iGjd3R20+fWs8ZgG4h3HGy9wzsoITguTowSj\njBr6pFDgLvthkV8ZMKlNq8LpnI8V3WRZoz2vxHIHLn1e/iZhEQj2Vk/Dp5NoQq5w\njw797m2mpezekRZ4odkN1nZwzwKBgQDCaDQF3+0APcUWOcGeA5pOesrc0b+scEkx\nh6RBy3ndk6aCgjceQ7DXNhSLWlS1VFq1OflwLkeA9nWCptmOLv0yBq/e6nRkAOCU\n1OilpXr4GUwdSmLA2IXWhTvUhrlPyzR6Wb0Mt3WPAv7jCWEixmyHAdc3Lz2JRvW1\nPYIkLV0TswKBgHl1OxdoHOTJKq2dh9iCDKRUQjSxrnOglfBGFsk/3+eqJxG3szjl\nQMI5ZAV/FaftzPq9zsBslMVozIv4jFY8piKesnWAdw/fJ0k6d7ndwIHPeUyA6EQE\n6xshK+7SItYdCtNnEC84Ekp5NfAF8mzkAuRb5jQ1RFG5/xr0vIJDh9nlAoGAQy6v\ni7gutv6htWSQPIMSODzHDjiN/JFxOeSeJv6iRqhXypIlahgKbNULlHzK+T8Fectn\nIBVeMHr7cQMn+7LRXRBihq6POl/zPHu3Skc9j69uVlD2f55T4iZ43qEQOTsID6Aj\nbNmZjqqCWwNKxjG8H4vLTA7PPTmAf/mZl9b1a3ECgYBqNyA5aq3V3vDipC0nvhhF\nyR8wZN80mZdZxKYImAutUoC0b/jRYGDO8dyAjvTKYr7AquK8bkynf+wfXjZvJiPE\nXKDgOd699UsXzeiN5MgtdPwBlfEAhQoCFKEw4GdAdvD962/RCAOWF8GlSVDr5Hmi\nisRxjnN74MTDs83KvWNNWg==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-xhy5z@shahan-app.iam.gserviceaccount.com",
      "client_id": "117165140111307180634",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xhy5z%40shahan-app.iam.gserviceaccount.com",
      "universe_doman": "googleapis.com"

      //
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    // Close the HTTP client
    client.close();

    return credentials.accessToken.data;
  }

  Future<void> saveNotification(
      String title, String message, String reciption) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'message': message,
        'recipient': reciption,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error saving notification: $e');
      throw e; // Optional: Propagate the error if needed
    }
  }

  void SendNotification(String title, String desc, String token) async {
    try {
      final String serverKey = await getAccessToken();
      final String fcmEndpoint =
          'https://fcm.googleapis.com/v1/projects/shahan-app/messages:send';
      final Map<String, dynamic> message = {
        'message': {
          'token': token,
          'notification': {
            "title": title,
            "body": desc,
          }
        }
      };

      var req = Request('POST', Uri.parse(fcmEndpoint));
      req.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      });
      req.body = json.encode(message);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        debugPrint(resBody);
      } else {
        debugPrint(resBody);
      }
    } catch (e) {
      print(e);
    }
  }
}
