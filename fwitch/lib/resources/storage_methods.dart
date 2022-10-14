// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fwitch/global_widgets/toast.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadImageToStorage(BuildContext context, String chatRoom,
      Uint8List file, String uuid) async {
    Reference ref = _storage.ref().child(chatRoom).child(uuid);
    UploadTask uploadTask =
        ref.putData(file, SettableMetadata(contentType: 'image/jpg'));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    if (snapshot.state == TaskState.success) {
      Navigator.pop(context);
      Toast.yoToast("Nice !", "Your Image has been sent Succesfully", context);
    }
    return downloadUrl;
  }
}
