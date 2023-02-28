import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Models/LoginModal.dart';
import 'package:sneaky_links/controllers/task_provider.dart';

class UserController extends GetxController {

  var isDataProcessing = false.obs;

  var isMoreDataAvailable = false.obs;
  int currentPage = 1;
  late StreamSubscription subscription;
  var isoffline = false.obs;

  UserData? data1;
  bool? checkNetwork(){
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isoffline.value=true;
      } else if (result == ConnectivityResult.mobile) {
        isoffline.value=false;
      } else if (result == ConnectivityResult.wifi) {
        isoffline.value=false;
      }
      else{
        Get.snackbar("Network Error","Failed to get network connection");
        isoffline.value=true;
      }
    });
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getTask();
    checkNetwork();
  }



  void getTask() {
    try {
      if(isoffline.value==false) {
        isDataProcessing.value = true;
        TaskProvider().getProfile().then((resp) {
          isDataProcessing.value = false;
         data1=resp;
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


}
