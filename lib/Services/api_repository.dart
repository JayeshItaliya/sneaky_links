import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sneaky_links/Models/LoginModal.dart';
import 'package:sneaky_links/Models/PartyModel.dart';
import 'package:sneaky_links/Pages/AuthScreen/signIn.dart';


Future<dynamic> receipt_dataSave() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  debugPrint("+++");
  debugPrint("recepitData=>" + Constant.current_plan);
  // EasyLoading.show(status: "Loading...");
  try {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };
    var request =
    http.Request('POST', Uri.parse(Constant.subscription + "/save"));
    request.body = json.encode({
      "receipt": {
        "receipt": Constant.receipt,
        "expiredate": pref.getInt(Constant.user_id + "expiredate") ?? 0,
        "month": Constant.currentM,
        "likerejectcount": pref.getInt(Constant.user_id + "like_user") ?? 0,
        "partycount": pref.getInt(Constant.user_id + "free_party_join") ?? 0,
        "messagecount":pref.getInt(Constant.user_id + "message_exp") ?? 0,
      },
      "planName": Constant.current_plan.toLowerCase()=="free"?"VOYEUR":Constant.current_plan.toLowerCase()=="platinum"?"PREMIUM":Constant.current_plan.toUpperCase(),
      "productId": pref.getString(Constant.user_id + "productID") ?? "0",
      "platform": Constant.device_type
    });

   request.headers.addAll(headers);
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);
    debugPrint("StatusCode");
    debugPrint(response.statusCode.toString());
    debugPrint(jsonBody.toString());
    if (response.statusCode == 200) {
      // EasyLoading.showSuccess(jsonBody['message']);

      return jsonBody;
      // notifyListeners();
    } else {
      EasyLoading.showError(Constant.current_plan + jsonBody['message']);
    }
  } catch (e) {
    EasyLoading.showError("Oops!");
    if (e is SocketException) {
      showLongToast("Could not connect to internet");
    }
  }
}

Future updateToken() async {
  // EasyLoading.show(status: "Loading...");

  SharedPreferences pref = await SharedPreferences.getInstance();
  debugPrint("*****************" + Constant.device_token.toString());

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + Constant.access_token
  };

  try {
    var request = http.Request('POST', Uri.parse(Constant.updateToken));
    request.body = json.encode({
      "deviceToken": Constant.device_token,
      "deviceId": Constant.deviceId,
      "platform": Constant.device_type
    });
    request.headers.addAll(headers);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);

    debugPrint(jsonBody.toString());

    if (response.statusCode == 200) {
      // EasyLoading.dismiss();
    } else if (response.statusCode == 401) {
      // EasyLoading.dismiss();

      pref.setString("username", "");
      pref.setString("email", "");
      // pref.setString("accessToken", "");
      pref.setBool("isLogin", false);
      Get.offAll(SignIn());
    } else {
      // EasyLoading.dismiss();
      // EasyLoading.showError(jsonBody.toString());
    }
  } catch (e) {
    debugPrint(e.toString());
    // EasyLoading.showError("Oops!");
    if (e is SocketException) {
      showLongToast("Could not connect to internet");
    }
  }
}

// Fetch Data
Future<GetProfile?> getProfile() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var headers = {'Authorization': 'Bearer ' + Constant.access_token};
  try {
    var request = http.Request('GET', Uri.parse(Constant.getProfile));
    request.headers.addAll(headers);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);
    print(jsonBody['data']);
    if (response.statusCode == 200) {

      GetProfile list = GetProfile.fromJson(jsonBody['data']);
      return list;
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();

      pref.setString("username", "");
      pref.setString("email", "");
      // pref.setString("accessToken", "");
      pref.setBool("isLogin", false);
      Get.offAll(SignIn());
    } else {
      EasyLoading.showError(jsonBody['message']);
    }
  } catch (e) {
    if (e is SocketException) showLongToast("Could not connect to internet");
  }
} // Fetch Dat

// Fetch Data
Future<PartyModel?> getRoomDetails(id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var headers = {'Authorization': 'Bearer ' + Constant.access_token};
  try {
    var request = http.Request('GET', Uri.parse(Constant.createRoom + "/$id"));
    request.headers.addAll(headers);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);
    if (response.statusCode == 200) {
      PartyModel list = PartyModel.fromJson(jsonBody['data']);
      return list;
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();

      pref.setString("username", "");
      pref.setString("email", "");
      // pref.setString("accessToken", "");
      pref.setBool("isLogin", false);
      Get.offAll(SignIn());
    } else {
      EasyLoading.showError(jsonBody['message']);
    }
  } catch (e) {
    if (e is SocketException) showLongToast("Could not connect to internet");
  }
} // Fetch Data

