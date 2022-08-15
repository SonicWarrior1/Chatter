import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwitch/models/user.dart';

import 'package:fwitch/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  /// To get only one instance of a class
  FirestoreMethods._private();
  static final firestoreMethods = FirestoreMethods._private();

  final _firestore = FirebaseFirestore.instance;

  Future<void> chat(
      String chatRoomId, BuildContext context, chatRoomMap) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    try {
      // String commentId = Uuid().v1();
      await _firestore.collection('chatRoom').doc(chatRoomId).set(chatRoomMap);
    } on FirebaseException catch (e) {
      Get.snackbar("", e.message!);
    }
  }

  Future<List<MyUser>> getUserByUsername(String username) async {
    final result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return result.docs.map((e) => MyUser.fromMap(e.data())).toList();
  }
}
