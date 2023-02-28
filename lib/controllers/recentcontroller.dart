import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Models/UserModel.dart';
import 'package:sneaky_links/Models/recentModel.dart';
import 'package:sneaky_links/controllers/task_provider.dart';

import '../Components/constants.dart';

class RecentController extends GetxController {
  String search = "";
  var myList = List<RecentModel>.empty(growable: true).obs;
  var page = 1;
  var isDataProcessing = false.obs;

  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = false.obs;
  int currentPage = 1;
  StreamSubscription? subscription;
  var isoffline = false.obs;

  String id = "";

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
        TaskProvider()
            .getRecentPeople(page,search)
            .then((resp) {
          isDataProcessing.value = false;
          if(resp!=null) {
            myList.clear();
            myList.addAll(resp);
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
      TaskProvider()
          .getRecentPeople(page,search)
          .then((resp) {
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

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();
  }

}
