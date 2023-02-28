import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/commentR_controller.dart';
import 'package:sneaky_links/controllers/comment_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

import '../../Components/constants.dart';
import '../../Models/CommentModel.dart';
import '../../Services/api_repository.dart';

class ReplyCommentItemWidget extends StatefulWidget {
  CommentRModel item;
  ReplyCommentItemWidget(this.item);

  @override
  State<ReplyCommentItemWidget> createState() =>
      _ReplyCommentItemWidgetState();
}

class _ReplyCommentItemWidgetState
    extends State<ReplyCommentItemWidget> {


  @override
  Widget build(BuildContext context) {
    return   ListTile(
      leading: ClipRRect(
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
            :CachedNetworkImage(
          imageUrl: widget.item.profilePicture,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      title: Text(widget.item.username,),
      subtitle: Text(widget.item.comment,maxLines: 2,),
      trailing: Column(
        children: [
          Text(readTimestamp(widget.item.createdAt),),
          // IconButton(onPressed: (){
          //
          // }, icon: Icon(widget.itemIcons.favorite:Icons.f))
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

      print("++++++++" + jsonBody.toString());
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
