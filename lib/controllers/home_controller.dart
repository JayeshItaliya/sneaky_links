import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/ProfileScreen/subscribe.dart';
import 'package:sneaky_links/controllers/task_provider.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../Models/UserModel.dart';
import '../Pages/DiscoverScreen/discover_page.dart';
import '../Services/api_repository.dart';

class HomeController extends GetxController {
  String search = "";
  var homeList = List<UserModel>.empty(growable: true).obs;
  var page = 1;
  var isDataProcessing = false.obs;
  var swipeItems = List<SwipeItem>.empty(growable: true).obs;
  late MatchEngine matchEngine = MatchEngine();
  var empty = false.obs;
  var isMoreDataAvailable = false.obs;
  var ishidelike = false.obs;
  int currentPage = 1;
  StreamSubscription? subscription;
  var isoffline = false.obs;

  bool? checkNetwork() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isoffline.value = true;
      } else if (result == ConnectivityResult.mobile) {
        isoffline.value = false;
      } else if (result == ConnectivityResult.wifi) {
        isoffline.value = false;
      } else {
        Get.snackbar("Network Error", "Failed to get network connection");
        isoffline.value = true;
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkNetwork();
    getTask(page);
  }

  void updateData(s) {
    page = 1;
    search = s;
    getTask(page);
  }

  void getTask(var page) {
    try {
      if (isoffline.value == false) {
        isDataProcessing.value = true;
        TaskProvider().fetchUserList(page, search).then((resp) {
          if (resp != null) {
            homeList.clear();
            homeList.addAll(resp);
            setCards();
          }
        }, onError: (err) {
          isDataProcessing.value = false;
          showSnackbar("Error", err.toString(), Colors.red);
        });
      }
    } catch (e) {
      isDataProcessing.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }

  void getMoreTask() {
    try {
      isMoreDataAvailable.value = true;
      TaskProvider().fetchUserList(page++, search).then((resp) {
        if (resp!.length > 0) {
          isMoreDataAvailable.value = false;
        } else {
          isMoreDataAvailable.value = false;
          showLongToast("No more item");
        }
        if (resp != null) {
          homeList.clear();
          homeList.addAll(resp);
          setCards();
        }
      }, onError: (err) {
        isDataProcessing.value = false;
        showSnackbar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isDataProcessing.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }

  setCards() {
    for (int i = 0; i < homeList.length; i++) {
      swipeItems.add(SwipeItem(
          content: Content(
              id: homeList[i].id.toString(),
              name: homeList[i].username,
              age: homeList[i].age.toString(),
              location: homeList[i].location,
              imgurl: homeList[i].profilePicture),
          likeAction: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            int like_user = pref.getInt(Constant.user_id + "like_user") ?? 0;
            if (Constant.plan_active == 1) {
              if (Constant.current_plan == "FREE") {
                if (like_user < 5) {
                  print("likeAction");
                  likeP(homeList[i].id);
                  like_user++;
                  pref.setInt(Constant.user_id + "like_user", like_user);
                  receipt_dataSave().then((value) {
                  });
                  if (like_user == 5) {
                    ishidelike.value = true;
                    Get.defaultDialog(
                      title: Constant.titleText,
                      radius: 30,
                      barrierDismissible: false,
                      content:Column(
                        children: [
                          Column(
                            children:   [
                              const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  backgroundImage:AssetImage("assets/images/logo.png",)
                              ),
                              const SizedBox(height: 10,),
                              Text(Constant.description,textAlign:TextAlign.center,)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment:MainAxisAlignment.spaceAround,
                            children: [
                              OutlinedButton(
                                  onPressed:(){
                                    Get.back();
                                  },
                                  child:const Text("Later")
                              ),
                              ElevatedButton(
                                  onPressed:(){
                                    Get.back();
                                    Get.to(subscribe());
                                  },
                                  child:const Text("Upgrade")
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  // showLongToast("Plan Expire");
                  Get.defaultDialog(
                    title: Constant.titleText,
                    radius: 30,
                    barrierDismissible: false,
                    content:Column(
                      children: [
                        Column(
                          children:   [
                            const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage:AssetImage("assets/images/logo.png",)
                            ),
                            const SizedBox(height: 10,),
                            Text(Constant.description,textAlign:TextAlign.center,)
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            OutlinedButton(
                                onPressed:(){
                                  Get.back();
                                },
                                child:const Text("Later")
                            ),
                            ElevatedButton(
                                onPressed:(){
                                  Get.back();
                                  Get.to(subscribe());
                                },
                                child:const Text("Upgrade")
                            )
                          ],
                        )
                      ],
                    ),
                  );
                  ishidelike.value = true;
                }
              } else {
                likeP(homeList[i].id);
              }
            } else {
              // showLongToast("Plan Expire");
              Get.defaultDialog(
                title: Constant.titleText,
                radius: 30,
                barrierDismissible: false,
                content:Column(
                  children: [
                    Column(
                      children:   [
                        const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage:AssetImage("assets/images/logo.png",)
                        ),
                        const SizedBox(height: 10,),
                        Text(Constant.description,textAlign:TextAlign.center,)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                            onPressed:(){
                              Get.back();
                            },
                            child:const Text("Later")
                        ),
                        ElevatedButton(
                            onPressed:(){
                              Get.back();
                              Get.to(subscribe());
                            },
                            child:const Text("Upgrade")
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          },
          nopeAction: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            int like_user = pref.getInt(Constant.user_id + "like_user") ?? 0;

            if (Constant.plan_active == 1) {
              if (Constant.current_plan == "FREE") {
                if (like_user < 5) {
                  print("nopeAction");
                  rejectP(homeList[i].id);
                  like_user++;
                  pref.setInt(Constant.user_id + "like_user", like_user);
                  receipt_dataSave().then((value) {
                  });
                  if (like_user == 5) ishidelike.value = true;
                } else {
                  // showLongToast("Plan Expire");
                  ishidelike.value = true;
                  Get.defaultDialog(
                    title: Constant.titleText,
                    radius: 30,
                    barrierDismissible: false,
                    content:Column(
                      children: [
                        Column(
                          children:   [
                            const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage:AssetImage("assets/images/logo.png",)
                            ),
                            const SizedBox(height: 10,),
                            Text(Constant.description,textAlign:TextAlign.center,)
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            OutlinedButton(
                                onPressed:(){
                                  Get.back();
                                },
                                child:const Text("Later")
                            ),
                            ElevatedButton(
                                onPressed:(){
                                  Get.back();
                                  Get.to(subscribe());
                                },
                                child:const Text("Upgrade")
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }
              } else {
                rejectP(homeList[i].id);
              }
            } else {
              // showLongToast("Plan Expire");
              Get.defaultDialog(
                title: Constant.titleText,
                radius: 30,
                barrierDismissible: false,
                content:Column(
                  children: [
                    Column(
                      children:   [
                        const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage:AssetImage("assets/images/logo.png",)
                        ),
                        const SizedBox(height: 10,),
                        Text(Constant.description,textAlign:TextAlign.center,)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                            onPressed:(){
                              Get.back();
                            },
                            child:const Text("Later")
                        ),
                        ElevatedButton(
                            onPressed:(){
                              Get.back();
                              Get.to(subscribe());
                            },
                            child:const Text("Upgrade")
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          },
          superlikeAction: () {},
          onSlideUpdate: (SlideRegion? region) async {
            print("Region $region");
          }));
    }
    matchEngine = MatchEngine(swipeItems: swipeItems);
    isDataProcessing.value = false;
  }

  Future likeP(id) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.Request('POST', Uri.parse(Constant.getUsersId + "/like"));
      request.body = json.encode({"matchedUserId": id, "status": 1});
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("++++++++" + jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        homeList.removeWhere(((item) => item.id == id));
        update();
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

  Future rejectP(id) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.Request('POST', Uri.parse(Constant.getUsersId + "/like"));
      request.body = json.encode({"matchedUserId": id, "status": 0});
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("++++++++" + jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        homeList.removeWhere(((item) => item.id == id));
        update();
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

  showSnackbar(title, message, color) {
    Get.snackbar(title, message,
        colorText: Colors.white, backgroundColor: color);
  }
}
