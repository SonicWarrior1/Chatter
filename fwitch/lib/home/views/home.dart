// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fwitch/conversation/controller/chat_controller.dart';
import 'package:fwitch/conversation/views/conversation_screen.dart';
import 'package:fwitch/resources/firestore_methods.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:fwitch/home/controller/home_controller.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthMethods _authMethods = AuthMethods();

  final HomeController homeController = HomeController();

  final ChatController chatController = ChatController();
  @override
  void initState() {
    super.initState();
    FirestoreMethods.firestoreMethods.setToken(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 227, 155),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView(
            children: [
              DrawerHeader(
                  padding: const EdgeInsets.all(0),
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background),
                    currentAccountPicture: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: CircleAvatar(
                        child: Text(
                            Provider.of<UserProvider>(context, listen: false)
                                .user
                                .username
                                .toString()
                                .substring(0, 1)),
                      ),
                    ),
                    accountName: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: Text(
                        Provider.of<UserProvider>(context, listen: false)
                            .user
                            .username,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    accountEmail: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        Provider.of<UserProvider>(context, listen: false)
                            .user
                            .email,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  )),
              InkWell(
                onTap: () {
                  Get.offAllNamed('/home');
                },
                child: const ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                ),
              ),
              Obx(() {
                return ListTile(
                    title: const Text("Dark Mode"),
                    leading: Icon(
                        Get.isDarkMode ? Icons.sunny : Icons.wb_sunny_outlined),
                    trailing: Switch(
                      value: homeController.darkTheme.value,
                      onChanged: (value) {
                        Get.changeThemeMode(
                            Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                        homeController.darkTheme.value = !Get.isDarkMode;
                      },
                    ));
              }),
              InkWell(
                child: const ListTile(
                  title: Text("FeedBack"),
                  leading: Icon(Icons.feedback),
                ),
                onTap: () {
                  final Uri emailLaunchUri =
                      Uri(scheme: "mailto", path: "harjot802@gmail.com");
                  launchUrl(emailLaunchUri);
                },
              ),
              InkWell(
                onTap: () {
                  showAlertDialog(context);
                },
                child: const ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Sign Out"),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: const Color.fromARGB(255, 255, 227, 155),
        backgroundColor: const Color.fromARGB(255, 255, 227, 155),
        title: const Text("Chatter"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 196, 249, 226),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('chatRoom')
              .where(
                'users',
                arrayContains: Provider.of<UserProvider>(context, listen: false)
                    .user
                    .username,
              )
              .orderBy('updatedAt', descending: true)
              .snapshots(),
          builder: (context, friendSnapshot) {
            if (friendSnapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (friendSnapshot.hasError) {
              return const Center(
                child: Text("Something went Wrong 😶"),
              );
            } else if (friendSnapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/no-data-found.json'),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Start chatting by searching their username")
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: friendSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('chatRoom')
                          .doc(friendSnapshot.data!.docs[index]['chatRoomId'])
                          .collection('chats')
                          .orderBy(
                            "createdAt",
                          )
                          .snapshots(),
                      builder: (context, chatSnapshot) {
                        Color color = Colors.primaries[
                            Random().nextInt(Colors.primaries.length)];
                        DateTime time;
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          time = DateTime.parse(chatSnapshot
                                  .data!
                                  .docs[chatSnapshot.data!.docs.length - 1]
                                      ['createdAt']
                                  .toDate()
                                  .toString())
                              .toLocal();
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: color,
                                        blurStyle: BlurStyle.inner,
                                        blurRadius: 10,
                                        spreadRadius: -5,
                                        offset: const Offset(5, 5))
                                  ]),
                              child: Card(
                                // shadowColor: color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () async {
                                    await chatController.setFcmToken(
                                        friendSnapshot
                                            .data!.docs[index]['chatRoomId']
                                            .toString()
                                            .replaceAll("_", "")
                                            .replaceAll(
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .user
                                                    .username,
                                                ""));
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ConversationScreen(
                                        chatRoomId: friendSnapshot
                                            .data!.docs[index]['chatRoomId'],
                                      );
                                    }));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer))),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 15),
                                      leading: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: CircleAvatar(
                                          backgroundColor: color,
                                          child: Text(
                                            friendSnapshot
                                                .data!.docs[index]['chatRoomId']
                                                .toString()
                                                .replaceAll("_", "")
                                                .replaceAll(
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .username,
                                                    "")
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        friendSnapshot
                                            .data!.docs[index]['chatRoomId']
                                            .toString()
                                            .replaceAll("_", "")
                                            .replaceAll(
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .user
                                                    .username,
                                                ""),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      subtitle: chatSnapshot.data!.docs[
                                                  chatSnapshot
                                                          .data!.docs.length -
                                                      1]['isImage'] ==
                                              true
                                          ? const Text("Image")
                                          : Text(chatSnapshot.data!.docs[
                                              chatSnapshot.data!.docs.length -
                                                  1]['message']),
                                      trailing: Text("$time".substring(11, 16)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      });
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Search users",
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/search');
          },
          child: const Icon(Icons.search),
        ),
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
            onPressed: () async {
              await _authMethods.signout();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
