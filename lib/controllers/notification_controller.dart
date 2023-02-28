import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/controllers/task_provider.dart';

import '../Models/notiModel.dart';

class NotificationController extends GetxController {
  var myList = List<NotiModel>.empty(growable: true).obs;
  var page = 1;
  var isDataProcessing = false.obs;

  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = false.obs;
  int currentPage = 1;
  StreamSubscription? subscription;
  var isoffline = false.obs;

  var perPage =1;

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

  void updateData(id,search) {
    page = 1;
    getTask(page);
  }

  void getTask(var page) {
    try {
      if (isoffline.value == false) {
        isDataProcessing.value = true;
        TaskProvider()
            .getNotifications()
            .then((resp) {
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
        page++;
        getMoreTask(page);
      }
    });
  }

  void getMoreTask(var page) {
    try {
      isMoreDataAvailable.value = true;
      TaskProvider()
          .getNotifications()
          .then((resp) {
        if (resp!.length > 0) {
          isMoreDataAvailable.value = false;
        } else {
          isMoreDataAvailable.value = false;
          // showLongToast("No more item");
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
