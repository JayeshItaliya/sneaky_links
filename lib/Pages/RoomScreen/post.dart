import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sneaky_links/Components/constants.dart';
import "package:http/http.dart" as http;
import '../../flutter_flow/flutter_flow_theme.dart';

class PostPage extends StatefulWidget {
  String roomId;
  String postText;
  String roomName;
  PostPage(this.roomId, this.postText,this.roomName);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final postController = TextEditingController();
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  var ImgUrl = "";
  var VdUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkpermission_opencamera();
    setState(() {
      postController.text = widget.postText;
    });
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
        imageQuality: 70,
        maxHeight: 280,
        maxWidth: 640
    );
    setState(() {
      _imageFile = pickedFile;
      print(_imageFile!.path);
      if (_imageFile != null) updateImage();
    });
  }

  //to ensure image is uploading from the native android
  bool isFileUploading = false;

  showProfileDialog(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Choose Action"),
        // content: new Text("Do you want to logout?"),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                takePhoto(ImageSource.camera);
                Get.back();
              },
              isDefaultAction: true,
              child: new Text(
                "Camera",
                style: TextStyle(color: FlutterFlowTheme.blue),
              )),
          CupertinoDialogAction(
              onPressed: () {
                takePhoto(ImageSource.gallery);
                Get.back();
              },
              isDefaultAction: true,
              child: new Text(
                "Gallery",
                style: TextStyle(color: FlutterFlowTheme.blue),
              ))
        ],
      ),
    );
  }

  checkpermission_opencamera() async {
    var photosStatus = await Permission.photos.status;
    if (!photosStatus.isGranted)
      await Permission.photos.request();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0,
          // automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "Create Post",
              style: TextStyle(
                // letterSpacing: 2.0,
                fontSize: MediaQuery.of(context).size.height < 750 ? 22 : 26,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: MediaQuery.of(context).size.height < 750
                    ? const EdgeInsets.only(right: 10.0)
                    : const EdgeInsets.only(right: 15.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            // mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        getSize(
                          25.00,
                        ),
                      ),
                      child: Constant.avatarUrl == ""
                          ? Image.asset(
                              "assets/images/discover.png",
                              height: getSize(
                                50.00,
                              ),
                              width: getSize(
                                50.00,
                              ),
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: Constant.avatarUrl,
                              height: getSize(
                                50.00,
                              ),
                              width: getSize(
                                50.00,
                              ),
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                    ),
                  ),
                  FittedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${Constant.name}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                            fontSize: MediaQuery.of(context).size.height < 750
                                ? 14
                                : 18,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0, left: 5),
                            child: Text(
                              " ${widget.roomName}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height < 750
                                        ? 14
                                        : 18,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "What are you thinking, ${Constant.name}?",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Colors.black,
                    fontSize:
                        MediaQuery.of(context).size.height < 750 ? 16 : 18,
                    fontFamily: 'Poppins',
                  ),

                  // contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
                ),
              ),
              if (_imageFile != null)
                Align(
                  alignment: Alignment.center,
                  child: Image.file(
                    File(_imageFile!.path),
                    scale: MediaQuery.of(context).size.height < 750 ? 0.2 : 1.8,
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  showProfileDialog(context);

                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: "Add to your post",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height < 750
                              ? 12
                              : 18,
                          fontFamily: 'Poppins',
                        ),

                        // contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
                        suffixIcon: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                                child: InkWell(
                                    child: Icon(
                                      Icons.image_rounded,
                                      size: 25,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    onTap: () {}),
                              ),
                              // InkWell(
                              //     child: Icon(Icons.emoji_emotions_outlined, size: 25,
                              //       color: Colors.deepOrangeAccent,
                              //     ), onTap: () {}),
                              // InkWell(
                              //     child: Icon(Icons.location_on, size: 25,
                              //       color: Colors.deepOrangeAccent,
                              //     ), onTap: () {})
                            ],
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                focusColor: Colors.grey,
                height: MediaQuery.of(context).size.height < 750 ? 40 : 55,
                minWidth: 350,
                color: Colors.pink.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: () {
                  // showProfileDialog(context);

                  if (ImgUrl != "")
                    AddPostImg(widget.roomId);
                  else if (VdUrl != "")
                    AddPostVd(widget.roomId);
                  else
                    AddPost(widget.roomId);
                },
                child: Text(
                  "Post",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize:
                          MediaQuery.of(context).size.height < 750 ? 17 : 22),
                ),
              ),
            ],
          ),
        ));
  }

  Future AddPost(id) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.Request('POST', Uri.parse(Constant.createRoom + "/$id/post"));
      request.body = json.encode({
        "postText": postController.text,
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      // print("++++++++"+jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        postController.clear();
        Get.back(result: "data");
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

  Future AddPostImg(id) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.Request('POST', Uri.parse(Constant.createRoom + "/$id/post"));
      request.body = json.encode({
        "postText": postController.text,
        "media": ImgUrl,
        "mediaType": 1,
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      print("++++++++"+jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        postController.clear();
        Get.back(result: "data");
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

  Future AddPostVd(id) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.Request('POST', Uri.parse(Constant.createRoom + "/$id/post"));
      request.body = json.encode({
        "postText": postController.text,
        "media": VdUrl,
        "mediaType": 2,
        "mediaThumbnail":
            "https://test-sneakylinks.s3-us-west-1.amazonaws.com/videos/Pexels+Videos+1433307-thumnail.png",
        "seconds": 360
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      // print("++++++++"+jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        postController.clear();
        Get.back(result: "data");
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

  filePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<String> files = result.paths.map((path) => path!).toList();

      if (files[0].contains(".mp4"))
        updateVideo(files[0]);
      else
        updateImage();

      print("file=>$files");
    } else {
      // User canceled the picker
    }
  }

  Future updateImage() async {
    EasyLoading.show(status: "Loading...");

    var headers = {'Authorization': 'Bearer ' + Constant.access_token};
    try {
      print(_imageFile!.path);

      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.updateImage));
      request.fields
          .addAll({
        'mediaType': '1','folderName': 'posts', 'contentType': 'image/jpeg'});
      request.files.add(await http.MultipartFile.fromPath('media', _imageFile!.path));
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("++++++++" + jsonBody.toString());

      if (response.statusCode == 200) {
        setState(() {
          print(jsonBody['data']['media']);
          // ImgUrl = jsonBody['data']['media'];
          ImgUrl = jsonBody['data']['media'];
          print(ImgUrl);


        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError(jsonBody['message']);
        print(jsonBody.toString());
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }





  Future updateVideo(str) async {
    EasyLoading.show(status: "Loading...");

    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.updateImage));
      request.fields
          .addAll({'folderName': 'posts', 'contentType': 'video/mp4'});
      request.files.add(await http.MultipartFile.fromPath('file', str));
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("++++++++" + jsonBody.toString());

      if (response.statusCode == 200) {
        setState(() {
          VdUrl = jsonBody['data']['file'];
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError(jsonBody['message']);
        print(jsonBody.toString());
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }
}
