import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/ProfileScreen/subscribe.dart';
import 'package:sneaky_links/Pages/message/autoDeleteIntervals.dart';
import 'package:sneaky_links/Pages/message/photoView.dart';
import 'package:sneaky_links/Pages/message/report.dart';
import 'package:sneaky_links/Pages/message/attachments.dart';
import 'package:sneaky_links/Services/googleser.dart';
import 'package:sneaky_links/calling/join_channel_audio.dart';
import 'package:sneaky_links/controllers/chat_controller.dart';
import 'package:sneaky_links/controllers/network_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:video_compress/video_compress.dart';
import '../../Models/chatModel.dart';
import '../../Services/api_repository.dart';
import '../../calling/join_channel_video.dart';

class Chat extends StatefulWidget {
  final Map<String, dynamic> data;

  const Chat({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  final socketController = Get.put(NetworkController());

  // final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  TextEditingController? _messageController = TextEditingController();
  TextEditingController? reportController = TextEditingController();
  final myController = Get.put(ChatController());
  FocusNode focusNode = FocusNode();
  bool sendChatButton = false;
  bool sendAudioButton = true;
  bool showEmoji = false;
  int status = 1;
  var timetemp = 0;
  late String filePath;
  late FlutterVideoCompress _flutterVideoCompress = FlutterVideoCompress();
  bool _validateError = false;

  bool checkMSG() {
    if (Constant.plan_active == 1) {
      if (Constant.current_plan == "FREE") {
        if (message_exp < 5) {
          setState(() {
            message_exp++;
          });
          pref.setInt(Constant.user_id + "message_exp", message_exp);
          receipt_dataSave().then((value) {
          });
          return true;
        } else {
          setState(() {
            _messageController!.text = '';
          });
          // showLongToast("Plan Expire");
          Get.defaultDialog(
            title: Constant.titleText,
            radius: 30,
            barrierDismissible: false,
            content:Column(
              children: [
                Column(
                  children:   [
                    const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        backgroundImage:AssetImage("assets/images/logo.png",)
                    ),
                    const SizedBox(height: 10,),
                    Text(Constant.description,textAlign:TextAlign.center,)
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed:(){
                          Get.back();
                        },
                        child:const Text("Later")
                    ),
                    ElevatedButton(
                        onPressed:(){
                          Get.back();
                          Get.to(subscribe());
                        },
                        child:const Text("Upgrade")
                    )
                  ],
                )
              ],
            ),
          );
          return false;
        }
      } else {
        return true;
      }
    } else {
      showLongToast("Expire Plan");
      return false;
    }
  }

  void _sendMessage() {
    if (checkMSG()) {
      String messageText = _messageController!.text.trim();

      setState(() {
        _messageController!.text = '';
      });
      print(messageText + widget.data['id'].toString());
      if (messageText != '') {
        var messagePost = {
          "message": messageText,
          "messageType": "0",
          "receiverId": widget.data['id'],
        };
        socketController.socket.emit('private message', messagePost);
        getData();
      }
    }
  }

  void _sendAudioMessage(url) {
    if (checkMSG()) {
      String messageText = _messageController!.text.trim();

      setState(() {
        _messageController!.text = '';
      });

      var messagePost = {
        "message": messageText,
        "messageType": "3",
        "receiverId": widget.data['id'],
        "media": url,
      };

      socketController.socket.emit('private message', messagePost);
      getData();
    }
  }

  var isText = true;

  void _sendPdfMessage(fileurl) {
    if (checkMSG()) {
      String messageText = _messageController!.text.trim();

      setState(() {
        _messageController!.text = '';
      });

      var messagePost = {
        "message": messageText,
        "messageType": "4",
        "receiverId": widget.data['id'],
        "media": fileurl,
      };
      socketController.socket.emit('private message', messagePost);
      getData();
    }
  }

  void _sendDocMessage(fileurl) {
    if (checkMSG()) {
      String messageText = _messageController!.text.trim();

      setState(() {
        _messageController!.text = '';
      });
      var messagePost = {
        "message": messageText,
        "messageType": "5",
        "receiverId": widget.data['id'],
        "media": fileurl,
      };
      socketController.socket.emit('private message', messagePost);
      getData();
    }
  }

  void _sendImagesMessage(imgurl) {
    if (checkMSG()) {
      String messageText = _messageController!.text.trim();

      setState(() {
        _messageController!.text = '';
      });
      var messagePost = {
        "message": messageText,
        "messageType": "1",
        "receiverId": widget.data['id'],
        "media": imgurl,
      };
      socketController.socket.emit('private message', messagePost);
      getData();
    }
  }

