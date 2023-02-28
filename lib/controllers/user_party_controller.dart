import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Models/PartyModel.dart';
import 'package:sneaky_links/controllers/task_provider.dart';
import 'package:http/http.dart' as http;
import '../Components/constants.dart';

class UserPartyController extends GetxController {
  String search = "";
  var myList = List<PartyModel>.empty(growable: true).obs;
  var page = 1;
  var isDataProcessing = false.obs;
  var isnearby = false;
  Position? position;

  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = false.obs;
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


  Future<void> getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getCurrentPosition();
    getTask(page);
    checkNetwork();
    paginateTask();
  }

  void updateData(search) {
    this.search = search;
    page = 1;
    getTask(page);
  }

  void getTask(var page) {
    try {
      if (isoffline.value == false) {
        isDataProcessing.value = true;
        TaskProvider().fetchPartyList(
          page,
          search,
            isnearby,
        ).then((resp) {
          isDataProcessing.value = false;
          myList.clear();
          myList.addAll(resp!);
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

  showSnackbar(title, message, color) {
    Get.snackbar(title, message,
        colorText: Colors.white, backgroundColor: color);
  }

  void paginateTask() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reach End");
        page++;
        getMoreTask(page);
      }
    });
  }

  void getMoreTask(var page) {
    try {
      isMoreDataAvailable.value = true;
      TaskProvider().fetchPartyList(
        page,
        search,
        isnearby,
      ).then((resp) {
        if (resp!.length > 0) {
          isMoreDataAvailable.value = false;
        } else {
          isMoreDataAvailable.value = false;
          showLongToast("No more item");
        }
        myList.addAll(resp);
      }, onError: (err) {
        isDataProcessing.value = false;
        showSnackbar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isDataProcessing.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }

  Future joinParty(id,pass) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer '+Constant.access_token
    };

    try {
      var request = http.Request(
          'POST', Uri.parse(Constant.createRoom  + "/$id/join"));
      request.body = json.encode({
        "passcode": pass
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("++++++++"+jsonBody.toString());
      if (response.statusCode == 200) {
        // EasyLoading.showSuccess(jsonBody['message']);
        EasyLoading.dismiss();

        return jsonBody['message'];

      } else {
        if(pass!="")
        EasyLoading.showError(jsonBody['message']);
        else
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();
  }

}
