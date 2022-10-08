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
        appBar: AppBar(
          title: Text(chatRoomId.toString().replaceAll("_", "").replaceAll(
              Provider.of<UserProvider>(context, listen: false).user.username,
              "")),
        ),
        body: Column(
          children: [
            Expanded(child: Chat(chatRoomId: chatRoomId)),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
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
                                                onPressed: () {
                                                  chatController.sendImage(
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
                            width: 40,
                            child: Center(
                              child: Icon(
                                Icons.image,
                              ),
                            ))),
                    Expanded(
                        child: TextField(
                      onSubmitted: (val) {
                        chatController.sendMessage(chatRoomId, context,);
                      },
                      controller: chatController.chatText,
                      decoration:
                          const InputDecoration(label: Text("Messages...")),
                    )),
                    GestureDetector(
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
                            )))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
