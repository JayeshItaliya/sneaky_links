import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/user_list.dart';
import 'package:sneaky_links/Pages/ProfileScreen/subscribe.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../controllers/home_controller.dart';

class DiscoverPage extends StatefulWidget {
   DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<String> imgurl = [
    "assets/images/discover.png",
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final myController = Get.put(HomeController());
  int like_user = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // StripeService.init();
    // getPermissions();
    getData();
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      like_user = pref.getInt(Constant.user_id + "like_user") ?? 0;
      if (like_user == 5&&Constant.current_plan=="FREE") {
        myController.ishidelike.value = true;
        Get.defaultDialog(
          title: Constant.titleText,
          radius: 30,
          barrierDismissible: false,
          content: Column(
            children: [
              Column(
                children: [
                  const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        "assets/images/logo.png",
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    Constant.description,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Later")),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.to(subscribe());
                      },
                      child: const Text("Upgrade"))
                ],
              )
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 28.0, top: 28.0, right: 28.0),
          child: Column(
            // shrinkWrap: true,
            // padding: EdgeInsets.all(18),
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Are you ready to be sneaky?",
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.height <= 300 ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              // Expanded(
              //     flex: 9,
              //     child: Padding(
              //       padding: const EdgeInsets.all(4.0),
              //       child: SwipeCards(
              //         matchEngine: _matchEngine!,
              //         itemBuilder: (BuildContext context, int index) {
              //           return empty?Container(child: Text("Em"),)
              //               :Container(
              //             alignment: Alignment.bottomLeft,
              //             decoration: BoxDecoration(
              //                 color: Colors.blueGrey,
              //                 borderRadius: BorderRadius.circular(15),
              //                 image: DecorationImage(
              //                     image: AssetImage(
              //                       imgurl[index],
              //                     ),
              //                     fit: BoxFit.cover),
              //                 gradient: new LinearGradient(
              //                     colors: [
              //                       Color(0xE0E0E0),
              //                       Color(0xD4A8A8A8),
              //                     ],
              //                     stops: [
              //                       0.0,
              //                       1.0
              //                     ],
              //                     begin: FractionalOffset.topCenter,
              //                     end: FractionalOffset.bottomCenter,
              //                     tileMode: TileMode.repeated)),
              //             child: Padding(
              //               padding: const EdgeInsets.all(25.0),
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   // Text(
              //                   //   _names[index]+", "+age[index],
              //                   //   style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),
              //                   // ),
              //                   // SizedBox(height: 3,),
              //                   // Text(
              //                   //   location[index],
              //                   //   style: TextStyle(fontSize: 12,color: Colors.white),
              //                   // ),
              //                 ],
              //               ),
              //             ),
              //           );
              //         },
              //         onStackFinished: () {
              //           _scaffoldKey.currentState?.showSnackBar(SnackBar(
              //             content: Text("Stack Finished"),
              //             duration: Duration(milliseconds: 500),
              //           ));
              //         },
              //         itemChanged: (SwipeItem item, int index) {
              //           print("item: ${item.content.name}, index: $index");
              //         },
              //         upSwipeAllowed: false,
              //         fillSpace: false,
              //       ),
              //     )),
              Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Obx(
                      () => myController.isoffline.value
                          ? Center(child: ConnectionError(
                              onTap: () {
                                myController.updateData("");
                              },
                            ))
                          : myController.isDataProcessing.value
                              ? Center(child: CircularProgressIndicator())
                              : myController.homeList.length == 0
                                  ? Container(
                                      child: Center(
                                          child: Text(
                                        "No more users check back soon",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  : Constant.current_plan == "FREE" &&
                                          myController.ishidelike.value
                                      ? Container(
                                          child: Center(
                                              child: Text(
                                            "PLEASE UPGRADE THE PLAN TO REACH MORE SNEAKS",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          child: SwipeCards(
                                            matchEngine:
                                                myController.matchEngine,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return myController.empty.value
                                                  ? Container(
                                                      child: Center(
                                                          child: Text(
                                                        "No more users check back soon",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    )
                                                  : Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .blueGrey,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15),
                                                          image: myController
                                                                      .swipeItems[
                                                                          index]
                                                                      .content
                                                                      .imgurl
                                                                      .toString() !=
                                                                  ""
                                                              ? DecorationImage(
                                                                  image: NetworkImage(myController
                                                                      .swipeItems[
                                                                          index]
                                                                      .content
                                                                      .imgurl),
                                                                  fit: BoxFit
                                                                      .cover)
                                                              : DecorationImage(
                                                                  image:
                                                                      AssetImage(
                                                                    imgurl[0],
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover),
                                                          gradient: new LinearGradient(
                                                              colors: [
                                                                Color(0xE0E0E0),
                                                                Color(
                                                                    0xD4A8A8A8),
                                                              ],
                                                              stops: [
                                                                0.0,
                                                                1.0
                                                              ],
                                                              begin:
                                                                  FractionalOffset
                                                                      .topCenter,
                                                              end: FractionalOffset
                                                                  .bottomCenter,
                                                              tileMode: TileMode.repeated)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(25.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              myController
                                                                      .swipeItems[
                                                                          index]
                                                                      .content
                                                                      .name +
                                                                  ", " +
                                                                  myController
                                                                      .swipeItems[
                                                                          index]
                                                                      .content
                                                                      .age
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  shadows: <
                                                                      Shadow>[
                                                                    Shadow(
                                                                      offset: Offset(
                                                                          1.0,
                                                                          1.0),
                                                                      blurRadius:
                                                                          3.0,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                    ),
                                                                    Shadow(
                                                                      offset: Offset(
                                                                          1.0,
                                                                          1.0),
                                                                      blurRadius:
                                                                          8.0,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                    ),
                                                                  ],
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              myController
                                                                  .swipeItems[
                                                                      index]
                                                                  .content
                                                                  .location,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                                shadows: <
                                                                    Shadow>[
                                                                  Shadow(
                                                                    offset:
                                                                        Offset(
                                                                            1.0,
                                                                            1.0),
                                                                    blurRadius:
                                                                        3.0,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  Shadow(
                                                                    offset:
                                                                        Offset(
                                                                            1.0,
                                                                            1.0),
                                                                    blurRadius:
                                                                        8.0,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                            },
                                            onStackFinished: () {
                                              myController.getMoreTask();
                                            },
                                            itemChanged:
                                                (SwipeItem item, int index) {
                                              print(
                                                  "item: ${item.content.name}, index: $index");
                                            },
                                            upSwipeAllowed: false,
                                            fillSpace: false,
                                          ),
                                        ),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Material(
                          child: InkWell(
                            splashColor: FlutterFlowTheme.secondaryColor,
                            onTap: () async {
                              if (Constant.plan_active == 1) {
                                if (Constant.current_plan == "FREE") {
                                  if (like_user < 5) {
                                    print("nope");
                                    myController.matchEngine.currentItem
                                        ?.nope();
                                  } else {
                                    // showLongToast("Plan Expire");
                                    Get.defaultDialog(
                                      title: Constant.titleText,
                                      radius: 30,
                                      barrierDismissible: false,
                                      content: Column(
                                        children: [
                                          Column(
                                            children: [
                                              const CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: AssetImage(
                                                    "assets/images/logo.png",
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                Constant.description,
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text("Later")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                    Get.to(subscribe());
                                                  },
                                                  child: const Text("Upgrade"))
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                } else {
                                  print("nope");
                                  myController.matchEngine.currentItem?.nope();
                                }
                              } else {
                                // showLongToast("Plan Expire");
                                Get.defaultDialog(
                                  title: Constant.titleText,
                                  radius: 30,
                                  barrierDismissible: false,
                                  content: Column(
                                    children: [
                                      Column(
                                        children: [
                                          const CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                "assets/images/logo.png",
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            Constant.description,
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          OutlinedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text("Later")),
                                          ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                                Get.to(subscribe());
                                              },
                                              child: const Text("Upgrade"))
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.pink,
                                      spreadRadius: 0.9)
                                ],
                              ),
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  // foregroundColor:Colors.pink,
                                  radius: 18,
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.pink,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          child: InkWell(
                            splashColor: FlutterFlowTheme.secondaryColor,
                            onTap: () async {
                              if (Constant.plan_active == 1) {
                                if (Constant.current_plan == "FREE") {
                                  if (like_user < 5) {
                                    print("like");
                                    myController.matchEngine.currentItem
                                        ?.like();
                                  } else {
                                    // showLongToast("Plan Expire");
                                    Get.defaultDialog(
                                      title: Constant.titleText,
                                      radius: 30,
                                      barrierDismissible: false,
                                      content: Column(
                                        children: [
                                          Column(
                                            children: [
                                              const CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: AssetImage(
                                                    "assets/images/logo.png",
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                Constant.description,
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text("Later")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                    Get.to(subscribe());
                                                  },
                                                  child: const Text("Upgrade"))
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                } else {
                                  print("like");
                                  myController.matchEngine.currentItem?.like();
                                }
                              } else {
                                // showLongToast("Plan Expire");

                                Get.defaultDialog(
                                  title: Constant.titleText,
                                  radius: 30,
                                  barrierDismissible: false,
                                  content: Column(
                                    children: [
                                      Column(
                                        children: [
                                          const CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                "assets/images/logo.png",
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            Constant.description,
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          OutlinedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text("Later")),
                                          ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                                Get.to(subscribe());
                                              },
                                              child: const Text("Upgrade"))
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.pink,
                                      spreadRadius: 0.5)
                                ],
                              ),
                              child: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    "assets/images/discover.png",
                                  )),
                            ),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          child: InkWell(
                            splashColor: FlutterFlowTheme.secondaryColor,
                            onTap: () {
                              // _onAddcontactsClicked(context);
                              // getPermissions();
                              checkpermission_opencamera();
                            },
                            child: Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.pink,
                                      spreadRadius: 0.9)
                                ],
                              ),
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  // foregroundColor:Colors.pink,
                                  radius: 18,
                                  child: Icon(
                                    Icons.star_border,
                                    size: 18,
                                    color: Colors.pink,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  getPermissions() async {
    final PermissionStatus? permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Get.to(UserList());
    } else if (permissionStatus == PermissionStatus.denied) {
      _onAddcontactsClicked(context);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _onAddcontactsClicked(context);
    }
  }

  Future<PermissionStatus?> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else if (permission == PermissionStatus.permanentlyDenied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else {
      return permission;
    }
  }

  _onAddcontactsClicked(context) async {
    Permission permission;

    if (Platform.isIOS) {
      // permission = Permission.photos;
      permission = Permission.contacts;
    } else {
      // permission = Permission.storage;
      permission = Permission.contacts;
    }

    PermissionStatus permissionStatus = await permission.status;
    if (!permissionStatus.isGranted) {
      await Permission.contacts.request();
    }
    if (await Permission.contacts.request().isGranted) {
      return;
    } else {
      print("permission");
      await Permission.contacts.request();
    }

    print(permissionStatus);

    if (permissionStatus == PermissionStatus.restricted) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted

        return;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      print('Permission granted');
      Get.to(UserList());
    }
  }

  _showOpenAppSettingsDialog(context) async {
    print('Permission denied');
    await openAppSettings();
  }

  checkpermission_opencamera() async {
    var photosStatus = await Permission.contacts.status;

    if (!photosStatus.isGranted) {
      await Permission.contacts.request();
    }
    if (await Permission.contacts.request().isGranted) {
      Get.to(UserList());
    } else {
      print("permission");
      await Permission.contacts.request();
    }
    Get.to(UserList());
  }
}

class Content {
  final String id;
  final String name;
  final String age;
  final String location;
  final String imgurl;

  Content(
      {required this.id,
      required this.name,
      required this.age,
      required this.location,
      required this.imgurl});
}
