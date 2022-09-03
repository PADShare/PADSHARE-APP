
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class FIREBASE_FCM{
  static String token = "";
  static var storage = FlutterSecureStorage();
  static  AndroidNotificationChannel channel;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static void LoadFCM()async{


    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

      // await flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //     AndroidFlutterLocalNotificationsPlugin>()
      //     ?.createNotificationChannel(channel);
      //
      // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
      //
      // const AndroidNotificationChannel channel = AndroidNotificationChannel(
      //   'high_importance_channel', // id
      //   'High Importance Notifications', // title
      //   'This channel is used for important notifications.', // description
      //   importance: Importance.high,
      // );


  }

  static void ListenFCM()async{
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }


  static FCMGetTOKEN()async{
    var storage = FlutterSecureStorage();
    await FirebaseMessaging.instance.getToken().then((token)async{
      print("DEVICE_TOEKEN_ ${token}");
     // await storage.delete(key: "token");
     await storage.write(key: "token", value: token);
     // return token;
    });
  }
  // String body, String title, String description

  static  void FCMSENDMESSEG(token, String body, String title, String description)async {
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers:<String, String>{
          'Content-Type': 'application/json',
          'Authorization' : 'key=AAAAaY4xDEY:APA91bFsqGzpFfm7fq-fq6jhd90EjsKUDrwKRhGluFbv8901FBlYYVll0lvJpJZNR_olOMlLcOOQ-A_e2lLKDQkaZdR5FkhHYHE2FVY7swi7q-2GxLerwMLzv2VNu418jjvgv95QoVZT',
        },
        // body:jsonEncode(
        //   <String, dynamic>{
        //     'notification': <String, dynamic>{
        //       'body': 'Text',
        //       'title': 'Test Title',
        //     },
        //     'priority': 'high',
        //     'data': <String, dynamic>{
        //       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        //       'id': '1',
        //       'status': 'done'
        //     },
        //     'to': '/topics/Users/',
        //   }
        // )
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'description' : description
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "$token" //"/topics/MessagesToSend",
          },
        ),
      );

    }catch(e){
      print(e);
      print("error push notification ::$e");
    }
  }
  static void FCMSAVETOKEN(token)async{
    await _firestore.collection("UsersTokens").doc(_auth.currentUser.uid).set({
      "user": _auth.currentUser.displayName,
      "user_token": token,
    });
    await _firestore.collection("users").doc(_auth.currentUser.uid).update({
      "user_token": token,
    });
  }


  static void FCMUPDATETOKEN(token)async {
    await _firestore.collection("UsersTokens")
        .doc(_auth.currentUser.uid)
        .update({
      "user_token": token,
    });

    await _firestore.collection("users").doc(_auth.currentUser.uid).update({
      "user_token": token,
    });

    // await _firestore
    //     .collection("users")
    //     .doc(_auth.currentUser.uid) //.where('cellnumber', isEqualTo: cellNumber)
    //     .get().then((value){
    //
    //       var team = value.data()['teamID'];
    //       // _firestore.collection("userTeams").doc(team).collection("allUsers").where("uid", i;
    // });


  }

  static void GETTEAMID(team)async{

    await _firestore.collection("teams").where("teamName", isEqualTo: team).get().then((teams)async{

      var team = teams.docs[0].data()['teamId'];
       await storage.write(key: "teamID", value: team);
      print(" LOCAL_TEAM _${team}");

    });
  }

}