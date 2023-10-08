// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fwitch/global_widgets/toast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class NotificationController extends GetxController {
  constructFCMPayload(String? token, String sender, String message,String chatRoomId) {
    return jsonEncode({
      "to": token,
      'notification': {
        'title': sender,
        'body': message,
      },
      "data":{"chatRoomId":chatRoomId}
    });
  }

  Future<void> sendPushMessage(
      String notificationToken, String sender, String message,String chatRoomId,BuildContext context) async {
    // print('sending to $notificationToken');
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAarEGT-Y:APA91bGUcOcAk5qzK9nNlfDMPSGWsHbhFsT8DTAOKkOOV_BebDOXX_Ny4Gmh6h1vwZMQuezw_t8E8aRNPzjsyHMG678z7HmZHduj8dP1akUYb-v1Z8b9o3d2AF7wv1PuEiO_73HDJVPi'
        },
        body: constructFCMPayload(notificationToken, sender, message,chatRoomId),

      );
    } catch (e) {
      Toast.yoToast("",e.toString(),context);
    }
  }
}
