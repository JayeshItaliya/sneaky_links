import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/RoomScreen/inside_the_room_with_comment_item_widget.dart';
import 'package:sneaky_links/Pages/message/photoView.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/comment_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import '../../Models/CommentModel.dart';
import '../../Models/PartyPostModel.dart';
import '../../Services/api_repository.dart';
import '../../Services/googleser.dart';

class Frame312ItemWidget extends StatefulWidget {
  PartyPostModel item;
  String roomId;

  Frame312ItemWidget({required this.item, required this.roomId});

  @override
  State<Frame312ItemWidget> createState() => _Frame312ItemWidgetState();
}

class _Frame312ItemWidgetState extends State<Frame312ItemWidget> {
  final myController = Get.put(CommentController());
  final cController = TextEditingController();
  FocusNode f1 = FocusNode();
  bool comment = false;
  final _formkey = GlobalKey<FormState>();
  bool reply = false;

  String commentid = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: getVerticalSize(
          10.26,
        ),
        bottom: getVerticalSize(
          10.26,
        ),
      ),
      decoration: BoxDecoration(
        color: ColorConstant.whiteA700,
        borderRadius: BorderRadius.circular(
          getHorizontalSize(
            3.00,
          ),
        ),
        border: Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1.00,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: getHorizontalSize(
                    7.52,
                  ),
                  top: getVerticalSize(
                    7.52,
                  ),
                  right: getHorizontalSize(
                    10.00,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        getHorizontalSize(
                          25.08,
                        ),
                      ),
                      child: widget.item.profilePicture == ""
                          ? Image.asset(
                              "assets/images/discover.png",
                              height: getSize(
                                55.06,
                              ),
                              width: getSize(
                                55.06,
                              ),
                              fit: BoxFit.cover,
                            )
                          : InkWell(
                              onTap: () {
                                // Get.to(UserProfileD(
                                //   item: widget.item.toString(),
                                // ));
                              },
                              child: CachedNetworkImage(
                                imageUrl: widget.item.profilePicture,
                                height: getSize(
                                  55.06,
                                ),
                                width: getSize(
                                  55.06,
                                ),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: Image.asset(
                                  "assets/images/discover.png",
                                  height: getSize(
                                    55.06,
                                  ),
                                  width: getSize(
                                    55.06,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: getHorizontalSize(
                          5.02,
                        ),
                        right: getHorizontalSize(
                          0.00,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.username,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: ColorConstant.black900,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: getVerticalSize(
                                2.04,
                              ),
                              right: getHorizontalSize(
                                10.00,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "${readTimestamp(widget.item.createdAt)}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ColorConstant.gray400,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getHorizontalSize(
                                      1.88,
                                    ),
                                    top: getVerticalSize(
                                      1.50,
                                    ),
                                  ),
                                  child: Text(
                                    "•",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: ColorConstant.gray400,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: getHorizontalSize(
                                        1.88,
                                      ),
                                      top: getVerticalSize(
                                        1.74,
                                      ),
                                      right: getHorizontalSize(
                                        0.01,
                                      ),
                                      bottom: getVerticalSize(
                                        0.00,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.location_city_rounded,
                                      color: Colors.grey,
                                      size: 15,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: getHorizontalSize(
                    7.52,
                  ),
                  top: getVerticalSize(
                    8.15,
                  ),
                  right: getHorizontalSize(
                    10.00,
                  ),
                  bottom: getVerticalSize(
                    7.53,
                  ),
                ),
                child: Text(
                  widget.item.postText,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    // color: ColorConstant.gray51,
                    fontSize: getFontSize(
                      15.78,
                    ),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (widget.item.media != "")
                InkWell(
                  onTap: () {
                    Get.to(PView(
                        widget.item.media, widget.item.postId.toString(), ""));
                  },
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.item.media,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/discover.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(
              //     top: getVerticalSize(
              //       0.28,
              //     ),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisSize: MainAxisSize.max,
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.only(
              //           left: getHorizontalSize(
              //             7.52,
              //           ),
              //         ),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Padding(
              //               padding: EdgeInsets.only(
              //                 top: getVerticalSize(
              //                   1.11,
              //                 ),
              //                 bottom: getVerticalSize(
              //                   1.11,
              //                 ),
              //               ),
              //               child: Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Container(
              //                     alignment: Alignment.center,
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(
              //                         getHorizontalSize(
              //                           13.17,
              //                         ),
              //                       ),
              //                     ),
              //                     child: Text(
              //                       "👍 ",
              //                       textAlign: TextAlign.center,
              //                       style: TextStyle(
              //                         color: ColorConstant.gray400,
              //                         fontSize: 12,
              //                         fontFamily: 'Rubik',
              //                         fontWeight: FontWeight.w400,
              //                       ),
              //                     ),
              //                   ),
              //                   Container(
              //                     alignment: Alignment.center,
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(
              //                         getHorizontalSize(
              //                           13.17,
              //                         ),
              //                       ),
              //                     ),
              //                     child: Text(
              //                       "❤️ ",
              //                       textAlign: TextAlign.center,
              //                       style: TextStyle(
              //                         color: ColorConstant.gray400,
              //                         fontSize: 12,
              //                         fontFamily: 'Rubik',
              //                         fontWeight: FontWeight.w400,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             Padding(
              //               padding: EdgeInsets.only(
              //                 left: getHorizontalSize(
              //                   2.51,
              //                 ),
              //                 right: getHorizontalSize(
              //                   0.00,
              //                 ),
              //               ),
              //               child: Text(
              //                 widget.item.totalLikes.toString(),
              //                 overflow: TextOverflow.ellipsis,
              //                 textAlign: TextAlign.left,
              //                 style: TextStyle(
              //                   color: ColorConstant.gray400,
              //                   fontSize: 12,
              //                   fontFamily: 'Poppins',
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.only(
              //           right: getHorizontalSize(
              //             7.52,
              //           ),
              //         ),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Text(
              //               widget.item.totalComments.toString() + " Comments",
              //               overflow: TextOverflow.ellipsis,
              //               textAlign: TextAlign.right,
              //               style: TextStyle(
              //                 color: ColorConstant.gray400,
              //                 fontSize: 12,
              //                 fontFamily: 'Poppins',
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             Padding(
              //               padding: EdgeInsets.only(
              //                 left: getHorizontalSize(
              //                   3.76,
              //                 ),
              //               ),
              //               child: Text(
              //                 widget.item.totalShares.toString() + " Shares",
              //                 overflow: TextOverflow.ellipsis,
              //                 textAlign: TextAlign.right,
              //                 style: TextStyle(
              //                   color: ColorConstant.gray400,
              //                   fontSize: 12,
              //                   fontFamily: 'Poppins',
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(
                  top: getVerticalSize(
                    6.90,
                  ),
                  bottom: getVerticalSize(
                    5.64,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: getVerticalSize(
                        0.63,
                      ),
                      margin: EdgeInsets.only(
                        left: getHorizontalSize(
                          7.52,
                        ),
                        right: getHorizontalSize(
                          7.52,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstant.gray300,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: getHorizontalSize(
                          21.52,
                        ),
                        right: getHorizontalSize(
                          21.52,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                widget.item.isLikedByMe =
                                    !widget.item.isLikedByMe;
                                like_or_dislike(widget.item.postId.toString());
                                if (widget.item.isLikedByMe) {
                                  setState(() {
                                    widget.item.totalLikes++;
                                  });
                                } else {
                                  setState(() {
                                    widget.item.totalLikes--;
                                  });
                                }
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    height: 15.05,
                                    width:
                                      15.05,
                                    padding: EdgeInsets.only(
                                      top: 2.0,
                                    ),
                                    child: Image.asset(
                                      "assets/images/like.png",
                                      color: widget.item.isLikedByMe?FlutterFlowTheme.primaryColor:FlutterFlowTheme.grey1,
                                    )),
                                SizedBox(
                                  width: 1,
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(
                                //     left: getHorizontalSize(
                                //       3.76,
                                //     ),
                                //     top: getVerticalSize(
                                //       10.18,
                                //     ),
                                //     bottom: getVerticalSize(
                                //       4.53,
                                //     ),
                                //   ),
                                //   child: Text(
                                //     "👍",
                                //     textAlign: TextAlign.center,
                                //     style: TextStyle(
                                //       color: ColorConstant.gray400,
                                //       fontSize: 15,
                                //       fontFamily: 'Rubik',
                                //       fontWeight: FontWeight.w400,
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getHorizontalSize(
                                      3.76,
                                    ),
                                    top: getVerticalSize(
                                      10.18,
                                    ),
                                    bottom: getVerticalSize(
                                      4.53,
                                    ),
                                  ),
                                  child: Text(
                                    widget.item.totalLikes.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      color: widget.item.isLikedByMe
                                          ? FlutterFlowTheme.primaryColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                comment = !comment;
                                if (comment)
                                  myController.updateData(
                                      widget.item.postId.toString());
                                FocusScope.of(context).requestFocus(f1);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: getVerticalSize(
                                  8.15,
                                ),
                                bottom: getVerticalSize(
                                  2.51,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      height: 15.05,
                                      width:
                                      15.05,
                                      child: Icon(
                                        Icons.mode_comment_outlined,
                                        size: 15,
                                      )),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: getHorizontalSize(
                                        3.76,
                                      ),
                                      top: getVerticalSize(
                                        2.03,
                                      ),
                                      bottom: getVerticalSize(
                                        2.02,
                                      ),
                                    ),
                                    child: Text(
                                      widget.item.totalComments.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              sharePost(widget.item.postId.toString());
                              onShareData(
                                  "Post Share link https://www.sneakylinks.com/rooms${widget.roomId}/post/${widget.item.postId}");
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: getVerticalSize(
                                  8.15,
                                ),
                                bottom: getVerticalSize(
                                  2.51,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      height: 15.05,
                                      width:
                                      15.05,
                                      child: Icon(
                                        Icons.ios_share,
                                        size: 15,
                                      )),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: getHorizontalSize(
                                        3.76,
                                      ),
                                      top: getVerticalSize(
                                        2.03,
                                      ),
                                      bottom: getVerticalSize(
                                        2.02,
                                      ),
                                    ),
                                    child: Text(
                                      "Share",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          comment
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getHorizontalSize(
                            10.00,
                          ),
                          top: getVerticalSize(
                            10.00,
                          ),
                        ),
                        child: Column(
                          children: [
                            Obx(
                              () => myController.isoffline.value
                                  ? Center(child: ConnectionError(
                                      onTap: () {
                                        // getData();
                                        myController.updateData(
                                            widget.item.postId.toString());
                                      },
                                    ))
                                  : myController.myList.length <= 0
                                      ? Container(
                                          height: 100,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text("No Comments")),
                                        )
                                      : myController.isDataProcessing.value
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Container(
                                              // height:405,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  controller: myController
                                                      .scrollController,
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  itemCount: myController
                                                      .myList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    CommentModel item =
                                                        myController
                                                            .myList[index];
                                                    return InsideTheRoomWithCommentItemWidget(
                                                      item: item,
                                                      reply: (replyItem) {
                                                        setState(() {
                                                          commentid = item
                                                              .commentId
                                                              .toString();
                                                          reply = replyItem;
                                                          FocusScope.of(context)
                                                              .requestFocus(f1);
                                                        });
                                                      },
                                                    );
                                                  }),
                                            ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(2.0, 10, 15, 0),
                              child: Container(
                                child: Row(children: [
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 9, left: 6.0),
                                        child: Column(
                                          children: [
                                            if (reply)
                                              Divider(
                                                color: Colors.black,
                                              ),
                                            if (reply)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Replying to " +
                                                        "${Constant.replyunm == Constant.name ? "yourself" : Constant.replyunm}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        reply = false;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      size: 23,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            Form(
                                              key: _formkey,
                                              child: TextFormField(
                                                focusNode: f1,
                                                controller: cController,
                                                decoration: InputDecoration(
                                                  isCollapsed: true,
                                                  // border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  hintText: "Add a Comment",
                                                  hintStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height <
                                                                750
                                                            ? 15
                                                            : 17,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return ("Please Enter Your Comment");
                                                  }
                                                },
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                MaterialButton(
                                                  elevation: 0,
                                                  focusColor: Colors.grey,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .height <
                                                          750
                                                      ? 26
                                                      : 38,
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width <
                                                              750
                                                          ? 30
                                                          : 35,
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    if (_formkey.currentState!
                                                        .validate()) {
                                                      reply
                                                          ? addCommentReply(
                                                              commentid)
                                                          : addComment(widget
                                                              .item.postId);
                                                    }
                                                  },
                                                  child: Text(
                                                    "Send",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height <
                                                                  750
                                                              ? 13
                                                              : 15,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 18,
                                                ),
                                                MaterialButton(
                                                  elevation: 0,
                                                  padding: EdgeInsets.only(
                                                      right: 7, left: 7),
                                                  focusColor: Colors.grey,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .height <
                                                          750
                                                      ? 26
                                                      : 38,
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width <
                                                              750
                                                          ? 30
                                                          : 35,
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    setState(() {
                                                      reply = false;
                                                      comment = false;
                                                    });
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height <
                                                                  750
                                                              ? 13
                                                              : 15,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Future addComment(id) async {
    EasyLoading.show(status: "Loading...");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request(
          'POST', Uri.parse(Constant.createPosts + "/$id/comment"));
      request.body = json.encode({"comment": cController.text});
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        cController.clear();
        setState(() {
          widget.item.totalComments++;
        });
        myController.updateData(widget.item.postId.toString());
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

  Future addCommentReply(id) async {
    EasyLoading.show(status: "Loading...");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request(
          'POST', Uri.parse(Constant.createComments + "/$id/reply"));
      request.body = json.encode({"comment": cController.text});
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        setState(() {
          cController.clear();
          comment = false;
          reply = false;
        });
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

  Future like_or_dislike(id) async {
    // EasyLoading.show(status: "Loading...");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request(
          'GET', Uri.parse(Constant.createPosts + "/$id/like-or-dislike"));

      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      // print("++++++++" + jsonBody.toString());
      if (response.statusCode == 200) {
        // EasyLoading.showSuccess(jsonBody['message']);
      } else {
        // EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Future sharePost(id) async {
    // EasyLoading.show(status: "Loading...");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.Request('GET', Uri.parse(Constant.createPosts + "/$id/share"));

      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      // print("++++++++" + jsonBody.toString());
      if (response.statusCode == 200) {
        // EasyLoading.showSuccess(jsonBody['message']);
      } else {
        // EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }
}
