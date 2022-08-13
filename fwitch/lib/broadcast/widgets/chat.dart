import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fwitch/broadcast/controller/broadcast_controller.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.channelId}) : super(key: key);
  final String channelId;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  BroadcastController broadcastController = BroadcastController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    broadcastController.chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context).user;
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? MediaQuery.of(context).size.width * 0.25
          : double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: StreamBuilder<dynamic>(
            stream: FirebaseFirestore.instance
                .collection('livestream')
                .doc(widget.channelId)
                .collection('comments')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    snapshot.data.docs[index]['username'],
                    style: TextStyle(
                      color:
                          snapshot.data.docs[index]['uid'] == userProvider.uid
                              ? Colors.blue
                              : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    snapshot.data.docs[index]['message'],
                  ),
                ),
                itemCount: snapshot.data.docs.length,
              );
            },
          )),
          TextFormField(
            controller: broadcastController.chatController,
            onFieldSubmitted: (value) {
              FirestoreMethods().chat(broadcastController.chatController.text,
                  widget.channelId, context);
              setState(() {
                broadcastController.chatController.text = "";
              });
            },
          )
        ],
      ),
    );
  }
}
