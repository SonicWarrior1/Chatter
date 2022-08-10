import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwitch/models/livestream.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:fwitch/resources/storage_methods.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance.collection('livestream');
  final StorageMethods _storageMethods = StorageMethods();

  Future<String> startLiveStream(
      BuildContext context, String title, Uint8List? image) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    String channelId = '';
    try {
      // _authMethods.getUserDetails();
      if (title.isNotEmpty && image != null) {
        if (!((await _firestore
                .doc('${user.user.uid}${user.user.username}')
                .get())
            .exists)) {
          String thumbnailUrl = await _storageMethods.uploadImageToStorage(
              'livestream-thumbnails', image, user.user.uid);
          channelId = '${user.user.uid}${user.user.username}';
          LiveStream liveStream = LiveStream(
              title: title,
              image: thumbnailUrl,
              uid: user.user.uid,
              username: user.user.username,
              startedAt: DateTime.now(),
              viewers: 0,
              channelId: channelId);
          _firestore.doc(channelId).set(liveStream.toMap());
          return channelId;
        } else {
          Get.snackbar("", "Two livestream cannot start at same time");
        }
      } else {
        Get.snackbar("Yp", "Please enter all the fields");
      }
    } on FirebaseException catch (e) {
      Get.snackbar("", e.message!);
    }
    return channelId;
  }

  Future<void> endLiveStream(String channelId) async {
    try {
      QuerySnapshot snap =
          await _firestore.doc(channelId).collection('comments').get();
      for (int i = 0; i < snap.docs.length; i++) {
        await _firestore
            .doc(channelId)
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
      }
      await _firestore.doc(channelId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await _firestore.doc(id).update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
