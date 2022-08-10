import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwitch/models/livestream.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:fwitch/resources/storage_methods.dart';
import 'package:get/get.dart';

class FirestoreMethods {
  final AuthMethods _authMethods = AuthMethods();
  final _firestore = FirebaseFirestore.instance.collection('livestream');
  final StorageMethods _storageMethods = StorageMethods();

  startLiveStream(BuildContext context, String title, Uint8List? image) async {
    try {
      _authMethods.getUserDetails();
      if (title.isNotEmpty && image != null) {
        // if ((await _firestore.doc(_authMethods.uid.value).get()).exists) {
        String thumbnailUrl = await _storageMethods.uploadImageToStorage(
            'livestream-thumbnails', image, _authMethods.uid.value);
        String channelId =
            '${_authMethods.uid.value}${_authMethods.username.value}';
        LiveStream liveStream = LiveStream(
            title: title,
            image: thumbnailUrl,
            uid: _authMethods.uid.value,
            username: _authMethods.username.value,
            startedAt: DateTime.now(),
            viewers: 0,
            channelId: channelId);
        _firestore.doc(channelId).set(liveStream.toMap());
        return channelId;
        // } else {
        //   Get.snackbar("", "Two livestream cannot start at same time");
        // }
      } else {
        Get.snackbar("Yp", "Please enter all the fields");
      }
    } catch (e) {
      print(e);
    }
  }
}
