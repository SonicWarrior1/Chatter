// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fwitch/conversation/views/conversation_screen.dart';
import 'package:fwitch/models/user.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/firestore_methods.dart';
import 'package:fwitch/global_widgets/toast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchingController extends GetxController {
  final firebaseMethods = FirestoreMethods.firestoreMethods;
  TextEditingController username = TextEditingController();
  RxList<MyUser> userNameFilterList = RxList<MyUser>();
  RxBool isUserNameLoading = false.obs;
  Future<void> getUserByUsername({required String userName}) async {
    try {
      isUserNameLoading(true);
      final result = await firebaseMethods.getUserByUsername(userName);
      userNameFilterList.value = result;
      isUserNameLoading(false);
    } on FirebaseException {
      isUserNameLoading(false);
      rethrow;
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      // ignore: unnecessary_string_interpolations
      return "$b" + "_" + "$a";
    } else {
      // ignore: unnecessary_string_interpolations
      return "$a" + "_" + "$b";
    }
  }

  Future<void> createChatRoom(String username, BuildContext context) async {
    if (username !=
        Provider.of<UserProvider>(context, listen: false).user.username) {
      String chatRoomId = getChatRoomId(username,
          Provider.of<UserProvider>(context, listen: false).user.username);
      List<String> users = [
        username,
        Provider.of<UserProvider>(context, listen: false).user.username
      ];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
        "updatedAt": DateTime.now()
      };
      await firebaseMethods.chat(chatRoomId, context, chatRoomMap);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                  )));
    } else {
      Toast.yoToast("", "You cannot send message to Yourself", context);
    }
  }
}
