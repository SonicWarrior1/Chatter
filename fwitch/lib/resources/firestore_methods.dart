// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwitch/models/user.dart';
import 'package:fwitch/providers/user_provider.dart';

import 'package:fwitch/global_widgets/toast.dart';
import 'package:provider/provider.dart';

class FirestoreMethods {
  /// To get only one instance of a class
  FirestoreMethods._private();
  static final firestoreMethods = FirestoreMethods._private();

  final _firestore = FirebaseFirestore.instance;

  Future<void> chat(
      String chatRoomId, BuildContext context, chatRoomMap) async {
    try {
      await _firestore.collection('chatRoom').doc(chatRoomId).set(chatRoomMap);
    } on FirebaseException catch (e) {
      Toast.yoToast("", e.message.toString(), context);
    }
  }

  Future<List<MyUser>> getUserByUsername(String username) async {
    final result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return result.docs.map((e) => MyUser.fromMap(e.data())).toList();
  }

  Future<void> sendConversation(
      String chatRoomId, Map<String, dynamic> messageMap) async {
    try {
      await _firestore
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messageMap);
      await _firestore
          .collection('chatRoom')
          .doc(chatRoomId)
          .update({'updatedAt': DateTime.now()});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setToken(BuildContext context) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final uid = Provider.of<UserProvider>(context, listen: false).user.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'fcmToken': fcmToken});
  }

  Future<String> getToken(username) async {
    QuerySnapshot<Map<String, dynamic>> x = await FirebaseFirestore.instance
        .collection('users')
        .where("username", isEqualTo: username)
        .get();
    return x.docs[0]['fcmToken'];
  }
}
