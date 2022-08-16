import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/firestore_methods.dart';
import 'package:fwitch/resources/storage_methods.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  StorageMethods storageMethods = StorageMethods();
  TextEditingController chatText = TextEditingController();
  final firebaseMethods = FirestoreMethods.firestoreMethods;
  ScrollController scrollController = ScrollController();
  RxBool isImageLoading = false.obs;
  Rx<Uint8List> image = Uint8List.fromList([]).obs;
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

  sendImage(String chatRoomId, Uint8List file, BuildContext context) async {
    var uuid = const Uuid();
    String url =
        await storageMethods.uploadImageToStorage(chatRoomId, file, uuid.v4());

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
    }
  }

  sendMessage(String chatRoomId, BuildContext context) {
    if (chatText.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": chatText.text,
        "sendBy":
            Provider.of<UserProvider>(context, listen: false).user.username,
        "createdAt": DateTime.now(),
        "isImage": false
      };
      firebaseMethods.sendConversation(chatRoomId, messageMap);
      chatText.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 100));
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
