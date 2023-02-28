import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Models/UserModel.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import 'package:sneaky_links/controllers/task_provider.dart';

import '../Components/constants.dart';

class UsersController extends GetxController {
  var myList = List<UserModel>.empty(growable: true).obs;
  var page = 1;
  var isDataProcessing = false.obs;
  Position? position;
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = false.obs;
  int currentPage = 1;
  StreamSubscription? subscription;
  var isoffline = false.obs;
  var nearby = true.obs;

  var choice = "";
  var zip = "";
  String Age = "";
  String Height = "";
  String eHeight = "";
  String eWidth = "";
  String Sal = "";

  String pFavors = "";
  String pPicture = "";

  List<int> EduType = [];
  List<int> EthniType = [];
  List<int> BType = [];
  List<int> InterestedType = [];

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

  void updateData(search,value) {
    page = 1;
    nearby.value =value;
    getTask(page);
  }

  Future<void> getTask(var page) async {
    myList.clear();

    try {
      isDataProcessing.value = true;

      await determinePosition().then((value) {
        position = value;
      });
      if (isoffline.value == false) {
        if (nearby.value == true) {
          TaskProvider()
              .fetchNearbyUser(page, position!.latitude, position!.longitude,)
              .then((resp) {
            isDataProcessing.value = false;
            myList.clear();
            myList.addAll(resp!);
            // print(myList.length);
          }, onError: (err) {
            isDataProcessing.value = false;
            showSnackbar("Error", err.toString(), Colors.red);
          });
        } else {
          TaskProvider()
              .fetchNearbyUser1(page, position!.latitude, position!.latitude,Age, zip,choice, Height, Sal, pFavors, pPicture,
              EduType.join(','), EthniType.join(','), BType.join(','), InterestedType.join(','),eWidth,eHeight)
              .then((resp) {
            isDataProcessing.value = false;
            myList.clear();
            myList.addAll(resp!);
          }, onError: (err) {
            isDataProcessing.value = false;
            showSnackbar("Error", err.toString(), Colors.red);
          });
        }
      }
    } catch (e) {
      isDataProcessing.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }

  Future getLocationFromzip() async {
    try {
      print("ZAIPCODE=====>"+zip);
      var request = http.Request('GET', Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=%22.urlencode($zip).%22&sensor=false&key=AIzaSyD0m8JnmV6vqpyqnahX0AQtlAazpzGKZ08'));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("Resposnce=>>${response.statusCode}");
      print("Url Link=>>$request");
      print("++++++++rr"+jsonBody.toString());
      print("++++++++"+jsonBody['results']['geometry']['location'].toString());
      print("Resposnce=>>${response.statusCode}");
      if (response.statusCode == 200|| response.statusCode==201) {
        print("Resposnce=>>${response.statusCode}");
        print(jsonBody['results']['geometry']['location'].toString());
        TaskProvider()
            .fetchNearbyUser1(page, jsonBody['results']['geometry']['location']['lat'], jsonBody['results']['geometry']['location']['lng'],Age, "", choice, Height, Sal, pFavors, pPicture,
            EduType.join(','), EthniType.join(','), BType.join(','), InterestedType.join(','),eWidth,eHeight)
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
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
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

  Future<void> getMoreTask(var page) async {
    try {
      isMoreDataAvailable.value = true;
      await determinePosition().then((value) {
        position = value;
      });
      if (isoffline.value == false) {
        if (nearby.value == true) {
          TaskProvider()
              .fetchNearbyUser(page, position!.latitude, position!.longitude)
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
        } else {
          TaskProvider()
              .fetchNearbyUser1(page, position!.latitude, position!.latitude,Age, zip,choice, Height, Sal, pFavors, pPicture,
              EduType.join(','), EthniType.join(','), BType.join(','), InterestedType.join(','),eWidth,eHeight)
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
        }
      }
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
