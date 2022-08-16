import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fwitch/conversation/views/conversation_screen.dart';

import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:fwitch/home/controller/home_controller.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();
  final HomeController homeController = HomeController();
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatter"), actions: [
        IconButton(
          icon: Icon(Get.isDarkMode ? Icons.sunny : Icons.wb_sunny_outlined),
          onPressed: () {
            Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
          },
        ),
        Tooltip(
          message: "Sign Out",
          child: IconButton(
              onPressed: () {
                showAlertDialog(context);
              },
              icon: const Icon(Icons.logout)),
        )
      ]),
      body: StreamBuilder<dynamic>(
        stream: FirebaseFirestore.instance
            .collection('chatRoom')
            .where(
              'users',
              arrayContains: Provider.of<UserProvider>(context, listen: false)
                  .user
                  .username,
            )
            .snapshots(),
        builder: (context, friendSnapshot) {
          if (friendSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Start chatting by searching their username"),
            );
          } else {
            return ListView.builder(
              itemCount: friendSnapshot.data.docs.length,
              itemBuilder: (context, index) {
                return StreamBuilder<dynamic>(
                    stream: FirebaseFirestore.instance
                        .collection('chatRoom')
                        .doc(friendSnapshot.data.docs[index]['chatRoomId'])
                        .collection('chats')
                        .orderBy(
                          "createdAt",
                        )
                        .snapshots(),
                    builder: (context, chatSnapshot) {
                      var time = DateTime.parse(chatSnapshot
                              .data
                              .docs[chatSnapshot.data.docs.length - 1]
                                  ['createdAt']
                              .toDate()
                              .toString())
                          .toLocal();
                      if (friendSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          chatSnapshot.connectionState ==
                              ConnectionState.waiting) {
                        return Center(
                          child: Container(),
                        );
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConversationScreen(
                                        chatRoomId: friendSnapshot
                                            .data.docs[index]['chatRoomId'],
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer))),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            leading: CircleAvatar(
                              child: Text(friendSnapshot
                                  .data.docs[index]['chatRoomId']
                                  .toString()
                                  .replaceAll("_", "")
                                  .replaceAll(
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user
                                          .username,
                                      "")
                                  .substring(0, 1)
                                  .toUpperCase()),
                            ),
                            title: Text(friendSnapshot
                                .data.docs[index]['chatRoomId']
                                .toString()
                                .replaceAll("_", "")
                                .replaceAll(
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user
                                        .username,
                                    "")),
                            subtitle: chatSnapshot.data.docs[
                                            chatSnapshot.data.docs.length - 1]
                                        ['isImage'] ==
                                    true
                                ? const Text("Image")
                                : Text(chatSnapshot.data
                                        .docs[chatSnapshot.data.docs.length - 1]
                                    ['message']),
                            trailing: Text("$time".substring(11, 16)),
                          ),
                        ),
                      );
                    });
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/search');
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  Future<String?> showAlertDialog(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sign Out '),
        content: const Text("Are you sure you want to Sign Out ?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'stay on page'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _authMethods.signout();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
