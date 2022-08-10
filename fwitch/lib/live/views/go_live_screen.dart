// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fwitch/live/controller/go_live_controller.dart';
import 'package:get/get.dart';

class GoLiveScreen extends StatelessWidget {
  GoLiveScreen({Key? key}) : super(key: key);
  GoLiveController goLiveController = GoLiveController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () async {
                goLiveController.isImageLoading.value = true;
                Uint8List? pickedImage = await goLiveController.pickImage();
                if (pickedImage != null) {
                  goLiveController.image.value = pickedImage;
                  goLiveController.isImageLoading.value = false;
                  // print(goLiveController.image!.value);
                }
              },
              child: Column(
                children: [
                  Obx(() {
                    if (goLiveController.isImageLoading.isTrue) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (goLiveController.image.value.isNotEmpty) {
                      return SizedBox(
                        child: Image.memory(goLiveController.image.value),
                      );
                    } else {
                      return DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          child: Column(
                            children: [
                              Icon(Icons.folder_copy_outlined),
                              Text("Select your Thumbnail")
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        dashPattern: [10, 4],
                      );
                    }
                  }),
                  TextField(
                    controller: goLiveController.titleController,
                    decoration: InputDecoration(
                      label: Text("Title"),
                    ),
                  )
                ],
              )),
          SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    goLiveController.goLiveStream(context);
                  },
                  child: Text("Go Live")))
        ],
      ),
    ));
  }
}
