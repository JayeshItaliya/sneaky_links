import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Pages/RoomScreen/WebviewTermandCondition.dart';
import 'package:sneaky_links/controllers/user_party_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../Components/constants.dart';

class CreateRoomPopupScreen extends StatefulWidget {
  @override
  State<CreateRoomPopupScreen> createState() => _CreateRoomPopupScreenState();
}

class _CreateRoomPopupScreenState extends State<CreateRoomPopupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final myController = Get.put(UserPartyController());

  String coverPhoto = "";
  String userImage = "";
  bool timepass = true;

  String dropDownValue = "No";
  List<String> cityList = [
    'Yes',
    'No',
  ];
  RangeValues ageRange = const RangeValues(25, 56);
  final rnmController = TextEditingController();
  final rpwdController = TextEditingController();
  final feeController = TextEditingController();
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

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

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
        imageQuality: 70,
        maxHeight: 280,
        maxWidth: 640
    );
    setState(() {
      _imageFile = pickedFile;
      if (_imageFile != null) updateImage();
    });
  }

  getData() {
    myController.updateData("");
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
            "Create Party",
            style: TextStyle(
              // letterSpacing: 2.0,
              fontSize: MediaQuery.of(context).size.height < 750 ? 22 : 26,
              color: Colors.black,
              fontWeight: FontWeight.w600,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              margin: EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorConstant.whiteA700,
                boxShadow: [
                  BoxShadow(blurRadius: 1, color: Colors.grey, spreadRadius: 0.2)
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 25.0,
                          top: 41.0,
                          right: 25.0,
                          bottom: 41.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Text(
                                      "Parties Name",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: ColorConstant.bluegray900,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.10,
                                        height: 1.71,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: getVerticalSize(
                                        10.00,
                                      ),
                                    ),
                                    child: Container(
                                        height: getVerticalSize(
                                          54.00,
                                        ),
                                        child: TextFormField(
                                          controller: rnmController,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: ColorConstant.black900,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                getHorizontalSize(
                                                  5.00,
                                                ),
                                              ),
                                              borderSide: BorderSide(
                                                color: ColorConstant.gray300,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                getHorizontalSize(
                                                  5.00,
                                                ),
                                              ),
                                              borderSide: BorderSide(
                                                color: ColorConstant.gray300,
                                                width: 1,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: ColorConstant.gray50,
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(
                                              left: getHorizontalSize(
                                                20.00,
                                              ),
                                              top: getVerticalSize(
                                                19.00,
                                              ),
                                              bottom: getVerticalSize(
                                                21.00,
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: ColorConstant.black900,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return ("Please Enter Party Name");
                                            }
                                          },
                                          onChanged: (str) {
                                            print(str);
                                          },
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: getVerticalSize(
                                    25.00,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: getHorizontalSize(
                                          10.00,
                                        ),
                                      ),
                                      child: Text(
                                        "Passcode Enabled",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: ColorConstant.bluegray900,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.10,
                                          height: 1.71,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(
                                          10.00,
                                        ),
                                      ),
                                      child: Container(
                                        height: getVerticalSize(
                                          54.00,
                                        ),
                                        child: DropdownButtonFormField(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 20,
                                            color: FlutterFlowTheme.black,
                                          ),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        FlutterFlowTheme.grey3),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                  color: FlutterFlowTheme.black,
                                                  fontSize: 10),
                                              hintText: "Yes/No",
                                              fillColor: FlutterFlowTheme.grey4),
                                          value: dropDownValue,
                                          onChanged: (String? Value) {
                                            setState(() {
                                              dropDownValue = Value!;
                                            });
                                          },
                                          items: cityList
                                              .map(
                                                  (cityTitle) => DropdownMenuItem(
                                                      value: cityTitle,
                                                      child: Text(
                                                        "$cityTitle",
                                                        style: TextStyle(
                                                            color:
                                                                FlutterFlowTheme
                                                                    .black,
                                                            fontSize: 10),
                                                      )))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (dropDownValue == "Yes")
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(
                                          25.00,
                                        ),
                                        right: getHorizontalSize(
                                          10.00,
                                        ),
                                      ),
                                      child: Text(
                                        "Passcode",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: ColorConstant.bluegray900,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.10,
                                          height: 1.71,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(
                                          10.00,
                                        ),
                                      ),
                                      child: Container(
                                          height: getVerticalSize(
                                            54.00,
                                          ),
                                          child: TextFormField(
                                            controller: rpwdController,
                                            obscureText: true,
                                            obscuringCharacter: "*",
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                fontSize: 16,
                                                color: ColorConstant.black900,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  getHorizontalSize(
                                                    5.00,
                                                  ),
                                                ),
                                                borderSide: BorderSide(
                                                  color: ColorConstant.gray300,
                                                  width: 1,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  getHorizontalSize(
                                                    5.00,
                                                  ),
                                                ),
                                                borderSide: BorderSide(
                                                  color: ColorConstant.gray300,
                                                  width: 1,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: ColorConstant.gray50,
                                              isDense: true,
                                              contentPadding: EdgeInsets.only(
                                                left: getHorizontalSize(
                                                  20.00,
                                                ),
                                                top: getVerticalSize(
                                                  19.00,
                                                ),
                                                bottom: getVerticalSize(
                                                  21.00,
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return ("Please Enter Party Passcode");
                                              }
                                            },
                                            style: TextStyle(
                                              color: ColorConstant.black900,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            onChanged: (str) {
                                              print(str);
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: getVerticalSize(
                                        25.00,
                                      ),
                                      right: 10.0,
                                    ),
                                    child: Text(
                                      "Entrance Price",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: ColorConstant.bluegray900,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.10,
                                        height: 1.71,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: getVerticalSize(
                                        10.00,
                                      ),
                                    ),
                                    child: Container(
                                        height: getVerticalSize(
                                          54.00,
                                        ),
                                        child: TextFormField(
                                          controller: feeController,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            feeController.text = value!;
                                          },
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: ColorConstant.black900,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                getHorizontalSize(
                                                  5.00,
                                                ),
                                              ),
                                              borderSide: BorderSide(
                                                color: ColorConstant.gray300,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                getHorizontalSize(
                                                  5.00,
                                                ),
                                              ),
                                              borderSide: BorderSide(
                                                color: ColorConstant.gray300,
                                                width: 1,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: ColorConstant.gray50,
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(
                                              left: getHorizontalSize(
                                                20.00,
                                              ),
                                              top: getVerticalSize(
                                                19.00,
                                              ),
                                              bottom: getVerticalSize(
                                                21.00,
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: ColorConstant.black900,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          onChanged: (str) {
                                            print(str);
                                          },
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: getVerticalSize(
                                    25.00,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: getHorizontalSize(
                                          10.00,
                                        ),
                                      ),
                                      child: Text(
                                        "Regional Distance (m)",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: ColorConstant.black900,
                                          fontSize: getFontSize(
                                            20,
                                          ),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(
                                          9.00,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SliderTheme(
                                            data: SliderThemeData(
                                              trackShape:
                                                  RoundedRectSliderTrackShape(),
                                              inactiveTrackColor:
                                                  ColorConstant.gray400,
                                              thumbShape: RoundSliderThumbShape(),
                                            ),
                                            child: RangeSlider(
                                              values: ageRange,
                                              min: 0.0,
                                              max: 100.0,
                                              onChanged: (value) {
                                                setState(() {
                                                  ageRange = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: getHorizontalSize(
                                                    6.00,
                                                  ),
                                                  top: getVerticalSize(
                                                    6.00,
                                                  ),
                                                ),
                                                child: Text(
                                                  "${ageRange.start.toStringAsFixed(0)}",
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: ColorConstant.black900,
                                                    fontSize: getFontSize(
                                                      16,
                                                    ),
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right: getHorizontalSize(
                                                    12.00,
                                                  ),
                                                  bottom: getVerticalSize(
                                                    6.00,
                                                  ),
                                                ),
                                                child: Text(
                                                  "${ageRange.end.toStringAsFixed(0)}",
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: ColorConstant.black900,
                                                    fontSize: getFontSize(
                                                      16,
                                                    ),
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height:
                                              MediaQuery.of(context).size.width /
                                                      2 +
                                                  50,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 15),
                                            child: _imageFile != null
                                                ? Image.file(
                                                    File(_imageFile!.path),
                                                    fit: BoxFit.cover,
                                                  )
                                                : timepass
                                                    ? Image.asset(
                                                        "assets/images/discover.png",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            Constant.avatarUrl,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 25,
                                          child: InkWell(
                                            onTap: () {
                                              showProfileDialog(context);
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.edit_outlined,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Stack(
                              //   children: [
                              //     Container(
                              //       width: MediaQuery.of(context).size.width,
                              //       height: MediaQuery.of(context).size.width / 2 + 50,
                              //       child: Padding(
                              //         padding: const EdgeInsets.fromLTRB(0, 8, 0, 15),
                              //         child: _imageFile != null
                              //             ? Image.file(
                              //           File(_imageFile!.path),
                              //           fit: BoxFit.cover,
                              //         )
                              //             : Constant.avatarUrl==""?Image.asset(
                              //           "assets/images/discover.png",
                              //           fit: BoxFit.cover,
                              //         ):Image.network(
                              //           Constant.avatarUrl,
                              //           fit: BoxFit.cover,
                              //         ),
                              //       ),
                              //     ),
                              //     Positioned(
                              //       right: 10,
                              //       bottom: 25,
                              //       child: InkWell(
                              //         onTap: () {
                              //           showProfileDialog(context);
                              //         },
                              //         child: CircleAvatar(
                              //           backgroundColor: Colors.white,
                              //           child: Icon(
                              //             Icons.edit_outlined,
                              //             size: 25,
                              //             color: Colors.black,
                              //           ),
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 20, bottom: 0),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: FlutterFlowTheme.primaryColor,
                                  height: 48,
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: const Text(
                                    "Create",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                        if (dropDownValue == "Yes")
                                          _createwithpwdRoom();
                                        else
                                          _createRoom();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Positioned(
                      //     top: 10,
                      //     right: 10,
                      //     child: CircleAvatar(
                      //       radius: 18,
                      //       backgroundColor: Colors.black,
                      //       child: IconButton(
                      //         onPressed: () {
                      //           Get.back();
                      //         },
                      //         icon: Icon(
                      //           Icons.close,
                      //           size: 20,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future updateImage() async {
    EasyLoading.show(status: "Loading...");

    SharedPreferences pref = await SharedPreferences.getInstance();


    var headers = {'Authorization': 'Bearer ' + Constant.access_token};

    try {
      if (kDebugMode) {
        print("test start + " + _imageFile!.path);
      }

      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.updateImage));
      request.fields.addAll(
        {'folderName': 'rooms', 'contentType': 'image/jpeg','mediaType': '1',
        },
      );
      request.files.add(
          await http.MultipartFile.fromPath('media', _imageFile!.path));
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {

        setState(() {
          userImage = jsonBody['data']['media'];
        });

        EasyLoading.dismiss();
      } else {
        EasyLoading.showError(jsonBody['message']);
        if (kDebugMode) {
          print(jsonBody.toString());
        }
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Future _createRoom() async {
    EasyLoading.show(status: "Loading...");
    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.createRoom));
      request.body = json.encode({
        "roomName": rnmController.text,
        "regionalDistanceMin": ageRange.start,
        "regionalDistanceMax": ageRange.end,
        "price": feeController.text.isEmpty?0:feeController.text,
        "coverPhoto": userImage
      });
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (kDebugMode) {
        print(jsonBody.toString());
      }

      if (response.statusCode == 200) {
        // EasyLoading.showSuccess(jsonBody['message']);


        if(jsonBody['status']==0){
          // EasyLoading.showError(jsonBody['message']);
          EasyLoading.dismiss();
          Get.to(WebViewClass('Create Account', jsonBody['data']['url']));
        }
        else if(jsonBody['status']==1){
          EasyLoading.showSuccess(jsonBody['message']);
          getData();
          Get.back();
        }
        else if(jsonBody['status']==3){
          EasyLoading.showSuccess(jsonBody['message']);
          getData();
          Get.back();
        }
        else{
          EasyLoading.showError(jsonBody['message']);
        }

      } else {
        EasyLoading.showError(jsonBody['message']);
        if (kDebugMode) {
          print(jsonBody.toString());
        }
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Future _createwithpwdRoom() async {
    EasyLoading.show(status: "Loading...");

    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.createRoom));
      request.body = json.encode({
        "roomName": rnmController.text,
        "regionalDistanceMin": ageRange.start,
        "regionalDistanceMax": ageRange.end,
        "passcode": rpwdController.text,
        "price": feeController.text,
        "coverPhoto": userImage

      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());

      if (response.statusCode == 200) {
        if(jsonBody['status']==0){
          // EasyLoading.showError(jsonBody['message']);
          EasyLoading.dismiss();
          Get.to(WebViewClass('Create Account', jsonBody['data']['url']));
        }
        else if(jsonBody['status']==1){
          EasyLoading.showSuccess(jsonBody['message']);
          getData();
          Get.back();
        }
        else if(jsonBody['status']==3){
          EasyLoading.showSuccess(jsonBody['message']);
          getData();
          Get.back();
        }
        else{
          EasyLoading.showError(jsonBody['message']);
        }

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
