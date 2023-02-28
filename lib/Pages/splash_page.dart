import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/RoomScreen/inside_the_room_without_comment_screen.dart';
import 'package:sneaky_links/Pages/permissionPage.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import 'package:sneaky_links/controllers/task_provider.dart';
import 'dart:async';
import 'main_page.dart';
import 'onbording.dart';

class SplashPage extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      if (Platform.isAndroid)
        Constant.device_type = "Android";
      else if (Platform.isIOS) Constant.device_type = "iOS";
    });
    navtohome();
  }


  navtohome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool islogin = (prefs.getBool("isLogin") ?? false);
    bool islock = (prefs.getBool("islock") ?? false);
    String email = (prefs.getString("email") ?? "");
    String avatarUrl = (prefs.getString("avatarUrl") ?? "");
    String userid = (prefs.getString("userid") ?? "");
    String usernme = (prefs.getString("username") ?? "");
    String accessToken = (prefs.getString("accessToken") ?? "");
    String refreshToken = (prefs.getString("refreshToken") ?? "");
    String locknum = (prefs.getString("locknum") ?? "");

    print("++++++++++++${email}");
    print("++++++++++++${accessToken}");
    String? deviceid = await _getId();
    print("++++++++++++${deviceid}");

    setState(() {
      Constant.deviceId = deviceid!;
      Constant.isLogin = islogin;
      Constant.islock = islock;
      Constant.locknum = locknum;
      Constant.email = email;
      Constant.user_id = userid;
      Constant.name = usernme;
      Constant.avatarUrl = avatarUrl;
      Constant.access_token = accessToken;
      Constant.refreshToken = refreshToken;
    });
    thereMethod(islogin);

    // if(islogin)
    // updateToken();

  }

  thereMethod(islogin) async {
    await Future.delayed(Duration(seconds: 5), () {});
    if (Constant.islock) {
      screenLock<void>(
        context: context,
        correctString: Constant.locknum.toString(),
        didUnlocked: () {
          Navigator.pop(context);

          if (islogin) {
            TaskProvider().joinParty("109", "").then((value) async {
              Get.to(InsideTheRoomWithoutCommentScreen("109"));
            });
            // Get.offAll(NavBarPage(currentPage: 'DiscoverScreen',));
          }
          else {
            Get.offAll(OnBoardingView());
          }
        },
      );
    }
    else {
      if (islogin) {
        TaskProvider().joinParty("109", "").then((value) async {
          Get.to(InsideTheRoomWithoutCommentScreen("109"));
        });
        // Get.offAll(NavBarPage(currentPage: 'DiscoverScreen',));
      } else {
        Get.offAll(OnBoardingView());
      }
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // Unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 220,
              ),
              Text(
                "Let's get sneaky",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 23),
              )
            ],
          ),
        ));
  }

}
