import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/PartyModel.dart';
import 'package:sneaky_links/Models/PartyPostModel.dart';
import 'package:sneaky_links/Pages/RoomScreen/frame312_item_widget.dart';
import 'package:sneaky_links/Pages/RoomScreen/post.dart';
import 'package:sneaky_links/Pages/main_page.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/partypost_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import '../../Services/googleser.dart';
import '../DiscoverScreen/userProfileD.dart';

class InsideTheRoomWithoutCommentScreen extends StatefulWidget {
  // PartyModel item;
  String roomId;
  // String roomName;

  InsideTheRoomWithoutCommentScreen(this.roomId);

  @override
  State<InsideTheRoomWithoutCommentScreen> createState() =>
      _InsideTheRoomWithoutCommentScreenState();
}

class _InsideTheRoomWithoutCommentScreenState
    extends State<InsideTheRoomWithoutCommentScreen> {
  final myController = Get.put(PartyPostController());
  final postController = TextEditingController();
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  PartyModel? item;
  bool isloading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getData1();
  }

  getData() async {
    myController.updateData(int.parse(widget.roomId));
  }

  getData1() {
    getRoomDetails(widget.roomId).then((value) {
      if (value != null) {
        setState(() {
          item = value;
          isloading=false;
          debugPrint(item!.toJson().toString());
          // debugPrint(selectedValue2 = userdata.height.toString().substring(userdata.height.toString().indexOf('.')+1,userdata.height.toString().length+1));
        });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = true;
        if(widget.roomId=="109"){
          Get.offAll(NavBarPage(currentPage: 'DiscoverScreen',));
        }
        else
        Get.back(result: "data");
        return result;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.whiteA700,
          appBar: AppBar(
            backgroundColor: ColorConstant.whiteA700,
            elevation: 0.0,
            leadingWidth: 100,
            leading: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if(widget.roomId=="109"){
                      Get.offAll(NavBarPage(currentPage: 'DiscoverScreen',));
                    }
                    else
                    Get.back(result: "data");
                  },
                  icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                ),
                InkWell(
                  onTap: (){
                    Get.to(InsideTheRoomWithoutCommentScreen("109"));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Image.asset(
                      "assets/images/slp.png",
                      height: 40,
                      width: 40,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              "${isloading?"":item!.roomName}",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: FlutterFlowTheme.black,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            myController.leave(widget.roomId);
                          },
                          child: Text("Leave Party"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          onTap: () {
                            onShareData(
                                "Party Share link https://www.sneakylinks.com/rooms/${widget.roomId}");
                          },
                          child: Text("Invite Friends"),
                          value: 2,
                        )
                      ]),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              color: ColorConstant.whiteA700,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isloading?Center(child: CircularProgressIndicator()):
                Expanded(
                  flex: 1,
                  child:  RefreshIndicator(
                    onRefresh: ()async{
                      getData();
                    },
                    child: SingleChildScrollView(
                      controller:
                      myController.scrollController,
                      padding: EdgeInsets.only(
                        top: getVerticalSize(
                          0.00,
                        ),
                        bottom: getVerticalSize(
                          10.04,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getHorizontalSize(
                            18.00,
                          ),
                          right: getHorizontalSize(
                            18.00,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Container(
                                    height: getVerticalSize(
                                      100.00,
                                    ),
                                    width: getHorizontalSize(
                                      73.00,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(10),
                                        image: item!.coverPhoto == "" ||
                                                item!.coverPhoto ==
                                                    "AWS media URL"
                                            ? DecorationImage(
                                                image: AssetImage(
                                                  'assets/images/img_2.png',
                                                ),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: NetworkImage(
                                                  item!.coverPhoto,
                                                ),
                                                fit: BoxFit.cover),
                                        gradient: new LinearGradient(
                                            colors: [
                                              Color(0xE0E0E0),
                                              Color(0xD4A8A8A8),
                                            ],
                                            stops: [
                                              0.0,
                                              1.0
                                            ],
                                            begin: FractionalOffset.topCenter,
                                            end: FractionalOffset.bottomCenter,
                                            tileMode: TileMode.repeated)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: getVerticalSize(
                                              10.00,
                                            ),
                                            left: getVerticalSize(
                                              10.00,
                                            ),
                                            right: getVerticalSize(
                                              10.00,
                                            ),
                                          ),
                                          child: Container(
                                            height: 80.00,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  item!.participants.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (BuildContext context,
                                                  int index) {
                                                Participant item1 =
                                                    item!.participants[index];
                                                return index == 0
                                                    ? Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 0),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  height: getSize(
                                                                    50.00,
                                                                  ),
                                                                  width: getSize(
                                                                    50.00,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      getHorizontalSize(
                                                                        25.00,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Card(
                                                                    clipBehavior: Clip
                                                                        .antiAlias,
                                                                    elevation: 0,
                                                                    margin:
                                                                        EdgeInsets
                                                                            .all(0),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side:
                                                                          BorderSide(
                                                                        width:
                                                                            getHorizontalSize(
                                                                          1.00,
                                                                        ),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        getHorizontalSize(
                                                                          25.00,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                              child:
                                                                                  Icon(
                                                                        Icons
                                                                            .remove_red_eye,
                                                                        size: 20,
                                                                      )),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(4.0),
                                                                  child: Text(
                                                                    "Members",
                                                                    maxLines: null,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        TextStyle(
                                                                      color: ColorConstant
                                                                          .gray400,
                                                                      fontSize: 12,
                                                                      fontFamily:
                                                                          'Rubik',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Get.to(UserProfileD(
                                                                item: item1.userId
                                                                    .toString(),
                                                              ));
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      right: 0),
                                                              child: Column(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      getSize(
                                                                        25.00,
                                                                      ),
                                                                    ),
                                                                    child: item1.profilePicture ==
                                                                            ""
                                                                        ? Image
                                                                            .asset(
                                                                            "assets/images/discover.png",
                                                                            height:
                                                                                getSize(
                                                                              50.00,
                                                                            ),
                                                                            width:
                                                                                getSize(
                                                                              50.00,
                                                                            ),
                                                                            fit: BoxFit
                                                                                .cover,
                                                                          )
                                                                        : Image
                                                                            .network(
                                                                            item1
                                                                                .profilePicture,
                                                                            height:
                                                                                getSize(
                                                                              50.00,
                                                                            ),
                                                                            width:
                                                                                getSize(
                                                                              50.00,
                                                                            ),
                                                                            fit: BoxFit
                                                                                .cover,
                                                                          ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                                .all(
                                                                            4.0),
                                                                    child: Text(
                                                                      item1
                                                                          .username,
                                                                      maxLines:
                                                                          null,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        color: ColorConstant
                                                                            .gray400,
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          Get.to(UserProfileD(
                                                            item: item1.userId
                                                                .toString(),
                                                          ));
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              right: 0),
                                                          child: Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  getSize(
                                                                    25.00,
                                                                  ),
                                                                ),
                                                                child:
                                                                    item1.profilePicture ==
                                                                            ""
                                                                        ? Image
                                                                            .asset(
                                                                            "assets/images/discover.png",
                                                                            height:
                                                                                getSize(
                                                                              50.00,
                                                                            ),
                                                                            width:
                                                                                getSize(
                                                                              50.00,
                                                                            ),
                                                                            fit: BoxFit
                                                                                .cover,
                                                                          )
                                                                        : Image
                                                                            .network(
                                                                            item1
                                                                                .profilePicture,
                                                                            height:
                                                                                getSize(
                                                                              50.00,
                                                                            ),
                                                                            width:
                                                                                getSize(
                                                                              50.00,
                                                                            ),
                                                                            fit: BoxFit
                                                                                .cover,
                                                                          ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(4.0),
                                                                child: Text(
                                                                  item1.username,
                                                                  maxLines: null,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                    color:
                                                                        ColorConstant
                                                                            .gray400,
                                                                    fontSize: 12,
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: getVerticalSize(
                                0.63,
                              ),
                              margin: EdgeInsets.only(
                                left: getHorizontalSize(
                                  1.50,
                                ),
                                right: getHorizontalSize(
                                  1.50,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: ColorConstant.gray400,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    6.00,
                                  ),
                                  top: getVerticalSize(
                                    36.99,
                                  ),
                                  right: getHorizontalSize(
                                    6.00,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        getSize(
                                          35.00,
                                        ),
                                      ),
                                      child: Constant.avatarUrl == ""
                                          ? Image.asset(
                                              "assets/images/discover.png",
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: Constant.avatarUrl,
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 +
                                          40,
                                      // decoration: BoxDecoration(
                                      //       color: ColorConstant.whiteA700,
                                      //       borderRadius: BorderRadius.circular(
                                      //         getHorizontalSize(
                                      //           12.54,
                                      //         ),
                                      //       ),
                                      //       border: Border.all(
                                      //         color: ColorConstant.gray400,
                                      //         width: getHorizontalSize(
                                      //           0.63,
                                      //         ),
                                      //       ),
                                      //     ),
                                      child: TextFormField(
                                        controller: postController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            hintText:
                                                "What Are You Thinking ${Constant.name}?",
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontFamily: 'Poppins',
                                            ),
                                            contentPadding:
                                                EdgeInsets.only(left: 10.0),
                                            suffixIcon: InkWell(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 22,
                                                  color: Colors.black,
                                                ),
                                                onTap: () async {
                                                  var res = await Get.to(PostPage(
                                                      item!.roomId.toString(),
                                                      postController.text,
                                                    item!.roomName.toString()

                                                  ));
                                                  if (res != null) {
                                                    getData();
                                                  }
                                                })),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        AddPost(item!.roomId);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: getVerticalSize(
                                          40.54,
                                        ),
                                        width: getHorizontalSize(
                                          45.54,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            getHorizontalSize(
                                              6.27,
                                            ),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment(
                                              0.5,
                                              -3.0616171314629196e-17,
                                            ),
                                            end: Alignment(
                                              0.5,
                                              0.9999999999999999,
                                            ),
                                            colors: [
                                              ColorConstant.pinkA400,
                                              ColorConstant.pink500,
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          "Post",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: ColorConstant.whiteA700,
                                            fontSize: getFontSize(
                                              12.54,
                                            ),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.13,
                                            height: 1.46,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Obx(
                              () => myController.isoffline.value
                                  ? Center(child: ConnectionError(
                                      onTap: () {
                                        getData();
                                      },
                                    ))
                                  : myController.myList.length <= 0
                                      ? Container(
                                          height: 200,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text("No Posts")),
                                        )
                                      : myController.isDataProcessing.value
                                          ? Center(
                                              child: CircularProgressIndicator())
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2),
                                              itemCount: myController.myList.length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                if (index ==
                                                        myController.myList.length -
                                                            1 &&
                                                    myController.isMoreDataAvailable
                                                        .value) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                PartyPostModel item =
                                                    myController.myList[index];
                                                return Frame312ItemWidget(
                                                  item: item,
                                                  roomId:widget.roomId.toString(),
                                                );
                                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future AddPost(id) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      debugPrint(Constant.access_token);
      debugPrint("hey");
      debugPrint(id);
      var request =
          http.Request('POST', Uri.parse(Constant.createRoom + "/$id/post"));
      request.body = json.encode({"postText": postController.text});
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      // debugPrint("++++++++"+jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        postController.clear();
        getData();
      } else {
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }
}
