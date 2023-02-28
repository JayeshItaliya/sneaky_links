import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import '../Components/constants.dart';
import '../calling/agora.config.dart' as config;
import 'package:http/http.dart'as http;

/// JoinChannelAudio Example
class JoinChannelAudio extends StatefulWidget {
  /// Construct the [JoinChannelAudio]
  const JoinChannelAudio({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelAudio> {
  late final RtcEngine _engine;
  String channelId = Constant.channel;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;
  bool _enableInEarMonitoring = false;
  double _recordingVolume = 100,
      _playbackVolume = 100,
      _inEarMonitoringVolume = 100;
  late TextEditingController _controller;
  // bool call = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: channelId);
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(Constant.AppId));
    _addListeners();

    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    _joinChannel();

  }

  void _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        print('warning $warningCode');
      },
      error: (errorCode) {
        print('error $errorCode');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        // call=!call;

        print('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      leaveChannel: (stats) async {
        print('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
        });
      },
        userOffline:(ind,user){
          setState(() {
            isJoined = false;
          });
          _leaveChannel();
        }

    ));
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    await _engine
        .joinChannel(Constant.Token, _controller.text, null, config.uid)
        .catchError((onError) {
      print('error ${onError.toString()}');
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      isJoined = false;
      openMicrophone = true;
      enableSpeakerphone = true;
      playEffect = false;
      _enableInEarMonitoring = false;
      _recordingVolume = 100;
      _playbackVolume = 100;
      _inEarMonitoringVolume = 100;
    });
    rejectCall();
    Get.back();
  }

  _switchMicrophone() async {
    // await _engine.muteLocalAudioStream(!openMicrophone);
    await _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      print('enableLocalAudio $err');
    });
  }

  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      print('setEnableSpeakerphone $err');
    });
  }

  _switchEffect() async {
    if (playEffect) {
      _engine.stopEffect(1).then((value) {
        setState(() {
          playEffect = false;
        });
      }).catchError((err) {
        print('stopEffect $err');
      });
    } else {
      final path =
          (await _engine.getAssetAbsolutePath("assets/Sound_Horizon.mp3"))!;
      _engine.playEffect(1, path, 0, 1, 1, 100, openMicrophone).then((value) {
        setState(() {
          playEffect = true;
        });
      }).catchError((err) {
        print('playEffect $err');
      });
    }
  }

  _onChangeInEarMonitoringVolume(double value) async {
    _inEarMonitoringVolume = value;
    await _engine.setInEarMonitoringVolume(_inEarMonitoringVolume.toInt());
    setState(() {});
  }

  _toggleInEarMonitoring(value) async {
    _enableInEarMonitoring = value;
    await _engine.enableInEarMonitoring(_enableInEarMonitoring);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserNotification()
          ?Container():Stack(

        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top:MediaQuery.of(context).size.height/15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl:  Constant.profilePicture,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/discover.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/18,
                  ),
                  Text(Constant.username,style: TextStyle(fontSize: 20),),

                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ElevatedButton(
                    //   onPressed: _switchMicrophone,
                    //   child: Text('Microphone ${openMicrophone ? 'on' : 'off'}'),
                    // ),
                    // ElevatedButton(
                    //   onPressed: isJoined ? _switchSpeakerphone : null,
                    //   child:
                    //       Text(enableSpeakerphone ? 'Speakerphone' : 'Earpiece'),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:50.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RawMaterialButton(
                              // onPressed: _onToggleMute,
                              onPressed: (){
                                _switchMicrophone();
                              },

                              child: Icon(
                                openMicrophone ? Icons.mic:Icons.mic_off ,
                                color: openMicrophone ? Colors.white : Colors.blueAccent,
                                size: 20.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: openMicrophone ? Colors.blueAccent : Colors.white,
                              padding: const EdgeInsets.all(12.0),
                            ),
                            RawMaterialButton(
                              // onPressed: () => _onCallEnd(context),
                              onPressed: () => {
                                _leaveChannel()
                              },
                              child: Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.redAccent,
                              padding: const EdgeInsets.all(15.0),
                            ),
                            RawMaterialButton(
                              // onPressed: _onSwitchCamera,
                              onPressed: (){
                                _switchSpeakerphone();
                              },
                              child: enableSpeakerphone?Icon(
                                Icons.volume_up_sharp,
                                color: Colors.blueAccent,
                                size: 20.0,
                              ):Icon(
                                Icons.volume_off_sharp,
                                color: Colors.blueAccent,
                                size: 20.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(12.0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // if (!kIsWeb)
                    //   ElevatedButton(
                    //     onPressed: isJoined ? _switchEffect : null,
                    //     child: Text('${playEffect ? 'Stop' : 'Play'} effect'),
                    //   ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     const Text('RecordingVolume:'),
                    //     Slider(
                    //       value: _recordingVolume,
                    //       min: 0,
                    //       max: 400,
                    //       divisions: 5,
                    //       label: 'RecordingVolume',
                    //       onChanged: isJoined
                    //           ? (double value) {
                    //               setState(() {
                    //                 _recordingVolume = value;
                    //               });
                    //               _engine
                    //                   .adjustRecordingSignalVolume(value.toInt());
                    //             }
                    //           : null,
                    //     )
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     const Text('PlaybackVolume:'),
                    //     Slider(
                    //       value: _playbackVolume,
                    //       min: 0,
                    //       max: 400,
                    //       divisions: 5,
                    //       label: 'PlaybackVolume',
                    //       onChanged: isJoined
                    //           ? (double value) {
                    //               setState(() {
                    //                 _playbackVolume = value;
                    //               });
                    //               _engine
                    //                   .adjustPlaybackSignalVolume(value.toInt());
                    //             }
                    //           : null,
                    //     )
                    //   ],
                    // ),
                    // Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Row(mainAxisSize: MainAxisSize.min, children: [
                    //       const Text('InEar Monitoring Volume:'),
                    //       Switch(
                    //         value: _enableInEarMonitoring,
                    //         onChanged: isJoined ? _toggleInEarMonitoring : null,
                    //         activeTrackColor: Colors.grey[350],
                    //         activeColor: Colors.white,
                    //       )
                    //     ]),
                    //     if (_enableInEarMonitoring)
                    //       SizedBox(
                    //           width: 300,
                    //           child: Slider(
                    //             value: _inEarMonitoringVolume,
                    //             min: 0,
                    //             max: 100,
                    //             divisions: 5,
                    //             label:
                    //                 'InEar Monitoring Volume $_inEarMonitoringVolume',
                    //             onChanged: isJoined
                    //                 ? _onChangeInEarMonitoringVolume
                    //                 : null,
                    //           ))
                    //   ],
                    // ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              )),

        ],
      ),
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


}
