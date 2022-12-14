

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
 Future<void> backgroundHandler(RemoteMessage message) async{
   log("BackgroundMessage received ${message.notification!.title}");
 }

class NotificationServices{

  static Future<void>initialize()async{

   NotificationSettings settings=await FirebaseMessaging.instance.requestPermission();
   if(settings.authorizationStatus==AuthorizationStatus.authorized){
     String? token=await FirebaseMessaging.instance.getToken();
     if(token!=null){
       log(token.toString());
     }
     FirebaseMessaging.onBackgroundMessage(backgroundHandler);

     log("Notification initialized");
   }
  }
}