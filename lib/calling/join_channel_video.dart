import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import '../calling/agora.config.dart' as config;

/// MultiChannel Example
class JoinChannelVideo extends StatefulWidget {
  const JoinChannelVideo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelVideo> {
  late final RtcEngine _engine;

  bool isJoined = false, switchCamera = true, switchRender = true;
  List<int> remoteUid = [];
  late TextEditingController _controller;
  bool _isRenderSurfaceView = false;
  bool muted = false;
  bool receiver = false;


  bool call11 = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: Constant.channel);
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  Future<void> _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(Constant.AppId));
    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);

    await _engine.setClientRole(ClientRole.Broadcaster);
    // _joinChannel();
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
        print('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        print('userJoined  $uid $elapsed');
        setState(() {
          call11=!call11;
          receiver = true;
          remoteUid.clear();
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        print('userOffline  $uid $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
          receiver = false;
          print('Hellooowo+++++++++++');
          _leaveChannel();

        });
      },
      leaveChannel: (stats) {
        print('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
          receiver = false;
          print('Hellooowo+++++++++++');
        });
      },
    ));
  }

  _joinChannel() async {
    print('Hellooowo');
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    await _engine.joinChannel(Constant.Token, Constant.channel, null, config.uid);
    // print("Token"+config.token);
    // print("Controller.text"+_controller.text);
    print("Config");
    print(config.uid);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
      print(muted);
      _engine.muteLocalAudioStream(muted);
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    rejectCall();
    Get.back();
  }


  _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      print('switchCamera $err');
    });
  }

  _switchRender() {
    setState(() {
      switchRender = !switchRender;
      remoteUid = List.of(remoteUid.reversed);
    });
    print("Heylloo Render");
  }

  @override
  Widget build(BuildContext context) {
    return UserNotification()
        ?Container():Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField(
            //   controller: _controller,
            //   decoration: const InputDecoration(hintText: 'Channel ID'),
            // ),
            // if (!kIsWeb &&
            //     (defaultTargetPlatform == TargetPlatform.android ||
            //         defaultTargetPlatform == TargetPlatform.iOS))
            //   Row(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       const Text(
            //           'Rendered by SurfaceView \n(default TextureView): '),
            //       Switch(
            //         value: _isRenderSurfaceView,
            //         onChanged: isJoined
            //             ? null
            //             : (changed) {
            //                 setState(() {
            //                   _isRenderSurfaceView = changed;
            //                 });
            //               },
            //       )
            //     ],
            //   ),

            // InkWell(
            //   onTap: (){
            //     _joinChannel();
            //   },
            //   child: Container(
            //     width:double.infinity,
            //     height:100,
            //     color: Colors.red,
            //     child: Text("Join it"),
            //   ),
            // ),

            _renderVideo(),
            // _joinChannel(),
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: ElevatedButton(
            //         onPressed: isJoined ? _leaveChannel : _joinChannel,
            //         child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
        // if (defaultTargetPlatform == TargetPlatform.android ||
        //     defaultTargetPlatform == TargetPlatform.iOS)
        //   Align(
        //     alignment: Alignment.bottomRight,
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         ElevatedButton(
        //           onPressed: _switchCamera,
        //           child: Text('Camera ${switchCamera ? 'front' : 'rear'}'),
        //         ),
        //       ],
        //     ),
        //   )
      ],
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

            var receivername = message.data.values.last.toString();
            print('Receiver Name ${receivername}');
            Navigator.pop(context);
          });
        }
      }
    });
    return false;
  }

  _renderVideo() {
    return Expanded(
      child: Stack(
        children: [

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: receiver?MediaQuery.of(context).size.height/2:MediaQuery.of(context).size.height,
              child: (kIsWeb || _isRenderSurfaceView)
                  ? const rtc_local_view.SurfaceView(
                zOrderMediaOverlay: true,
                zOrderOnTop: true,
              )
                  : const rtc_local_view.TextureView(),
            ),
          ),
          receiver == true? Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  // color: Colors.RED,
                  child: Row(
                    children: List.of(remoteUid.map(
                      (e) => GestureDetector(
                        onTap: () {
                          _switchRender();
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          child: (kIsWeb || _isRenderSurfaceView)
                              ? rtc_remote_view.SurfaceView(
                                  uid: e,
                                  channelId: _controller.text,
                                )
                              : rtc_remote_view.TextureView(
                                  uid: e,
                                  channelId: _controller.text,
                                ),
                        ),
                      ),
                    )),
                  ),
                ): Container(
                  // width: 200,
                  // height: 200,
                  // color: Colors.yellow,
                  // child: CircularProgressIndicator(),
                ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RawMaterialButton(
                    // onPressed: _onToggleMute,
                    onPressed: () {
                      _onToggleMute();
                    },

                    child: Icon(
                      muted ? Icons.mic_off : Icons.mic,
                      color: muted ? Colors.white : Colors.blueAccent,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: muted ? Colors.blueAccent : Colors.white,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  RawMaterialButton(
                    // onPressed: () => _onCallEnd(context),
                    onPressed: () => {_leaveChannel()},
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
                    onPressed: () {
                      _switchCamera();
                    },
                    child: Icon(
                      Icons.switch_camera,
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
          call11?SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top:MediaQuery.of(context).size.height/12,
              ),
              child: Column(
                children: [
                  Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl:  Constant.profilePicture,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/16,
                  ),
                  Text(Constant.username,style: TextStyle(fontSize: 20),),

                  Align(
                      alignment: Alignment.topCenter,
                      child: Text("Calling...",style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          // height: 0.6,
                          color: Colors.black
                      ),)),
                ],
              ),
            ),
          ):SizedBox(),
        ],
      ),
    );
  }
}
