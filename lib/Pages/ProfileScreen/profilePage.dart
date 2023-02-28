import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/AuthScreen/signIn.dart';
import 'package:sneaky_links/Pages/ProfileScreen/edit_profile_screen.dart';
import 'package:sneaky_links/Pages/ProfileScreen/myAccount.dart';
import 'package:sneaky_links/Pages/ProfileScreen/profileImg_screen.dart';
import 'package:sneaky_links/Pages/RoomScreen/WebviewTermandCondition.dart';
import 'package:sneaky_links/Pages/message/photoView.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:http/http.dart' as http;

import '../AuthScreen/set_profile_screen.dart';


class Profile extends StatefulWidget {
   Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String update="";

  @override
  void initState() {
    super.initState();
    setState(() {
      update=Constant.avatarUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height < 750 ? 20 : 24,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: MediaQuery.of(context).size.height < 750
                ? const EdgeInsets.only(right: 10.0)
                : const EdgeInsets.only(right: 15.0),
            child: InkWell(
                onTap: () async {
                  var res=await
                  Get.to(EditProfile());
                  setState(() {
                    update=Constant.avatarUrl;
                  });
                },
                child: Image.asset(
                  "assets/images/Icon.png",
                  scale: MediaQuery.of(context).size.height < 750 ? 1.3 : 1,
                )),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius
                            .circular(
                          getSize(
                            80.00,
                          ),
                        ),
                        child: Constant.avatarUrl ==
                            ""
                            ? Image.asset(
                          "assets/images/discover.png",
                          height:
                          getSize(
                            120.00,
                          ),
                          width:
                          getSize(
                            120.00,
                          ),
                          fit: BoxFit
                              .cover,
                        )
                            : InkWell(
                          onTap: (){
                            Get.to(PView(update,"user",""));

                          },
                              child: CachedNetworkImage(
                          imageUrl: update,
                          height:
                          getSize(
                              120.00,
                          ),
                          width:
                          getSize(
                              120.00,
                          ),
                          fit: BoxFit
                                .cover,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/discover.png",
                            height:
                            getSize(
                              120.00,
                            ),
                            width:
                            getSize(
                              120.00,
                            ),
                            fit: BoxFit
                                .cover,
                          ),
                        ),
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                        child: Text(
                          Constant.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            // letterSpacing: 2.0,
                            fontSize: MediaQuery.of(context).size.height < 750
                                ? 18
                                : 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          Constant.email,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            // letterSpacing: 2.0,
                            fontSize: MediaQuery.of(context).size.height < 750
                                ? 11
                                : 13.5,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 4.0, left: 4, bottom: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.1),
                          spreadRadius: 0.8,
                          blurRadius: 2,
                        )
                      ],
                      borderRadius: MediaQuery.of(context).size.height < 750
                          ? BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))
                          : BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18)),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 18),
                                child: ListTile(
                                  onTap: () {
                                    Get.to(ProfileImgScreen());
                                  },
                                  leading: Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size:
                                        MediaQuery.of(context).size.height < 750
                                            ? 19
                                            : 23,
                                  ),
                                  title: Text(
                                    "Add Photos",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      // letterSpacing: 2.0,
                                      fontSize:
                                          MediaQuery.of(context).size.height <
                                                  750
                                              ? 14
                                              : 17,
                                      color: Colors.black,
                                      // fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size:
                                        MediaQuery.of(context).size.height < 750
                                            ? 19
                                            : 23,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 0
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Get.to(AccountScreen());
                                  },
                                  leading: Icon(
                                    Icons.account_circle,
                                    color: Colors.black,
                                    size:
                                        MediaQuery.of(context).size.height < 750
                                            ? 19
                                            : 23,
                                  ),
                                  title: Text(
                                    "Manage Account",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      // letterSpacing: 2.0,
                                      fontSize:
                                          MediaQuery.of(context).size.height <
                                                  750
                                              ? 14
                                              : 17,
                                      color: Colors.black,
                                      // fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size:
                                        MediaQuery.of(context).size.height < 750
                                            ? 19
                                            : 23,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 0),
                                child: ListTile(
                                  onTap: () {
                                    Get.to(WebViewClass('Terms & Conditions',Constant.termsUrl));
                                  },
                                  leading: Icon(
                                    Icons.description,
                                    color: Colors.black,
                                    size:
                                    MediaQuery.of(context).size.height < 750
                                        ? 19
                                        : 23,
                                  ),
                                  title: Text(
                                    'Terms & Conditions',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      // letterSpacing: 2.0,
                                      fontSize:
                                      MediaQuery.of(context).size.height <
                                          750
                                          ? 14
                                          : 17,
                                      color: Colors.black,
                                      // fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size:
                                    MediaQuery.of(context).size.height < 750
                                        ? 19
                                        : 23,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 0),
                                child: ListTile(
                                  onTap: () {
                                    Get.to(WebViewClass('Privacy Policy',Constant.privacyUrl));
                                  },
                                  leading: Icon(
                                    Icons.description,
                                    color: Colors.black,
                                    size:
                                    MediaQuery.of(context).size.height < 750
                                        ? 19
                                        : 23,
                                  ),
                                  title: Text(
                                    'Privacy Policy',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      // letterSpacing: 2.0,
                                      fontSize:
                                      MediaQuery.of(context).size.height <
                                          750
                                          ? 14
                                          : 17,
                                      color: Colors.black,
                                      // fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size:
                                    MediaQuery.of(context).size.height < 750
                                        ? 19
                                        : 23,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0,right: 18.0,bottom: 18.0),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.logout,
                                    color: Colors.black,
                                    size:
                                        MediaQuery.of(context).size.height < 750
                                            ? 19
                                            : 23,
                                  ),
                                  title: Text(
                                    "Logout",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      // letterSpacing: 2.0,
                                      fontSize:
                                          MediaQuery.of(context).size.height <
                                                  750
                                              ? 14
                                              : 17,
                                      color: Colors.black,
                                      // fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  onTap: () {
                                    logout();
                                  },
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size:
                                        MediaQuery.of(context).size.height < 750
                                            ? 19
                                            : 23,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future UserLogout() async {
    EasyLoading.show(status: "Loading...");

    SharedPreferences pref = await SharedPreferences.getInstance();
    debugPrint("*****************"+Constant.device_token.toString());

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.logout));
      request.body = json.encode({
        "deviceId": Constant.deviceId,
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      debugPrint(jsonBody.toString());

      if (response.statusCode == 200) {
        setState(() {
          Constant.isLogin = false;
          Constant.email = "";
          // Constant.access_token = "";
          pref.setString("username", "");
          pref.setString("email", "");
          // pref.setString("accessToken", "");
          pref.setBool("isLogin", false);
        });
        Get.offAll(SignIn());

        debugPrint("Logout");
        EasyLoading.dismiss();
      } else {
        // EasyLoading.dismiss();
        EasyLoading.showError(jsonBody.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  logout() async {
    final pref = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Logout!"),
        content: new Text("Do you want to logout?"),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                Get.back();
              },
              isDefaultAction: true,
              child: new Text("Cancel")),
          CupertinoDialogAction(
              onPressed: () {
                setState(() {
                  Constant.isLogin = false;
                  Constant.email = "";
                  // Constant.access_token = "";
                  pref.setString("username", "");
                  pref.setString("email", "");
                  // pref.setString("accessToken", "");
                  pref.setBool("isLogin", false);
                });
                Get.offAll(SignIn());

                debugPrint("Logout");
                // UserLogout();
              },
              isDefaultAction: true,
              child: new Text(
                "Logout",
                style: TextStyle(color: FlutterFlowTheme.primaryColor),
              ))
        ],
      ),
    );
  }

}
