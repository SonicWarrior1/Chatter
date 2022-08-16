import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fwitch/conversation/controller/chat_controller.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  Chat({Key? key, required this.chatRoomId}) : super(key: key);

  final String chatRoomId;
  ChatController chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.put(ChatController());
    final userProvider = Provider.of<UserProvider>(context).user;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: StreamBuilder<dynamic>(
          stream: FirebaseFirestore.instance
              .collection('chatRoom')
              .doc(chatRoomId)
              .collection('chats')
              .orderBy(
                "createdAt",
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              controller: controller.scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var time = DateTime.parse(snapshot.data.docs[index]['createdAt']
                        .toDate()
                        .toString())
                    .toLocal();
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  title: Align(
                    alignment: snapshot.data.docs[index]['sendBy'] ==
                            userProvider.username
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      snapshot.data.docs[index]['sendBy'],
                      style: TextStyle(
                        color: snapshot.data.docs[index]['sendBy'] ==
                                userProvider.username
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize,
                      ),
                    ),
                  ),
                  subtitle: Align(
                    alignment: snapshot.data.docs[index]['sendBy'] ==
                            userProvider.username
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: snapshot.data.docs[index]['sendBy'] ==
                              userProvider.username
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        snapshot.data.docs[index]['isImage'] == true
                            ? Image.network(
                                snapshot.data.docs[index]['url'],
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              )
                            : Text(
                                snapshot.data.docs[index]['message'],
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                        Text(
                          "$time".substring(11, 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.docs.length,
            );
          },
        )),
      ],
    );
  }
}
