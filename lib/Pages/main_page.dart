import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Pages/AuthScreen/set_profile_screen.dart';
import 'package:sneaky_links/Pages/AuthScreen/signIn.dart';
import 'package:sneaky_links/Pages/ProfileScreen/profilePage.dart';
import 'package:sneaky_links/Pages/RoomScreen/inside_the_room_without_comment_screen.dart';
import 'package:sneaky_links/Pages/RoomScreen/newRoom_screen.dart';
import 'package:sneaky_links/Pages/SearchScreen/search_screen.dart';
import 'package:sneaky_links/controllers/task_provider.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import '../Components/constants.dart';
import '../Services/api_repository.dart';
import '../controllers/network_controller.dart';
import 'DiscoverScreen/discover_page.dart';
import 'message/message_screen.dart';

class NavBarPage extends StatefulWidget {
  String currentPage = '';
  bool? value;

  NavBarPage({required this.currentPage, this.value = true});

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final socketController = Get.put(NetworkController());

  @override
  void initState() {
    super.initState();
    getData();
    getPackageInfo();
  }

  getPackageInfo() async {

    NewVersion newVersion = NewVersion(
      iOSId: 'com.sneakylinksus',
      androidId: 'com.sneakylinksus',
    );

    const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }

  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update Available',
        dialogText: 'you can noe update version '+status.localVersion+" to "+status.storeVersion,
      );
    }
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = await _firebaseMessaging.getToken();

    pref.setString("token", token.toString());
    bool updateProfile =(pref.getBool(Constant.user_id + "updateProfile") ?? false);
    bool party = (pref.getBool(Constant.user_id + "partypageeeep") ?? false);
    setState(() {
      Constant.device_token = token.toString();
      updateToken();
    });
    currentPlan();
    // if (!updateProfile) {
    //   Get.offAll(SetProfile());
    // } else
    //   if (!party) {
    //     TaskProvider().joinParty("109", "").then((value) async {
    //     // if (value != null) {
    //     pref.setBool(Constant.user_id + "partypageeeep", true);
    //     Get.to(InsideTheRoomWithoutCommentScreen("109"));
    //     // }
    //   });
    // }
    // else
/*        TaskProvider().joinParty("109", "").then((value) async {
        Get.to(InsideTheRoomWithoutCommentScreen("109"));
      });*/
  }


  @override
  Widget build(BuildContext context) {

    final tabs = {
      'ProfileScreen': Profile(),
      'DiscoverScreen': DiscoverPage(),
      'RoomsScreen': NewRoomScreen(),
      'MessageScreen': MessageScreen(),
      'SearchScreen': SearchScreen(true),
    };

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBody: true,
        body: tabs[widget.currentPage],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.6),
                  spreadRadius: 0.8,
                  blurRadius: 1,
                )
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14)),
              color: Colors.blueAccent,
            ),
            child: BottomNavigationBar(
              selectedFontSize: 12,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle_outlined,
                    size: 24,
                  ),
                  label: 'Profile',
                  tooltip: 'Profile',
                ),
                const BottomNavigationBarItem(
                  icon: Center(
                    child: Icon(
                      Icons.favorite_border,
                      size: 24,
                    ),
                  ),
                  label: 'Match',
                  tooltip: 'Match',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          "assets/images/logo.png",
                        )),
                  ),
                  label: 'Party',
                  tooltip: 'Party',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    FlutterIcons.chat_outline_mco,
                    size: 24,
                  ),
                  label: 'Chat',
                  tooltip: 'Chat',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    size: 24,
                  ),
                  label: 'Search',
                  tooltip: 'Search',
                )
              ],
              backgroundColor: Colors.white,
              currentIndex: tabs.keys.toList().indexOf(widget.currentPage),
              selectedItemColor: FlutterFlowTheme.primaryColor,
              unselectedItemColor: Colors.black,
              onTap: (i) =>
                  setState(() => widget.currentPage = tabs.keys.toList()[i]),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }

  Future currentPlan() async {
    // EasyLoading.show(status: "Loading...");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('get', Uri.parse(Constant.subscription));
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      pref.setString("currentPlan", "FREE");
      pref.setInt("plan_active", 1);
      setState(() {
        Constant.current_plan = "FREE";
        Constant.plan_active = 1;
      });
      print("++++++++++++++"+Constant.user_id);
      print(jsonBody.toString());
      if (response.statusCode == 200) {

        if (jsonBody['data']['planName'].toString() == "VOYEUR") {
          pref.setString("currentPlan", "FREE");
        } else {
          pref.setString("currentPlan", jsonBody['data']['planName'].toString());
        }

        pref.setInt("plan_active", 1);

        setState(() {
          if (jsonBody['data']['planName'].toString() == "VOYEUR") {
            Constant.current_plan = "FREE";
          } else {
            Constant.current_plan = jsonBody['data']['planName'].toString();
          }


          if (jsonBody['data']['receipt'].containsKey('likerejectcount')) {
            pref.setInt(Constant.user_id + "like_user",
                jsonBody['data']['receipt']['likerejectcount']);
            pref.setInt(Constant.user_id + "free_party_join",
                jsonBody['data']['receipt']['partycount']);
            pref.setInt(Constant.user_id + "message_exp",
                jsonBody['data']['receipt']['messagecount']);
          } else {
            setState(() {
              pref.setString(Constant.user_id + "productID",
                  jsonBody['data']['productID']);
              pref.setInt(Constant.user_id + "expiredate",
                  jsonBody['data']['receipt']['expiredate']);
            });

            receipt_dataSave().then((value) {
              setState(() {
                pref.setInt(Constant.user_id + "like_user",
                    value['data']['receipt']['likerejectcount']);
                pref.setInt(Constant.user_id + "free_party_join",
                    value['data']['receipt']['partycount']);
                pref.setInt(Constant.user_id + "message_exp",
                    value['data']['receipt']['messagecount']);
              });
            });
          }

          if (DateTime.now().millisecondsSinceEpoch <=
              jsonBody['data']['receipt']['expiredate']) {
            pref.setInt("plan_active", 1);
            Constant.plan_active = 1;
          } else {
            pref.setInt("plan_active", 0);
            Constant.plan_active = 0;
          }

          Constant.plan_active = 1;
        });


        // EasyLoading.dismiss();
      } else if (response.statusCode == 401) {
        // EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else if (response.statusCode == 500) {
        setState(() {
          Constant.current_plan = "FREE";
          Constant.plan_active = 1;
        });

        receipt_dataSave().then((value) {
          setState(() {
            pref.setInt(Constant.user_id + "like_user",
                value['data']['receipt']['likerejectcount']);
            pref.setInt(Constant.user_id + "free_party_join",
                value['data']['receipt']['partycount']);
            pref.setInt(Constant.user_id + "message_exp",
                value['data']['receipt']['messagecount']);

          });

        });
        print("++++++++++++" + response.statusCode.toString());
      } else {
        // EasyLoading.dismiss();
        // EasyLoading.showError(jsonBody.toString());
        setState(() {
          Constant.current_plan = "FREE";
          Constant.plan_active = 1;
        });
      }
    } catch (e) {
      print(e.toString());
      // EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

}
