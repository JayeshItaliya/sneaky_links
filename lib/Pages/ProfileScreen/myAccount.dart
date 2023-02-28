import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Pages/ProfileScreen/appicon_cng.dart';
import 'package:sneaky_links/Pages/ProfileScreen/help_screen.dart';
import 'package:sneaky_links/Pages/ProfileScreen/pinscreen.dart';
import 'package:sneaky_links/Pages/ProfileScreen/subscribe.dart';

import '../../Components/constants.dart';
import '../../Models/LoginModal.dart';
import '../../Services/api_repository.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../AuthScreen/signIn.dart';
import '../Notification/norification page.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<AccountScreen> {

  bool status = false;
  bool status1 = false;
  late GetProfile userdata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    getProfile().then((value) {
      if (value != null) {
        setState(() {
          userdata = value;
          print(userdata.toJson());

          setState(() {
          status=!userdata.isPublicProfile;
          status1=userdata.notificationSettings;
          });

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size.height<750?Size.fromHeight(50.0):Size.fromHeight(55.0),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(Icons.arrow_back_ios,
                size: MediaQuery.of(context).size.height<750?18:22,),
            ),
            color: Colors.black,
          ),
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0,
          // automaticallyImplyLeading: false,
          title: Text("My Account",style: TextStyle(
            // letterSpacing: 2.0,
            fontSize: MediaQuery.of(context).size.height<750?20:24,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
          ),

        ),
      ),
        body:Container(
          child: Padding(
            padding: MediaQuery.of(context).size.height<750?const EdgeInsets.fromLTRB(28,0,28,0):const EdgeInsets.fromLTRB(32,0,32,0),
            child: Column(
              children: [
                Expanded(
                  flex:5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:4,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text("Membership Type",textAlign: TextAlign.left,style: TextStyle(
                              // letterSpacing: 2.0,
                              fontSize: MediaQuery.of(context).size.height<750?10:13,
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                              fontFamily: 'Poppins',
                            ),
                            ),
                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                            subtitle: Text(Constant.current_plan.toCapitalized(),textAlign: TextAlign.left,style: TextStyle(
                              // letterSpacing: 2.0,
                              fontSize: MediaQuery.of(context).size.height<750?10:13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                            ),
                            minLeadingWidth: 0,
                            // minVerticalPadding: 5.0,
                            leading: Icon(
                              Icons.card_membership,

                              color: Colors.black,
                              size: MediaQuery.of(context).size.height<750?21:25.5,

                            ),
                            trailing: MaterialButton(
                              focusColor: Colors.grey,
                              height: MediaQuery.of(context).size.height<750?31:50,
                              elevation: 0,
                              padding: EdgeInsets.fromLTRB(7,0,7,0),
                              minWidth: MediaQuery.of(context).size.height<750?30:40,
                              color: Colors.pink.shade600,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              onPressed: () async {

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                var res=await Get.to(subscribe());
                                setState(() {
                                  Constant.current_plan=(prefs.getString("currentPlan")??"");
                                });

                              },
                              child: Text("Upgrade",textAlign:TextAlign.center,style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.height<750?9:12,
                                fontFamily: 'Poppins',
                              ),),
                            ),
                            selectedTileColor:Colors.green[400],
                            onTap: () {

                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top:12.0,bottom:8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              child: Text(
                                "  Settings",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height<750?15:18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                              width:MediaQuery.of(context).size.height<750?100:130,
                              height:MediaQuery.of(context).size.height<750?20:26,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(width: MediaQuery.of(context).size.height<750?4.0:6.0, color: Color(0xFFCC007A)),
                                ),
                                // color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex:30,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Text(
                                  "Hide My Profile",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height<750?12.5:16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                                ),
                                ),
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                dense: true,
                                minLeadingWidth: 0,
                                contentPadding: EdgeInsets.zero,
                                minVerticalPadding: 0,
                                trailing: Switch(
                                  activeTrackColor: Color(0xFFFF99D6),
                                  activeColor: Colors.white,
                                  activeThumbImage: AssetImage('assets/images/img.png',),
                                  inactiveThumbImage: AssetImage('assets/images/img_1.png'),
                                  value: status ,
                                  onChanged: (value){
                                    setState(() {
                                      status=value;
                                      print(status);
                                      hideProfile(!status);
                                    });
                                  },
                                ),
                                onTap: () {
                                },
                              ),
                              ListTile(

                                leading: Text(
                                  "Notifications",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height<750?12.5:16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                                ),
                                minLeadingWidth: 0,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                // minVerticalPadding: 0,
                                trailing: Switch(

                                  activeTrackColor: Color(0xFFFF99D6),
                                  activeColor: Colors.white,

                                  activeThumbImage: AssetImage('assets/images/img.png',),
                                  inactiveThumbImage: AssetImage('assets/images/img_1.png'),

                                  value: status1 ,
                                  onChanged: (value){
                                    // save(value);
                                    setState(() {
                                      status1=value;
                                      hideNoti(status1);

                                    });
                                  },
                                ),
                                selectedTileColor:Colors.green[400],
                                onTap: () {
                                  setState(() {

                                  });
                                },
                              ),
                              if(Platform.isIOS)
                              ListTile(

                                leading: Text(
                                  "Discrete App Icon",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height<750?12.5:16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                                ),
                                minLeadingWidth: 0,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -1),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                // minVerticalPadding: 0,
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: MediaQuery.of(context).size.height<750?20.5:27,
                                  color: Colors.black,
                                ),
                                selectedTileColor:Colors.green[400],
                                onTap: () {
                                 Get.to(ChangeIconPage());
                                },
                              ),
                              ListTile(
                                leading: Text(
                                  "Optional Pin",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height<750?12.5:16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                                ),
                                minLeadingWidth: 0,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                // minVerticalPadding: 0,
                                trailing:Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: MediaQuery.of(context).size.height<750?20.5:27,
                                  color: Colors.black,
                                ),
                                selectedTileColor:Colors.green[400],
                                onTap: () {
                                  Constant.islock?
                                  screenLock<void>(
                                    context: context,
                                    correctString: Constant.locknum,
                                    didUnlocked: () {
                                      Get.back();
                                      Get.to(PinScreen());
                                    },
                                  ):  Get.to(PinScreen());
                                },
                              ),
                              ListTile(
                                leading: Text(
                                  "Restore Purchases",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height<750?12.5:16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                                ),
                                minLeadingWidth: 0,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                // minVerticalPadding: 0,
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: MediaQuery.of(context).size.height<750?20.5:27,
                                  color: Colors.black,
                                ),
                                selectedTileColor:Colors.green[400],
                                onTap: () {
                                  Get.to(subscribe());
                                },
                              ),
                              ListTile(
                                leading: Text(
                                  "Help",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height<750?12.5:16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                                ),
                                minLeadingWidth: 0,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                // minVerticalPadding: 0,
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: MediaQuery.of(context).size.height<750?20.5:27,
                                  color: Colors.black,
                                ),
                                selectedTileColor:Colors.green[400],
                                onTap: () {
                                  Get.to(HelpScreen());
                                },
                              ),
                              ListTile(
                                leading: Text(
                                  "Delete Account",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height<750?12.5:16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),
                                ),
                                minLeadingWidth: 0,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                // minVerticalPadding: 0,
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: MediaQuery.of(context).size.height<750?20.5:27,
                                  color: Colors.black,
                                ),
                                selectedTileColor:Colors.green[400],
                                onTap: () {
                                  delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  flex:1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13,0,13,0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text("Logout",textAlign: TextAlign.left,style: TextStyle(
                        // letterSpacing: 2.0,
                        fontSize: MediaQuery.of(context).size.height<750?13.5:17,
                        color: Colors.black,
                        // fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                      ),
                      minLeadingWidth: 0,
                      // minVerticalPadding: 5.0,
                      leading: Padding(
                        padding: const EdgeInsets.only(top :3.0),
                        child: Icon(
                          Icons.logout,
                          color: Colors.black,
                          size: MediaQuery.of(context).size.height<750?19.8:26,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: MediaQuery.of(context).size.height<750?20.5:27,
                        color: Colors.black,
                      ),
                      onTap: () {
                       logout();
                      },
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

      print(jsonBody.toString());

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

        print("Logout");
        EasyLoading.dismiss();
      } else {
        // EasyLoading.dismiss();
        EasyLoading.showError(jsonBody.toString());
      }
    } catch (e) {
      print(e.toString());
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

                print("Logout");

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
  delete() async {
    final pref = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Delete!"),
        content: new Text("Do you want to Delete Account?"),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                Get.back();
              },
              isDefaultAction: true,
              child: new Text("Cancel")),
          CupertinoDialogAction(
              onPressed: () {

                print("Delete");
                UserLogout();

              },
              isDefaultAction: true,
              child: new Text(
                "Delete",
                style: TextStyle(color: FlutterFlowTheme.primaryColor),
              ))
        ],
      ),
    );
  }



  Future hideProfile(status) async {

    EasyLoading.show(status: "Loading...");

    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {

      var request = http.Request('POST', Uri.parse(Constant.updateProfile));
      request.body = json.encode({
        "isPublicProfile": status,
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());

      if (response.statusCode == 200) {

        EasyLoading.showSuccess("Updated");
      } else {
        // EasyLoading.showSuccess("Updated");
        print("+++++++++++dddd "+jsonBody.toString());

        EasyLoading.showError(jsonBody['message']);
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

  Future hideNoti(status) async {

    EasyLoading.show(status: "Loading...");

    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.updateProfile));
      request.body = json.encode({

        "notificationSettings": status,
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());

      if (response.statusCode == 200) {

        EasyLoading.showSuccess("Updated");

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

}
