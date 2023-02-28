import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sneaky_links/Pages/RoomScreen/reply_item_widget.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/commentR_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

import '../../Components/constants.dart';
import '../../Models/CommentModel.dart';
import '../../Services/api_repository.dart';

class InsideTheRoomWithCommentItemWidget extends StatefulWidget {
  CommentModel item;
  Function(bool re)? reply;

  InsideTheRoomWithCommentItemWidget({required this.item, this.reply});

  @override
  State<InsideTheRoomWithCommentItemWidget> createState() =>
      _InsideTheRoomWithCommentItemWidgetState();
}

class _InsideTheRoomWithCommentItemWidgetState
    extends State<InsideTheRoomWithCommentItemWidget> {
  final myController = Get.put(CommentRController());
  final cController = TextEditingController();
  bool comment = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(2.0, 10, 8, 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      getSize(
                        35.00,
                      ),
                    ),
                    child: widget.item.profilePicture == ""
                        ? Image.asset(
                            "assets/images/discover.png",
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                      imageUrl:
                      widget.item.profilePicture,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: Image.asset(
                        "assets/images/discover.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      )),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.61,
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.username,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height < 750 ? 14 : 18,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            readTimestamp(widget.item.createdAt),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ColorConstant.gray400,
                              fontSize: getFontSize(
                                15.78,
                              ),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.item.comment,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (widget.item.isLikedByMe == 1) {
                              setState(() {
                                widget.item.isLikedByMe = 0;
                                widget.item.totalLikes--;
                              });
                            } else {
                              setState(() {
                                widget.item.isLikedByMe = 1;
                                widget.item.totalLikes++;
                              });
                            }
                            like_or_dislikeReply(widget.item.commentId);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              widget.item.isLikedByMe == 1
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: widget.item.isLikedByMe == 1
                                  ? FlutterFlowTheme.primaryColor
                                  : FlutterFlowTheme.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.item.totalLikes.toString(),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height < 750
                                    ? 14
                                    : 18,
                                fontFamily: 'Poppins',
                                color: widget.item.isLikedByMe == 1
                                    ? FlutterFlowTheme.primaryColor
                                    : FlutterFlowTheme.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            Constant.replyunm=widget.item.username==Constant.name?"yourself":widget.item.username;
                          });
                          return widget.reply!(true);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.reply,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Reply",
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height < 750
                                    ? 14
                                    : 18,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        comment
                            ? const Icon(
                                Icons.keyboard_arrow_up_outlined,
                                // color: Colors.black,
                                size: 20,
                              )
                            : const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 20,
                              ),
                        Text("See all the reply",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height < 750
                                    ? 12
                                    : 14,
                                fontFamily: 'Poppins',
                                color: const Color(0xFF0047FF))),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        // debugPrint("Heyylow");
                        comment = !comment;
                        if (comment) {
                          myController.updateData(widget.item.commentId.toString());
                        }
                      });
                    },
                  ),
                  comment
                      ? ListView(
                          // mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
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
                                child: Obx(
                                  () => myController.isoffline.value
                                      ? Center(child: ConnectionError(
                                          onTap: () {
                                            // getData();
                                            myController.updateData(
                                                widget.item.commentId.toString());
                                          },
                                        ))
                                      : myController.myList.length <= 0
                                          ? Container(
                                              height: 200,
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text("No Reply")),
                                            )
                                          : myController.isDataProcessing.value
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  controller:
                                                      myController.scrollController,
                                                  physics: ClampingScrollPhysics(),
                                                  itemCount:
                                                      myController.myList.length,
                                                  itemBuilder: (context, index) {
                                                    CommentRModel item =
                                                        myController.myList[index];
                                                    return ReplyCommentItemWidget(
                                                        item);
                                                  }),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future like_or_dislikeReply(id) async {
    // EasyLoading.show(status: "Loading...");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request(
          'GET', Uri.parse(Constant.createComments + "/$id/like-or-dislike"));

      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      // debugPrint("++++++++" + jsonBody.toString());
      if (response.statusCode == 200) {
        // EasyLoading.showSuccess(jsonBody['message']);
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
