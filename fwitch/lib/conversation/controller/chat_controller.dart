// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fwitch/notification_controller.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/firestore_methods.dart';
import 'package:fwitch/resources/storage_methods.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  StorageMethods storageMethods = StorageMethods();
  TextEditingController chatText = TextEditingController();
  final firebaseMethods = FirestoreMethods.firestoreMethods;
  ScrollController scrollController = ScrollController();
  RxBool isImageLoading = false.obs;
  RxBool isImageSent = false.obs;
  Rx<Uint8List> image = Uint8List.fromList([]).obs;
  NotificationController notificationController =
      Get.put(NotificationController());
  Future<Uint8List?> pickImage() async {
    FilePickerResult? pickedImage =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickedImage != null) {
      if (kIsWeb) {
        return pickedImage.files.single.bytes;
      }
      return await File(pickedImage.files.single.path!).readAsBytes();
    }
    return null;
  }

  setFcmToken(String username) async {
    String result = await FirestoreMethods.firestoreMethods.getToken(username);
    // print(result);
    Hive.box('users').put('fcmToken', result);
  }

  sendImage(String chatRoomId, Uint8List file, BuildContext context) async {
    var uuid = const Uuid();
    isImageSent.value = true;
    String url = await storageMethods.uploadImageToStorage(
        context, chatRoomId, file, uuid.v4());
    if (image.value.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": "",
        "url": url,
        "sendBy":
            Provider.of<UserProvider>(context, listen: false).user.username,
        "createdAt": DateTime.now(),
        "isImage": true
      };
      firebaseMethods.sendConversation(chatRoomId, messageMap);
      notificationController.sendPushMessage(
          Hive.box('users').get('fcmToken'),
          Provider.of<UserProvider>(context, listen: false).user.username,
          "Image",chatRoomId,context);
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  sendMessage(String chatRoomId, BuildContext context) async {
    if (chatText.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": chatText.text,
        "sendBy":
            Provider.of<UserProvider>(context, listen: false).user.username,
        "createdAt": DateTime.now(),
        "isImage": false
      };
      firebaseMethods.sendConversation(chatRoomId, messageMap);
      notificationController.sendPushMessage(
          Hive.box('users').get('fcmToken'),
          Provider.of<UserProvider>(context, listen: false).user.username,
          chatText.text,chatRoomId,context);
      chatText.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }
}
