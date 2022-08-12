import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fwitch/config/app-Id.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:fwitch/resources/firestore_methods.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:http/http.dart' as http;

class BroadcastController extends GetxController {
  String baseUrl = "https://fwitch123.herokuapp.com/";
  RxString token = "".obs;
  Future<void> getToken(String channelId, BuildContext context) async {
    final res = await http.get(Uri.parse(baseUrl +
        '/rtc/' +
        channelId +
        '/publisher/userAccount/' +
        Provider.of<UserProvider>(context, listen: false).user.uid +
        '/'));
    if (res.statusCode == 200) {
      token.value = res.body;
      token.value = jsonDecode(token.value)['rtcToken'];
    } else {
      debugPrint('Failed to fetch Token ');
    }
  }

  late final RtcEngine _engine;
  RxList remoteUid = [].obs;
  RxBool switchcamera = true.obs;
  RxBool isMuted = false.obs;
  TextEditingController chatController = TextEditingController();
  initEngine(bool isBroadcaster, String channelId, BuildContext context) async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    addListeners(channelId, context);
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    _engine.setClientRole(
        isBroadcaster ? ClientRole.Broadcaster : ClientRole.Audience);
    // ignore: use_build_context_synchronously
    joinChaneel(context, channelId);
  }

  addListeners(String channelId, BuildContext context) {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: ((channel, uid, elapsed) {
        debugPrint('joinChannelSuccess $channel $uid $elapsed');
      }),
      userJoined: (uid, elapsed) {
        debugPrint("userJoined $uid $elapsed");
        remoteUid.add(uid);
      },
      userOffline: ((uid, reason) {
        debugPrint('userOffline $uid $reason');
        remoteUid.removeWhere((element) => element == uid);
      }),
      leaveChannel: ((stats) {
        debugPrint("leaveChannel $stats");
        remoteUid.clear();
      }),
      tokenPrivilegeWillExpire: (token) async {
        await getToken(channelId, context);
        await _engine.renewToken(token);
      },
    ));
  }

  void joinChaneel(BuildContext context, String channelId) async {
    await getToken(channelId, context);
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
      await _engine.joinChannelWithUserAccount(token.value, "testing123",
          Provider.of<UserProvider>(context, listen: false).user.uid);
    }
  }

  renderVideo(user, BuildContext context, String channelId) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: "${user.user.uid}${user.user.username}" == channelId
            ? RtcLocalView.SurfaceView(
                zOrderMediaOverlay: true,
                zOrderOnTop: true,
              )
            : remoteUid.isNotEmpty
                ? kIsWeb
                    ? RtcRemoteView.SurfaceView(
                        uid: remoteUid[0],
                        channelId: channelId,
                      )
                    : RtcRemoteView.TextureView(
                        uid: remoteUid[0],
                        channelId: channelId,
                      )
                : Container());
  }

  void switchCamera() {
    _engine
        .switchCamera()
        .then((value) => {switchcamera.value = !switchcamera.value})
        .catchError((e) {
      debugPrint('switchCamera $e');
    });
  }

  void onToggleMute() async {
    isMuted.value = !isMuted.value;
    await _engine.muteLocalAudioStream(isMuted.value);
  }

  leaveChannel(String channelId, BuildContext context) async {
    await _engine.leaveChannel();
    if ("${Provider.of<UserProvider>(context, listen: false).user.uid}${Provider.of<UserProvider>(context, listen: false).user.username}" ==
        channelId) {
      await FirestoreMethods().endLiveStream(channelId);
    } else {
      await FirestoreMethods().updateViewCount(channelId, false);
    }
    Get.offAllNamed('/home');
  }
}
