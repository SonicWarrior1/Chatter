// ignore_for_file: prefer_const_constructors, must_call_super

import 'package:flutter/material.dart';
import 'package:fwitch/broadcast/controller/broadcast_controller.dart';
import 'package:fwitch/broadcast/widgets/chat.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BroadcastScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;
  const BroadcastScreen(
      {Key? key, required this.isBroadcaster, required this.channelId})
      : super(key: key);

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  BroadcastController broadcastController = BroadcastController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    broadcastController.initEngine(
        widget.isBroadcaster, widget.channelId, context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        broadcastController.leaveChannel(widget.channelId, context);
        return Future.value(true);
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              broadcastController.renderVideo(user, context, widget.channelId),
              if ("${user.user.uid}${user.user.username}" == widget.channelId)
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        broadcastController.switchCamera();
                      },
                      child: Icon(Icons.switch_camera),
                    ),
                    InkWell(
                      onTap: () {
                        broadcastController.onToggleMute();
                      },
                      child: Obx(() {
                        return Icon(broadcastController.isMuted.value
                            ? Icons.volume_up_sharp
                            : Icons.volume_mute);
                      }),
                    ),
                  ],
                ),
              Expanded(
                child: Chat(
                  channelId: widget.channelId,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
