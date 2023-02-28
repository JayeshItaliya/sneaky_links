import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/controllers/block_controller.dart';
import 'package:sneaky_links/controllers/chat_controller.dart';
import 'package:sneaky_links/controllers/commentR_controller.dart';
import 'package:sneaky_links/controllers/like_controller.dart';
import 'package:sneaky_links/controllers/home_controller.dart';
import 'package:sneaky_links/controllers/location_provider.dart';
import 'package:sneaky_links/controllers/msgController.dart';
import 'package:sneaky_links/controllers/mylike_controller.dart';
import 'package:sneaky_links/controllers/network_controller.dart';
import 'package:sneaky_links/controllers/party_controller.dart';
import 'package:sneaky_links/controllers/partypost_controller.dart';
import 'package:sneaky_links/controllers/recentcontroller.dart';
import 'package:sneaky_links/controllers/user_party_controller.dart';
import 'package:sneaky_links/controllers/users_controller.dart';

import 'addpicController.dart';
import 'comment_controller.dart';
import 'notification_controller.dart';


class NetworkBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<NetworkController>(() => NetworkController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<LikesController>(() => LikesController());
    Get.lazyPut<MyLikesController>(() => MyLikesController());
    Get.lazyPut<BlockController>(() => BlockController());
    // Get.lazyPut<LocationProvider>(() => LocationProvider());
    Get.lazyPut<UserPartyController>(() => UserPartyController());
    Get.lazyPut<PartyController>(() => PartyController());
    Get.lazyPut<UsersController>(() => UsersController());
    Get.lazyPut<PartyPostController>(() => PartyPostController());
    Get.lazyPut<CommentController>(() => CommentController());
    Get.lazyPut<CommentRController>(() => CommentRController());
    Get.lazyPut<MsgController>(() => MsgController());
    Get.lazyPut<RecentController>(() => RecentController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<AddPicController>(() => AddPicController());
    Get.lazyPut<NotificationController>(() => NotificationController());
  }

}