  void _sendVideoMessage(videourl, imgurl) {
    if (checkMSG()) {
      String messageText = _messageController!.text.trim();

      setState(() {
        _messageController!.text = '';
      });
      var messagePost = {
        "message": messageText,
        "messageType": "2",
        "receiverId": widget.data['id'],
        "media": videourl,
        "mediaThumbnail": imgurl,
      };
      socketController.socket.emit('private message', messagePost);
      getData();
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Future<void> onJoin(type) async {
    // update input validation
    setState(() {
      Constant.channel.isEmpty ? _validateError = true : _validateError = false;
    });
    if (Constant.channel.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      /* await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channelController,
            // role: ClientRole.Broadcaster,
          ),
        ),
      );*/

      print(type);
      type == "Video" ? Get.to(JoinChannelVideo()) : Get.to(JoinChannelAudio());
    }
  }

  Future updateToken(type) async {
    // EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.rtctoken));
      request.body = json.encode(
          {"isPublisher": true, "receiverId": widget.data['id'], "type": type});
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        print(jsonBody['data'].toString());
        setState(() {
          Constant.Token = jsonBody['data']['token'];
          Constant.channel = jsonBody['data']['channel'];
          Constant.profilePicture = widget.data['image'];
          Constant.username = widget.data['user'];
          Constant.senderId = widget.data['id'];
          // Constant.Uid = jsonBody['data']['uid'];
          print("Token : " + Constant.Token);
          print("Uid : " + Constant.Uid.toString());
          print("Channel : " + Constant.channel);
          print("Channel : " + Constant.username);
        });
        onJoin(type);
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _flutterVideoCompress = FlutterVideoCompress();
    getData();
    _messageController = TextEditingController();
    initSocket();
    startIt();
  }

  late SharedPreferences pref;
  int message_exp = 0;

  getData() async {
    pref = await SharedPreferences.getInstance();
    message_exp = pref.getInt(Constant.user_id + "message_exp") ?? 0;
    myController.updateData(widget.data['id'], "");
  }

  Future<void> initSocket() async {
    socketController.socket.on('private message', (message) {
      getData();
      var messagePost = {
        "senderId": Constant.user_id,
        "receiverId": widget.data['id'],
      };
      socketController.socket.emit('read message', messagePost);
    });

    socketController.socket.on('status online', (message) {
      print(message);
      try {
        setState(() {
          status = message['isOnline'] ?? 0;
          timetemp = message['lastSeenAt'].toString() == "null"
              ? 0
              : message['lastSeenAt'];
        });
      } catch (e) {
        printError(info: e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    return WillPopScope(
      onWillPop: () async {
        bool? result = true;
        Get.back(result: "data");
        return result;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leadingWidth: 120,
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Get.back(result: 'data');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back(result: 'data');
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    getHorizontalSize(
                      25.08,
                    ),
                  ),
                  child: widget.data['image'] == ""
                      ? Image.asset(
                          "assets/images/discover.png",
                          height: getSize(
                            50.06,
                          ),
                          width: getSize(
                            50.06,
                          ),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: "${widget.data['image']}",
                          height: getSize(
                            50.06,
                          ),
                          width: getSize(
                            50.06,
                          ),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/discover.png",
                            height: getSize(
                              50.06,
                            ),
                            width: getSize(
                              50.06,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ],
            ),
          ),
          title: Container(
            margin: EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.data['user']}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
                Text(
                    status == 1
                        ? "Online "
                        : "Offline ${timetemp == 0 ? "" : "- ${readTimestamp(timetemp)}"}",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 12)),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                updateToken("Audio");
              },
              icon: Icon(Icons.call),
              color: Colors.pinkAccent,
              iconSize: 25,
            ),
            IconButton(
              onPressed: () {
                var data = {
                  'id': "RoomId" + widget.data['id'],
                  'name': widget.data['user'],
                  'image': widget.data['image'],
                  'token': widget.data['token'],
                };
                updateToken("Video");

                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => RingPage(data)));
              },
              icon: Icon(Icons.videocam_outlined),
              color: Colors.pinkAccent,
              iconSize: 29,
            ),
            PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.pinkAccent,
                  size: 30,
                ),
                onSelected: (value) {
                  print(value);
                },
                itemBuilder: (BuildContext context) {
                  return [
                    if (Constant.plan_active == 0)
                      ...[]
                    else if (Constant.current_plan == "DIAMOND") ...[
                      PopupMenuItem(
                        child: InkWell(
                          onTap: () {
                            Get.back();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AutoDeleteScreen(
                                        id: widget.data['id'],
                                      )),
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                "Auto Delete Intervals",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ColorConstant.black900,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        value: "Auto Delete Intervals",
                      ),
                    ],
                    PopupMenuItem(
                      child: InkWell(
                        onTap: () {
                          Get.back();

                          AlertDelete(widget.data['id']);
                        },
                        child: Container(
                          width: double.infinity,
                          // color: Colors.red,

                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(
                            "Block User",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: ColorConstant.black900,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ),
                      value: "Block",
                    ),
                    PopupMenuItem(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(Report(widget.data['id']));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              // color: Colors.red,
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: Text(
                                "Report User",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ColorConstant.black900,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: "Report",
                    ),
                  ];
                })
          ],
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Obx(
                  () => ListView.builder(
                    controller: myController.scrollController,
                    itemCount: myController.myList.length,
                    shrinkWrap: true,
                    reverse: true,
                    padding: EdgeInsets.only(
                        top: 10,
                        bottom: MediaQuery.of(context).size.height / 10),
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      ChatModel item = myController.myList[index];
                      return Stack(children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 12, bottom: 23),
                          child: Align(
                            alignment:
                                item.receiverId.toString() == Constant.user_id
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (item.receiverId.toString() ==
                                          Constant.user_id
                                      ? Color(0xFFD3D2D2)
                                      : Color(0xFF25D366)),
                                ),
                                padding: item.messageType == 1
                                    ? EdgeInsets.all(10)
                                    : EdgeInsets.all(13),
                                child: item.messageType == 0
                                    ? Text(
                                        item.message,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                          color: (item.receiverId.toString() ==
                                                  Constant.user_id
                                              ? Colors.black
                                              : Colors.white),
                                        ),
                                      )
                                    : item.messageType == 1
                                        ? SizedBox(
                                            width: 250,
                                            height: 250,
                                            // aligment:Aligment.center,
                                            child: InkWell(
                                              onTap: () {
                                                // _asyncMethod(Uri.parse(item.media));
                                                print("Hello");
                                                Get.to(PView(
                                                    item.media,
                                                    item.messageId.toString(),
                                                    widget.data['user']));
                                              },
                                              child: Hero(
                                                tag: item.messageId.toString(),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: item.media,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : item.messageType == 2
                                            ? InkWell(
                                                onTap: () {
                                                  openUrl(item.media);

                                                  // Get.to(ChewieDemo(url:
                                                  // item.media,
                                                  // ));
                                                },
                                                child: Container(
                                                  width: 200,
                                                  height: 220,
                                                  child: Stack(
                                                    children: [
                                                      SizedBox(
                                                        width: 200,
                                                        height: 220,
                                                        // aligment:Aligment.center,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: item
                                                              .mediaThumbnail,
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                          Icons.play_circle,
                                                          color: (item.receiverId
                                                                      .toString() ==
                                                                  Constant
                                                                      .user_id
                                                              ? Colors.black
                                                              : Colors.white),
                                                          size: 50,
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   color: Colors.red,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : item.messageType == 3
                                                ? Attachments(item.media)
                                                : item.messageType == 4 ||
                                                        item.messageType == 5
                                                    ? InkWell(
                                                        onTap: () {
                                                          openUrl(item.media);
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.6,
                                                          child: ListTile(
                                                            leading: Icon(
                                                              Icons.file_copy,
                                                              color: (item.receiverId
                                                                          .toString() ==
                                                                      Constant
                                                                          .user_id
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white),
                                                            ),
                                                            title: Text(
                                                              item.message,
                                                              style: TextStyle(
                                                                color: (item.receiverId
                                                                            .toString() ==
                                                                        Constant
                                                                            .user_id
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Text(
                                                        item.message,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Roboto',
                                                          color: (item.receiverId
                                                                      .toString() ==
                                                                  Constant
                                                                      .user_id
                                                              ? Colors.black
                                                              : Colors.white),
                                                        ),
                                                      )),
                          ),
                        ),
                        item.receiverId.toString() == Constant.user_id
                            ? Positioned(
                                child: Icon(
                                  Icons.circle,
                                  color: Color(0xFFD3D2D2),
                                  size: 13,
                                ),
                                bottom: 17,
                                left: 11,
                              )
                            : Positioned(
                                child: Icon(
                                  Icons.circle,
                                  color: Color(0xFF25D366),
                                  size: 13,
                                ),
                                bottom: 17,
                                right: 11,
                              ),
                        item.receiverId.toString() == Constant.user_id
                            ? Positioned(
                                bottom: 0,
                                left: 29,
                                child: Text(
                                    "${(DateFormat("d MMMM yyyy").format(DateTime.now()) == datTime1(item.createdAt) ? 'Today' : (DateFormat("d MMMM yyyy").format(DateTime.now().subtract(Duration(days: 1))) == datTime1(item.createdAt)) ? 'Yesterday' : datTime1(item.createdAt))}, ${datTime2(item.createdAt)}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    )),
                              )
                            : Positioned(
                                bottom: 0,
                                right: 29,
                                child: Text(
                                    "${(DateFormat("d MMMM yyyy").format(DateTime.now()) == datTime1(item.createdAt) ? 'Today' : (DateFormat("d MMMM yyyy").format(DateTime.now().subtract(Duration(days: 1))) == datTime1(item.createdAt)) ? 'Yesterday' : datTime1(item.createdAt))}, ${datTime2(item.createdAt)}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    )),
                              ),
                      ]);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                sendAudioButton
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                55,
                                        child: Card(
                                          margin: const EdgeInsets.only(
                                              left: 2, right: 2, bottom: 8),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: TextFormField(
                                            onTap: () {
                                              emojiShowing = false;
                                            },
                                            controller: _messageController,
                                            focusNode: focusNode,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 1,
                                            minLines: 1,
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                setState(() {
                                                  sendChatButton = true;
                                                });
                                              } else {
                                                setState(() {
                                                  sendChatButton = false;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                                // fillColor: Colors.lightBlueAccent,
                                                border: InputBorder.none,
                                                hintText:
                                                    "Type your message here",
                                                suffixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          showGeneralDialog(
                                                            barrierDismissible:
                                                                true,
                                                            context: context,
                                                            barrierLabel:
                                                                "Barrier",
                                                            barrierColor: Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.5),
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            pageBuilder:
                                                                (_, __, ___) {
                                                              return Container(
                                                                margin: EdgeInsets.only(
                                                                    left: 30,
                                                                    right: 30,
                                                                    top: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        1.9,
                                                                    bottom: 80),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: ColorConstant
                                                                      .whiteA700,
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        blurRadius:
                                                                            1,
                                                                        color: Colors
                                                                            .grey,
                                                                        spreadRadius:
                                                                            0.2)
                                                                  ],
                                                                ),
                                                                child: ListView(
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      const ClampingScrollPhysics(),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  children: [
                                                                    Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                          left:
                                                                              25.0,
                                                                          top:
                                                                              41.0,
                                                                          right:
                                                                              25.0,
                                                                          bottom:
                                                                              41.0,
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Wrap(
                                                                              // mainAxisAlignment:MainAxisAlignment.center,
                                                                              children: [
                                                                                Card(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 16.0),
                                                                                    child: InkWell(
                                                                                      onTap: () async {
                                                                                        _getVideoThumbnail();
                                                                                      },
                                                                                      child: Container(
                                                                                        color: Colors.pinkAccent,
                                                                                        height: 50,
                                                                                        width: 70,
                                                                                        child: Center(
                                                                                          child: Column(
                                                                                            children: const [
                                                                                              Icon(Icons.ondemand_video, color: Colors.white),
                                                                                              Text(
                                                                                                "Video",
                                                                                                style: TextStyle(fontSize: 13, color: Colors.white),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),

                                                                                      // child: Column(
                                                                                      //   children: const [
                                                                                      //     Icon(Icons.add_photo_alternate_outlined),
                                                                                      //     Text("Gallery")
                                                                                      //   ],
                                                                                      // ),
                                                                                    ),
                                                                                  ),
                                                                                  color: Colors.pinkAccent,
                                                                                ),
                                                                                Card(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 16.0),
                                                                                    child: InkWell(
                                                                                      onTap: () async {
                                                                                        photo = await _picker.pickImage(source: ImageSource.gallery);
                                                                                        image = File(photo!.path);
                                                                                        Navigator.of(context).pop();
                                                                                        setState(() {
                                                                                          _messageController!.text = image!.path.split('/').last;
                                                                                        });
                                                                                        updateImage('1', 'image/jpeg', image!.path);

                                                                                        // Navigator.of(context).pop();
                                                                                      },
                                                                                      child: Container(
                                                                                        color: Colors.pinkAccent,
                                                                                        height: 50,
                                                                                        width: 70,
                                                                                        child: Center(
                                                                                          child: Column(
                                                                                            children: const [
                                                                                              Icon(Icons.image, color: Colors.white),
                                                                                              Text(
                                                                                                "Gallery",
                                                                                                style: TextStyle(fontSize: 13, color: Colors.white),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),

                                                                                      // child: Column(
                                                                                      //   children: const [
                                                                                      //     Icon(Icons.add_photo_alternate_outlined),
                                                                                      //     Text("Gallery")
                                                                                      //   ],
                                                                                      // ),
                                                                                    ),
                                                                                  ),
                                                                                  color: Colors.pinkAccent,
                                                                                ),
                                                                                Card(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 16.0),
                                                                                    child: InkWell(
                                                                                      onTap: () async {
                                                                                        photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 650, maxHeight: 250);
                                                                                        image = File(photo!.path);
                                                                                        Navigator.of(context).pop();
                                                                                        setState(() {
                                                                                          _messageController!.text = image!.path.split('/').last;
                                                                                        });
                                                                                        updateImage('1', 'image/jpeg', image!.path);
                                                                                      },
                                                                                      child: Container(
                                                                                        color: Colors.pinkAccent,
                                                                                        height: 50,
                                                                                        width: 70,
                                                                                        child: Center(
                                                                                          child: Column(
                                                                                            children: const [
                                                                                              Icon(Icons.linked_camera_rounded, color: Colors.white),
                                                                                              Text(
                                                                                                "Camera",
                                                                                                style: TextStyle(fontSize: 13, color: Colors.white),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  color: Colors.pinkAccent,
                                                                                ),
                                                                                Card(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 16.0),
                                                                                    child: InkWell(
                                                                                      onTap: () async {
                                                                                        filePicker();
                                                                                        // photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 650, maxHeight: 250);
                                                                                        // image = File(photo!.path);
                                                                                        // Navigator.of(context).pop();
                                                                                        // updateImage('1', 'image/jpeg', image!.path);
                                                                                      },
                                                                                      child: Container(
                                                                                        color: Colors.pinkAccent,
                                                                                        height: 50,
                                                                                        width: 70,
                                                                                        child: Center(
                                                                                          child: Column(
                                                                                            children: const [
                                                                                              Icon(
                                                                                                Icons.file_copy_outlined,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                              Text(
                                                                                                "Document",
                                                                                                style: TextStyle(fontSize: 13, color: Colors.white),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  color: Colors.pinkAccent,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            // const SizedBox(
                                                                            //   height: 20,
                                                                            // ),
                                                                            // Row(
                                                                            //   children: [
                                                                            //     Expanded(
                                                                            //       child: Container(
                                                                            //         width: 200,
                                                                            //         child: Center(
                                                                            //           child: FloatingActionButton(
                                                                            //             shape: RoundedRectangleBorder(
                                                                            //               borderRadius: BorderRadius.all(
                                                                            //                 Radius.circular(7),
                                                                            //               ),
                                                                            //             ),
                                                                            //             onPressed: () async {
                                                                            //               filePicker();
                                                                            //             },
                                                                            //             child: Column(
                                                                            //               children: const [
                                                                            //                 Icon(Icons.mic_none_rounded),
                                                                            //                 Text("Document")
                                                                            //               ],
                                                                            //             ),
                                                                            //           ),
                                                                            //         ),
                                                                            //       ),
                                                                            //     ),
                                                                            //     Expanded(child: Container()),
                                                                            //     Expanded(child: Container()),
                                                                            //   ],
                                                                            // )
                                                                          ],
                                                                        ))
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            transitionBuilder:
                                                                (_, anim, __,
                                                                    child) {
                                                              Tween<Offset>
                                                                  tween;
                                                              if (anim.status ==
                                                                  AnimationStatus
                                                                      .reverse) {
                                                                tween = Tween(
                                                                  begin: Offset(
                                                                      1, 0),
                                                                  end: Offset(
                                                                      0, 0),
                                                                );
                                                              } else {
                                                                tween = Tween(
                                                                  begin: Offset(
                                                                      1, 0),
                                                                  end: Offset(
                                                                      0, 0),
                                                                );
                                                              }

                                                              return SlideTransition(
                                                                position: tween
                                                                    .animate(
                                                                        anim),
                                                                child:
                                                                    FadeTransition(
                                                                  opacity: anim,
                                                                  child: child,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.attach_file,
                                                          color: Colors.black,
                                                        )),
                                                    IconButton(
                                                        onPressed: () async {
                                                          photo = await _picker
                                                              .pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .camera,
                                                                  imageQuality:
                                                                      70,
                                                                  maxWidth: 650,
                                                                  maxHeight:
                                                                      250);

                                                          image =
                                                              File(photo!.path);

                                                          setState(() {
                                                            _messageController!
                                                                    .text =
                                                                image!.path
                                                                    .split('/')
                                                                    .last;
                                                          });
                                                          updateImage(
                                                              '1',
                                                              'image/jpeg',
                                                              image!.path);
                                                          // Navigator.of(context).pop();
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          color: Colors.black,
                                                        ))
                                                  ],
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(2),
                                                prefixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        sendChatButton = true;
                                                        focusNode.unfocus();
                                                        emojiShowing =
                                                            !emojiShowing;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.emoji_emotions))
                                                // prefixIcon:IconButton(
                                                //   icon:showEmoji?Icon(Icons.keyboard_alt):Icon(Icons.emoji_emotions),
                                                //   onPressed: () {
                                                //     setState(() {
                                                //       focusNode.unfocus();
                                                //       showEmoji = !showEmoji;
                                                //     });
                                                //   },
                                                // )
                                                ),
                                          ),
                                        ))
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                55,
                                        child: Card(
                                            margin: EdgeInsets.only(
                                                left: 2, right: 2, bottom: 8),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: TextFormField(
                                              controller: _messageController,
                                              focusNode: focusNode,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 5,
                                              minLines: 1,
                                              showCursor: false,
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  setState(() {
                                                    sendChatButton = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    sendChatButton = false;
                                                  });
                                                }
                                              },
                                              decoration: InputDecoration(
                                                fillColor:
                                                    Colors.lightBlueAccent,

                                                border: InputBorder.none,
                                                // hintText: "Type your message here",
                                                suffixIcon: Row(
                                                  // mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.mic,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                            child: Center(
                                                                child:
                                                                    buildTime())),
                                                      ],
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            print("Helwocdksdskh timer");

                                                            stopTimer();
                                                            stopRecord();
                                                            _messageController!.text="";
                                                            sendChatButton =
                                                                false;
                                                            sendAudioButton =
                                                                true;
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors.black,
                                                        )),
                                                    // IconButton(
                                                    //     onPressed: () {},
                                                    //     icon: Icon(
                                                    //       Icons.camera_alt_outlined,
                                                    //       color: Colors.black,
                                                    //     ))
                                                  ],
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(5),
                                                // prefixIcon: IconButton(
                                                //   icon: Icon(showEmoji
                                                //       ? Icons.keyboard
                                                //       : Icons.emoji_emotions_outlined,color: Colors.black,),
                                                //   onPressed: () {
                                                //     // if (!showEmoji) {
                                                //     //   focusNode.unfocus();
                                                //     //   focusNode.canRequestFocus = false;
                                                //     // }
                                                //     //
                                                //     // setState(() {
                                                //     //   showEmoji = !showEmoji;
                                                //     // });
                                                //   },
                                                // )
                                              ),
                                            ))),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 2),
                                  child: InkWell(
                                    onTap: () {
                                      print("Hey asbgjdasd");
                                      _sendMessage();
                                    },
                                    child: sendChatButton
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.pink,
                                            child: IconButton(
                                                onPressed: () {
                                                  if (sendAudioButton ==
                                                      false) {
                                                    stopTimer();
                                                    stopRecord();
                                                    updateImage("3",
                                                        "audio/wav", filePath);
                                                  } else {
                                                    _sendMessage();
                                                  }

                                                  setState(() {
                                                    sendAudioButton = true;
                                                    sendChatButton = false;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                )),
                                          )
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.pink,
                                            child: IconButton(
                                                onPressed: () async {
                                                  // checkPermission();
                                                  checkpermission_opencamera();
                                                },
                                                icon: Icon(
                                                  Icons.mic,
                                                  color: Colors.white,
                                                )),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            // showEmoji ? emojiSelect() : Container(),
                          ],
                        ),
                      ),
                      emoji()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic datTime1(dtime) {
    return DateFormat("d MMM yyyy").format(datTime(dtime));
  }

  dynamic datTime2(dtime) {
    return DateFormat('hh:mm a').format(datTime(dtime));
  }

  DateTime datTime(dtime) {
    // return DateTime.fromMillisecondsSinceEpoch(dtime * 1000);
    return DateTime.fromMillisecondsSinceEpoch(
        int.parse(dtime.toString()) * 1000);
  }

  bool emojiShowing = false;
  Image? picker;
  File? image;
  XFile? photo;
  var value;
  List multipleImage = [];
  final ImagePicker _picker = ImagePicker();

  Widget emoji() {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2.4,
        child: EmojiPicker(
            onEmojiSelected: (category, Emoji emoji) {
              onEmojiSelected(emoji);
            },
            onBackspacePressed: onBackspacePressed,
            config: Config(
                columns: 7,
                emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                verticalSpacing: 0,
                horizontalSpacing: 0,
                // initCategory: Category.RECENT,
                bgColor: const Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                progressIndicatorColor: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                showRecentsTab: true,
                recentsLimit: 28,
                noRecents: const Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL)),
      ),
    );
  }

  onEmojiSelected(Emoji emoji) {
    _messageController!
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController!.text.length));
  }

  onBackspacePressed() {
    _messageController!
      ..text = _messageController!.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController!.text.length));
  }

  filePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      files.forEach((element) {
        setState(() {
          _messageController!.text = element.path.split('/').last;
        });
        if (p.extension(element.path) == ".pdf") {}
        if (element.path.contains(".pdf"))
          updateImage("4", 'application/pdf', element.path);
        else if (element.path.contains(".doc"))
          updateImage("5", 'application/msword', element.path);
        else if (element.path.contains(".docx"))
          updateImage("5", 'application/msword', element.path);
        else {
          setState(() {
            _messageController!.text = '';
          });
          showLongToast("Please Select Doc Or PDF File");
        }
      });
    }
    Get.back();
  }

  node() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        emojiShowing = false;
      }
    });
  }

  Timer? timer;
  bool isstarttimer = false;

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text('$minutes:$seconds', style: TextStyle(fontSize: 20));
  }

  void startTimer() {
    // if( timer!.isActive) {
    //   timer?.cancel;
    // }
    setState(() {
      isstarttimer = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = 1;
    setState(() {
      var seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  Future<void> stopTimer() async {
    print("Heklowww timer");
    setState(() {
      duration = Duration();
      isstarttimer = false;
      print(duration);
    });
    timer?.cancel();
  }

  void startIt() async {
    _myRecorder = FlutterSoundRecorder();

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final min = twoDigits(duration.inMinutes.remainder(60));
    final sec = twoDigits(duration.inSeconds.remainder(60));
    print(min);
    print(sec);

    await _myRecorder.openRecorder();
    await _myRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
  }

  late FlutterSoundRecorder _myRecorder;

  Future<void> record() async {
    String name = DateFormat("yyyyMMddHHmmss").format(DateTime.now());

    // filePath = '/sdcard/Download/temp.wav';

    filePath = '$name.wav';
    setState(() {
      _messageController!.text = filePath;
    });
    Directory dir;
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
      print(dir);

      if (!dir.existsSync()) {
        dir.createSync();
      }
    } else {
      dir = Directory("/storage/emulated/0/Download");
      if (!dir.existsSync()) {
        dir.createSync();
      }
    }
    _myRecorder.openRecorder();
    await _myRecorder.startRecorder(
      toFile: "${dir.path}/${filePath}",
    );
    filePath = "${dir.path}/${filePath}";
    startTimer();
    StreamSubscription _recorderSubscription =
        _myRecorder.onProgress!.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
    });
    _recorderSubscription.cancel();
  }

  Future updateVideo(mediaType, contentType, path, tpath) async {
    EasyLoading.show(status: "Loading...");

    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.updateImage));
      request.fields.addAll({
        'mediaType': mediaType,
        'folderName': 'chat-medias',
        'contentType': contentType
      });
      request.files.add(await http.MultipartFile.fromPath(
        'media',
        path,
      ));
      request.files
          .add(await http.MultipartFile.fromPath('mediaThumbnail', tpath));

      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("++++++++" + jsonBody.toString());

      if (response.statusCode == 200) {
        setState(() {
          _sendVideoMessage(
              jsonBody['data']['media'], jsonBody['data']['mediaThumbnail']);
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError(jsonBody['message']);
        print(jsonBody.toString());
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Future updateImage(mediaType, contentType, path) async {
    EasyLoading.show(status: "Loading...");

    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.updateImage));
      request.fields.addAll({
        'mediaType': mediaType,
        'folderName': 'chat-medias',
        'contentType': contentType
      });
      request.files.add(await http.MultipartFile.fromPath('media', path));
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        setState(() {
          print("Success");
          print(jsonBody['data']['media']);

          if (mediaType == "1") {
            _sendImagesMessage(jsonBody['data']['media']);
          } else if (mediaType == "3") {
            _sendAudioMessage(jsonBody['data']['media']);
          } else if (mediaType == "4") {
            _sendPdfMessage(jsonBody['data']['media']);
          } else if (mediaType == "5") {
            _sendDocMessage(jsonBody['data']['media']);
          }
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError(jsonBody['message']);
        print(jsonBody.toString());
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Future<String?> stopRecord() async {
    timer?.cancel();
    _myRecorder.closeRecorder();
    return await _myRecorder.stopRecorder();
  }

  checkpermission_opencamera() async {
    var photosStatus = await Permission.photos.status;
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;
    var StorageStatus = await Permission.storage.status;
    var manageExternalStorageStatus =
        await Permission.manageExternalStorage.status;
    // var microphoneStatus = await Permission.microphone.status;
    // print(cameraStatus);
    print(microphoneStatus);
    //cameraStatus.isGranted == has access to application
    //cameraStatus.isDenied == does not have access to application, you can request again for the permission.
    //cameraStatus.isPermanentlyDenied == does not have access to application, you cannot request again for the permission.
    //cameraStatus.isRestricted == because of security/parental control you cannot use this permission.
    //cameraStatus.isUndetermined == permission has not asked before.

    if (!photosStatus.isGranted) await Permission.photos.request();

    if (!cameraStatus.isGranted) await Permission.camera.request();

    if (!microphoneStatus.isGranted) await Permission.microphone.request();
    if (!StorageStatus.isGranted) await Permission.storage.request();
    if (!manageExternalStorageStatus.isGranted)
      await Permission.manageExternalStorage.request();

    if (await Permission.microphone.isGranted) {
      if (await Permission.storage.isGranted) {
        if (await Permission.manageExternalStorage.isGranted) {
          print("Permission granted");
        } else {}

        // openCamera();
        print("Permission granted");
        setState(() {
          sendChatButton = true;
          sendAudioButton = false;
          record();
        });
      } else {
        print(
            "Camera needs to access your microphone, please provide permission");
      }
    } else {
      print("Provide Camera permission to use camera.");
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  blockData(id) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.Request('POST', Uri.parse(Constant.getUsersId + '/block'));
      request.body = json.encode({"userId": id});
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        Get.back(result: "data");
      } else {
        print(response.reasonPhrase);
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  _getVideoThumbnail() async {
    try {
      var file;

      if (Platform.isMacOS) {
        final typeGroup =
            XTypeGroup(label: 'videos', extensions: ['mov', 'mp4']);
        file = await openFile(acceptedTypeGroups: [typeGroup]);
      } else {
        final picker = ImagePicker();
        PickedFile? pickedFile =
            await picker.getVideo(source: ImageSource.gallery);
        file = File(pickedFile!.path);
        print(file);
      }
      print("+++++++++++++++++" + file.toString());

      if (file != null) {
        // final info = await _flutterVideoCompress.compressVideo(
        //   file.path,
        //   deleteOrigin: false, // default(false)
        // );
        // print("+++++++++++++++++" + info.toJson().toString());
        var _thumbnailFile =
            // await VideoCompress.getFileThumbnail(info.toJson()['path']);
            await VideoCompress.getFileThumbnail(file.path);
        print("+++" + _thumbnailFile.path);

        // updateVideo(
        //     '2', 'video/mp4', info.toJson()['path'], _thumbnailFile.path);

        setState(() {
          _messageController!.text = file.path.split('/').last;
        });
        updateVideo('2', 'video/mp4', file.path, _thumbnailFile.path);

        Get.back();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  AlertDelete(id) async {
    final pref = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Block!"),
        content: new Text("Do You Want To Block The User?"),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                Get.back();
              },
              isDefaultAction: true,
              child: new Text("Cancel")),
          CupertinoDialogAction(
              onPressed: () {
                blockData(id);

                Get.back();
              },
              isDefaultAction: true,
              child: new Text(
                "Block",
                style: TextStyle(color: FlutterFlowTheme.primaryColor),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    // audioPlayer.dispose();
    _messageController!.dispose();
    // socket.disconnect();
    super.dispose();
  }
}