Future<UProfile?> getProfileDetails(id) async {
  debugPrint("" + id);
  SharedPreferences pref = await SharedPreferences.getInstance();
  var headers = {'Authorization': 'Bearer ' + Constant.access_token};
  try {
    var request = http.Request('GET', Uri.parse(Constant.getUsersId + "/$id"));
    request.headers.addAll(headers);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);
    debugPrint(jsonBody.toString());

    if (response.statusCode == 200) {
      UProfile list = UProfile.fromJson(jsonBody['data']);

      return list;
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();

      pref.setString("username", "");
      pref.setString("email", "");
      pref.setBool("isLogin", false);
      Get.offAll(SignIn());
    } else {
      debugPrint(jsonBody['message']);
      EasyLoading.showError(jsonBody['message']);
    }
  } catch (e) {
    if (e is SocketException) showLongToast("Could not connect to internet");
  }
} // Fetch Data

Future<DynamicModel?> getDev() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var headers = {'Authorization': 'Bearer ' + Constant.access_token};
  try {
    var request = http.Request('GET', Uri.parse(Constant.getdev));
    request.headers.addAll(headers);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);
    debugPrint(jsonBody.toString());

    if (response.statusCode == 200) {
      DynamicModel list = DynamicModel.fromJson(jsonBody['data']);

      return list;
    } else if (response.statusCode == 200) {
      EasyLoading.showError(jsonBody['message']);
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();

      pref.setString("username", "");
      pref.setString("email", "");
      // pref.setString("accessToken", "");
      pref.setBool("isLogin", false);
      Get.offAll(SignIn());
    } else {
      EasyLoading.showError(jsonBody['message']);
    }
  } catch (e) {
    if (e is SocketException) showLongToast("Could not connect to internet");
  }
}

Future rejectCall() async {
  // EasyLoading.show(status: "Loading...");

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + Constant.access_token
  };

  try {
    var request = http.Request('POST', Uri.parse(Constant.reject_call));
    request.body = json.encode({
      "userId": Constant.senderId,
    });
    request.headers.addAll(headers);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);

    debugPrint("++++++++" + jsonBody.toString());

  } catch (e) {
    // EasyLoading.showError("Oops!");
    if (e is SocketException) {
      showLongToast("Could not connect to internet");
    }
  }
}

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    if (diff.inHours >= 1) {
      time = diff.inHours.toString() + ' HOURS AGO';
    } else {
      time = format.format(date);
    }
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' DAY AGO';
    } else {
      time = diff.inDays.toString() + ' DAYS AGO';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
    }
  }

  return time;
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    if (Platform.isIOS) {
      Get.defaultDialog(
          middleText: "Hello world!",
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.white),
          middleTextStyle: TextStyle(color: Colors.white),
          // textConfirm: "Ok",
          textCancel: "OK",
          cancelTextColor: Colors.pink,
          // confirmTextColor: Colors.white,
          buttonColor: Colors.pinkAccent,
          barrierDismissible: false,
          radius: 50,
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 20),
                child: Text(
                  "Turn on Location Services \nfor your iPhone",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                ),
              ),
              ListTile(
                  title: Text(
                    '1. Open the Settings app',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: Image.asset(
                    "assets/images/settings1.jpeg",
                    fit: BoxFit.cover,
                  )),
              SizedBox(height: 15),
              ListTile(
                  title: Text(
                    '2. Select Privacy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: Image.asset(
                    "assets/images/privacy.jpg",
                    fit: BoxFit.cover,
                  )),
              SizedBox(height: 15),
              ListTile(
                  title: Text(
                    '3. Select Location  Services',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: Image.asset(
                    "assets/images/gps.jpeg",
                    fit: BoxFit.cover,
                  )),
              SizedBox(height: 15),
              ListTile(
                  title: Text(
                    '4. Turn on Location Services',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: Container(
                    height: 30,
                    child: Image.asset(
                      "assets/images/switch.jpg",
                      fit: BoxFit.cover,
                    ),
                  )),
            ],
          ));
    }
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // await Geolocator.requestPermission();
      AppSettings.openLocationSettings();
      // return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // await Geolocator.requestPermission();
    AppSettings.openLocationSettings();
    // return Future.error(
    //     'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

// Fetch Data
Future updateOptions() async {
  EasyLoading.show(status: "Loading...");

  SharedPreferences pref = await SharedPreferences.getInstance();
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + Constant.access_token
  };

  try {
    var request = http.Request('POST', Uri.parse(Constant.updateOptions));
    request.body = json.encode({
      "onlyUpgradedMembersCanMessage": Constant.upgradedMembermsg,
      // "autoIntervalDeleteInSeconds": Constant.AutoIntervals,
      "onlyMembersWithProfileCanMessage": Constant.membersWithProfile,
      "gender": Constant.gender=="null"?null:Constant.gender
    });
    request.headers.addAll(headers);
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);
    debugPrint(jsonBody.toString());

    if (response.statusCode == 200) {
      debugPrint(jsonBody.toString());
      EasyLoading.dismiss();
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();

      pref.setString("username", "");
      pref.setString("email", "");
      // pref.setString("accessToken", "");
      pref.setBool("isLogin", false);
      Get.offAll(SignIn());
    } else {
      EasyLoading.dismiss();
      // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
    }
  } catch (e) {
    debugPrint(e.toString());
    EasyLoading.showError("Oops!");
    if (e is SocketException) {
      showLongToast("Could not connect to internet");
    }
  }
}
