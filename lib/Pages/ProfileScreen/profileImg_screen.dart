import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Pages/message/photoView.dart';

import '../../Components/constants.dart';
import 'package:http/http.dart' as http;

import '../../Models/addPhotosmodel.dart';
import '../../controllers/addpicController.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class ProfileImgScreen extends StatefulWidget {
  const ProfileImgScreen({Key? key}) : super(key: key);

  @override
  _ProfileImgScreenState createState() => _ProfileImgScreenState();
}

class _ProfileImgScreenState extends State<ProfileImgScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<String>? imagepathlist = [];
  bool save = true;
  final myController = Get.put(AddPicController());

  void selectImages() async {
    checkpermission_opencamera();

    final List<XFile>? selectedImages = await imagePicker.pickMultiImage(
        imageQuality: 70, maxHeight: 280, maxWidth: 640);
    if (selectedImages!.isNotEmpty && selectedImages.length < 5) {
      if (myController.myList.length < 5) {
        imageFileList!.addAll(selectedImages);
        debugPrint("Image List Length:" + imageFileList!.length.toString());
        debugPrint(imageFileList![0].path);
        setState(() {
          save = false;
        });
        // _updateProfile();
        imageFileList!.forEach((element) {
          if(myController.myList.length<5)
          _updateProfile(element.path);
        });
        setState(() {
          save = true;
        });
      } else {
        showLongToast("You have reached the limit!\n-Max 5 images are allowed");
      }
    } else {
      showLongToast("You have reached the limit!\n-Max 5 images are allowed");
    }
  }

  checkpermission_opencamera() async {
    var photosStatus = await Permission.photos.status;

    if (!photosStatus.isGranted) await Permission.photos.request();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: MediaQuery.of(context).size.height < 750 ? 18 : 22,
            ),
          ),
          color: Colors.black,
        ),
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Add Photos",
          style: TextStyle(
            // letterSpacing: 2.0,
            fontSize: MediaQuery.of(context).size.height < 750 ? 20 : 24,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          save
              ? IconButton(
                  onPressed: () {
                    selectImages();
                  },
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                  ))
              : IconButton(
                  onPressed: () {
                    // _updateProfile();
                    Get.back();
                  },
                  icon: Icon(
                    Icons.check,
                    color: Colors.black,
                  ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => myController.isDataProcessing.value
                ? Center(child: CircularProgressIndicator())
                : myController.myList.length == 0
                    ? Container()
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: myController.myList.length > 5
                            ? 5
                            : myController.myList.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          AllPhotosModel item = myController.myList[index];
                          debugPrint(item.photo.toString());
                          return InkWell(
                            onTap: () {
                              // AlertDelete(item.id);
                              Get.to(PView(
                                  item.photo, item.id.toString(), ""));
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  item.photo,
                                  fit: BoxFit.cover,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      onPressed: () {
                                        AlertDelete(item.id);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 27,
                                        color: Colors.red,
                                      )),
                                )
                              ],
                            ),
                          );
                        }),
          ),
        ),
      ),
    );
  }

  Future _updateProfile(path) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.updatedPhotos));
      request.files.add(await http.MultipartFile.fromPath('photos', path));
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        debugPrint("Sucsesssede");
        EasyLoading.showSuccess("Uploaded Successfully");

        setState(() {});
        myController.getTask(0);
      } else {
        EasyLoading.showError(jsonBody['message']);
        debugPrint(jsonBody.toString());
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

  Future updateImage(imgpath) async {
    EasyLoading.show(status: "Loading...");
    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.updateImage));
      request.fields.addAll({
        'mediaType': '1',
        'folderName': 'user-photos',
        'contentType': 'image/jpeg'
      });
      request.files.add(await http.MultipartFile.fromPath('media', imgpath));
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        EasyLoading.dismiss();

        setState(() {
          imagepathlist!.add(jsonBody['data']['media']);
        });
        // debugPrint(imagepathlist);
      } else {
        EasyLoading.showError(jsonBody['message']);
        debugPrint(jsonBody.toString());
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

  AlertDelete(id) async {
    final pref = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Delete!"),
        content: new Text("Do You Want To Delete The Image?"),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                Get.back();
              },
              isDefaultAction: true,
              child: new Text("Cancel")),
          CupertinoDialogAction(
              onPressed: () {
                deleteImage(id);
                Get.back();
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

  Future deleteImage(id) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request(
          'DELETE', Uri.parse(Constant.base_url + "users/photo/$id"));

      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      // debugPrint("++++++++"+jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        myController.getTask(1);
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
}
