import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sneaky_links/Components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sneaky_links/calling/join_channel_audio.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import '../Services/api_repository.dart';
import '../calling/join_channel_video.dart';

class ReciverPage extends StatefulWidget {
  @override
  _ReciverPageState createState() => _ReciverPageState();
}

class _ReciverPageState extends State<ReciverPage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    ringtone();
    // playerRing();
    // TODO: implement initState
    super.initState();
  }

  ringtone() async {
    print("hello ringtone");
    FlutterRingtonePlayer.play(
      fromAsset: "assets/audio/ring.mp3", // will be the sound on Android
      // android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true,
      volume: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(elevation: 0,
      //   leading: SizedBox(),),
      body: UserNotification() == false
          ? SingleChildScrollView(
            child: Container(
                // color: Colors.blue,
                child: InkWell(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => ProfilePage()));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
                        ),
                        Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              borderRadius: BorderRadius.circular(100)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: Constant.profilePicture,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    "assets/images/discover.png",
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          Constant.username,
                          style: TextStyle(fontSize: 20),
                        ),
                        Constant.type == "Video"
                            ? Text(
                                'Getting Video Call',
                                style: TextStyle(fontSize: 15),
                              )
                            : Text(
                                'Getting Call',
                                style: TextStyle(fontSize: 15),
                              ),
                        SizedBox(
                          height: 110,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            InkWell(
                              onTap: () {
                                FlutterRingtonePlayer.stop();
                                audioPlayer.stop();

                                Constant.type == "Video"
                                    ? Get.off(JoinChannelVideo())
                                    : Get.off(JoinChannelAudio());
                              },
                              child: Container(
                                  height: 75,
                                  width: 75,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(37.5)),
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            SizedBox(
                              width: 80,
                            ),
                            InkWell(
                              onTap: () {
                                FlutterRingtonePlayer.stop();
                                audioPlayer.stop();

                                rejectCall();
                                Get.back();
                              },
                              child: Container(
                                  height: 75,
                                  width: 75,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(37.5)),
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
          )
          : Container(),
    );
  }

  bool UserNotification() {
    FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print('Patient RoomId' + message!.data.toString());

      if (message.notification!.title != null) {
        if (this.mounted) {
          setState(() {
            var noti = message.notification!.title.toString();
            print("noti:" + message.notification.toString());
            print("noti:" + noti);
            if (message.notification!.android!.tag == "accept") {
              setState(() {
                UserNotification() == true;
              });
              Navigator.pop(context);
              // VideoConstant.joinMeeting("RoomID2022",Constant.name,widget.user['token']);
            } else if (message.notification!.android!.tag == "reject") {
              // Fluttertoast.showToast(
              //     msg: 'Rejected',
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 3,
              //     backgroundColor: Colors.black45,
              //     textColor: Colors.white,
              //     fontSize: 16.0);
              //                         FlutterRingtonePlayer.stop();

              Navigator.pop(context);
            }
            var receivername = message.data.values.last.toString();
            print('Receiver Name ${receivername}');
            Navigator.pop(context);
          });
        }
      }
    });
    return false;

  }

  @override
  void dispose() {
    print('SamplePage Called Dispose Method');
    audioPlayer.stop();
    // TODO: implement dispose
    super.dispose();
    FlutterRingtonePlayer.stop();
  }

}
