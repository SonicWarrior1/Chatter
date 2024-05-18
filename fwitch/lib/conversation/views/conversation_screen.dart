// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:fwitch/conversation/controller/chat_controller.dart';
import 'package:fwitch/conversation/widgets/chat.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatelessWidget {
  final String chatRoomId;
  ConversationScreen({Key? key, required this.chatRoomId}) : super(key: key);
  final ChatController chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 227, 155),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            surfaceTintColor: const Color.fromARGB(255, 255, 227, 155),
            backgroundColor: const Color.fromARGB(255, 255, 227, 155),
            elevation: 0,
            // shape: const RoundedRectangleBorder(
            //     // side: BorderSide(width: 1),
            //     borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(-200),
            //         bottomRight: Radius.circular(-20))),
            title: Text(chatRoomId.toString().replaceAll("_", "").replaceAll(
                Provider.of<UserProvider>(context, listen: false).user.username,
                "")),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            color: Color.fromARGB(255, 209, 243, 255),
          ),
          // decoration: const BoxDecoration(
          //     image: DecorationImage(
          //   opacity: 0.6,
          //   colorFilter: ColorFilter.mode(
          //       Color.fromARGB(255, 110, 109, 109), BlendMode.exclusion),
          //   image: AssetImage("assets/chat back.jpg"),
          //   fit: BoxFit.cover,
          // )),
          child: Column(
            children: [
              Expanded(child: Chat(chatRoomId: chatRoomId)),
              Container(
                alignment: Alignment.bottomCenter,
                child: Card(
                  color: const Color.fromARGB(255, 255, 227, 155),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          onSubmitted: (val) {
                            chatController.sendMessage(
                              chatRoomId,
                              context,
                            );
                          },
                          controller: chatController.chatText,
                          decoration: const InputDecoration(
                              fillColor: Color.fromARGB(255, 255, 227, 155),
                              focusColor: Color.fromARGB(255, 255, 227, 155),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        )),
                        GestureDetector(
                            onTap: () async {
                              chatController.isImageLoading.value = true;
                              Uint8List? pickedImage =
                                  await chatController.pickImage();
                              if (pickedImage != null) {
                                chatController.image.value = pickedImage;
                                chatController.isImageLoading.value = false;
                              }
                              if (chatController.image.value.isNotEmpty) {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      chatController.isImageSent.value = false;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 400,
                                              height: 300,
                                              child: Image.memory(
                                                  chatController.image.value),
                                            ),
                                            Obx(() {
                                              if (chatController
                                                  .isImageSent.isTrue) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else {
                                                return ElevatedButton(
                                                    onPressed: () async {
                                                      await chatController
                                                          .sendImage(
                                                              chatRoomId,
                                                              chatController
                                                                  .image.value,
                                                              context);
                                                    },
                                                    child: const Text("Send"));
                                              }
                                            })
                                          ],
                                        ),
                                      );
                                    });
                              }
                            },
                            child: const SizedBox(
                                width: 30,
                                height: 30,
                                child: Center(
                                  child: Icon(
                                    // color: Colors.grey,
                                    Icons.image,
                                  ),
                                ))),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(50)),
                          child: GestureDetector(
                              onTap: () {
                                chatController.sendMessage(
                                  chatRoomId,
                                  context,
                                );
                              },
                              child: const SizedBox(
                                  width: 50,
                                  child: Center(
                                    child: Icon(
                                      Icons.send_rounded,
                                    ),
                                  ))),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
