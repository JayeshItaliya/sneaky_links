import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/HideModel.dart';
import 'package:sneaky_links/Models/LoginModal.dart';
import 'package:sneaky_links/Models/PartyModel.dart';
import 'package:sneaky_links/Models/PartyPostModel.dart';
import 'package:sneaky_links/Models/UserModel.dart';
import 'package:sneaky_links/Models/addPhotosmodel.dart';
import 'package:sneaky_links/Models/chatModel.dart';
import 'package:sneaky_links/Models/recentModel.dart';
import 'package:sneaky_links/Pages/AuthScreen/signIn.dart';

import '../Models/CommentModel.dart';
import '../Models/MsgModel.dart';
import '../Models/notiModel.dart';

class TaskProvider extends GetConnect {


  Future<dynamic> joinParty(id, pass) async {
    // EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
      http.Request('POST', Uri.parse(Constant.createRoom + "/$id/join"));
      request.body = json.encode({"passcode": pass});
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();

        return jsonBody['message'];
      } else {
        // if(pass!="")
        // EasyLoading.showError(jsonBody['message']);
        // else
        EasyLoading.dismiss();
        return null;
      }
    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
      return null;
    }
  }

  // Fetch Data
  Future<UserData?> getProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      var request = http.Request('GET', Uri.parse(Constant.getProfile));
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        if (jsonBody['result']) {
          UserData list = UserData.fromJson(jsonBody['data']);

          return list;
        } else {
          EasyLoading.showError(jsonBody['message']);
        }
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

  // Fetch Data Home
  Future<List<UserModel>?> fetchUserList(page, search) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.getUsers +
              "?page=${page}&perPage=${Constant.Per_Page}&search=$search"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['users'];
        List<UserModel> list = UserModel.getListFromJson(jsonbody1);
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
  }

  // Fetch Data Home
  Future<List<UserlikesModel>?> fetchUserLikes(page, search) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.getUserslike +
              "?page=${page}&perPage=${Constant.Per_Page}&search=$search"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      debugPrint(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['users'];
        List<UserlikesModel> list = UserlikesModel.getListFromJson(jsonbody1);
        debugPrint(list.length.toString());
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody['message']);
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  // Fetch Data Home
  Future<List<UserlikesModel>?> fetchMyLikes(page, search) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.getMylike +
              "?page=${page}&perPage=${Constant.Per_Page}&search=$search"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['users'];
        List<UserlikesModel> list = UserlikesModel.getListFromJson(jsonbody1);
        print(list.length);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody['message']);
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  Future<List<AllPhotosModel>?> fetchUserPhotos() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request = http.Request('GET', Uri.parse(Constant.getUsersPhotos));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<AllPhotosModel> list = AllPhotosModel.getListFromJson(jsonbody1);
        print(list.length);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody['message']);
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  // Fetch Data Home
  Future<List<UserModel>?> fetchNearbyUser(page, lat, lng) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.getUsers +
              "?page=${page}&perPage=${Constant.Per_Page}&isShowNearBy=true&latitude=$lat&longitude=$lng"));

      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['users'];
        List<UserModel> list = UserModel.getListFromJson(jsonbody1);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody['message']);
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  // Fetch Data Home
  Future<List<UserModel>?> fetchNearbyUser1(
      page,
      lat,
      lng,
      Age,
      zip,
      choice,
      Height,
      Sal,
      pFavors,
      pPicture,
      EduType,
      EthniType,
      BType,
      InterestedType,
      String eWidth,
      String eHeight) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      print(eHeight);
      print(eWidth);

      print(Constant.getUsers +
          "?page=${page}&perPage=${Constant.Per_Page}&isShowNearBy=true&latitude=$lat&longitude=$lng&age=$Age&zipcode=$zip&gender=$choice&endowmentWidth=$eWidth&endowmentHeight=$eHeight&height=$Height&education=$EduType&ethnicity=$EthniType&bodytype=$BType&partyFavors=$pFavors&interestedIn=$InterestedType&profilePicture=$pPicture");
      // var request = http.Request(
      //     'GET',
      //     Uri.parse(Constant.getUsers +
      //         "?page=${page}&perPage=${Constant.Per_Page}&isShowNearBy=false&latitude=$lat&longitude=$lng&age=$Age&zipcode=$zip&location=$zip&height=$Height&education=$EduType&ethnicity=$EthniType&bodytype=$BType&income=30000,60000&partyFavors=$pFavors&interestedIn=$InterestedType&profilePicture=$pPicture"));
      var request = http.Request(
          'GET',
          Uri.parse(Constant.getUsers +
              "?page=${page}&perPage=${Constant.Per_Page}&isShowNearBy=true&latitude=$lat&longitude=$lng&age=$Age&zipcode=$zip&gender=$choice&endowmentWidth=$eWidth&endowmentHeight=$eHeight&height=$Height&education=$EduType&ethnicity=$EthniType&bodytype=$BType&partyFavors=$pFavors&interestedIn=$InterestedType&profilePicture=$pPicture"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("++____+++++_____+" + jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['users'];
        List<UserModel> list = UserModel.getListFromJson(jsonbody1);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody['message']);
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  // Fetch Data Home
  Future<List<UserModel>?> fetchBlockList(page, search) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.getUsers +
              "?page=${page}&perPage=${Constant.Per_Page}&isShowNearBy=false&search=$search&isblock=true"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['users'];
        List<UserModel>? list = UserModel.getListFromJson(jsonbody1);
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
  }

  // Fetch Data Home
  Future<List<HideModel>?> fetchHideList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request = http.Request('GET', Uri.parse(Constant.getUsershide));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<HideModel>? list = HideModel.getListFromJson(jsonbody1);
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
  }

  // Fetch Data Home
  Future<List<PartyModel>?> fetchPartyList(page, search, isnearby) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    print(headers.toString());

    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.createRoom +
              "?page=${page}&perPage=30&search=$search&isShowNearBy=$isnearby"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<PartyModel>? list = PartyModel.getListFromJson(jsonbody1);
        print(list.toString());
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
  }

  // Fetch Data Home
  Future<List<PartyModel>?> fetchPartyNList(
      page, search, isnearby, lat, lng) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.createRoom +
              "?page=${page}&perPage=${Constant.Per_Page}&search=$search&isShowNearBy=$isnearby&latitude=$lat&longitude=$lng"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<PartyModel>? list = PartyModel.getListFromJson(jsonbody1);
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
  }

  // Fetch Party Post
  Future<List<PartyPostModel>?> fetchPartyPostList(page, id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.createRoom +
              "/$id/post?page=$page&perPage=${Constant.Per_Page}"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<PartyPostModel>? list = PartyPostModel.getListFromJson(jsonbody1);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());

      } else {
        print(jsonBody.toString());
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  // Fetch User Post
  Future<List<PartyPostModel>?> fetchUserPostList(page, id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer '+Constant.access_token};

    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.userPosts + "?userId=$id&page=$page&perPage=${Constant.Per_Page}"));
      // var request = http.Request('GET', Uri.parse('http://54.167.189.102/api/v1/posts?userId=8&page=2&perPage=1'));

      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("++++++++");

      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<PartyPostModel>? list = PartyPostModel.getListFromJson(jsonbody1);
        print("++++++++");
        print(list.toString());

        return list;

      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print("++++++++");
        print(jsonBody.toString());
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      print("++++++++");
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  // Fetch Data Home
  Future<List<CommentModel>?> fetchPartyPostCommentList(page, id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.createPosts +
              "/$id/comment?page=${page}&perPage=${Constant.Per_Page}"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<CommentModel>? list = CommentModel.getListFromJson(jsonbody1);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody.toString());
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  // Fetch Data Home
  Future<List<CommentRModel>?> fetchPartyPostCommentRList(page, id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.createComments +
              "/$id/reply?page=${page}&perPage=${Constant.Per_Page}"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<CommentRModel>? list = CommentRModel.getListFromJson(jsonbody1);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody.toString());
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  // Fetch Data Home
  Future<List<RecentModel>?> getRecentPeople(page, search) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.getchat +
              "?page=${page}&perPage=${Constant.Per_Page}&search=$search"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      // print(jsonBody.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<RecentModel>? list = RecentModel.getListFromJson(jsonbody1);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody.toString());
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  // Fetch Data viewer
  Future<List<ViewersModel>?> getViewers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      var request = http.Request('GET', Uri.parse(Constant.profile_views));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<ViewersModel>? list = ViewersModel.getListFromJson(jsonbody1);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody.toString());
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  Future<List<ChatModel>?> getIndiChats(page, id, search) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      var request = http.Request(
          'GET',
          Uri.parse(Constant.chatMsg +
              "/$id?page=${page}&perPage=${Constant.Per_Page}&search=$search"));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<ChatModel>? list = ChatModel.getListFromJson(jsonbody1);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody.toString());
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }

  Future<List<NotiModel>?> getNotifications() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      var request = http.Request('GET', Uri.parse(Constant.getNoti));
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (response.statusCode == 200) {
        List<dynamic> jsonbody1 = jsonBody['data'];
        List<NotiModel>? list = NotiModel.getListFromJson(jsonbody1);
        return list;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        print(jsonBody.toString());
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      if (e is SocketException) showLongToast("Could not connect to internet");
    }
  }
}
