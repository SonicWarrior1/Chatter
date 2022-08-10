import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fwitch/resources/firestore_methods.dart';
import 'package:get/get.dart';

class GoLiveController extends GetxController {
  TextEditingController titleController = TextEditingController();
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

  goLiveStream(BuildContext context) async {
    await FirestoreMethods()
        .startLiveStream(context, titleController.text, image.value);
    // if (channelId.isNotEmpty) {
    //   Get.snackbar("", "Live Stream Started");
    // }
  }
}
