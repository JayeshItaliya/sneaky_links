import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/LoginModal.dart';
import 'package:sneaky_links/Models/PartyPostModel.dart';
import 'package:sneaky_links/Pages/ProfileScreen/subscribe.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/block_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:http/http.dart' as http;

import '../../controllers/user_post_controller.dart';
import '../RoomScreen/frame312_item_widget.dart';
import '../message/chat.dart';

class UserProfileD extends StatefulWidget {
  String? item;

  UserProfileD({Key? key, this.item}) : super(key: key);

  @override
  _StaticProfileState createState() => _StaticProfileState();
}

class _StaticProfileState extends State<UserProfileD> {
  final myController = Get.put(BlockController());
  final myUController = Get.put(UserPostController());
  GlobalKey<FormState> _formKeyp = GlobalKey<FormState>();
  var item = [];
  late String valueText;
  late String codeDialog;
  var yourActiveIndex = 0;
  var pos = 0;


  int joined=21423233545;

  var selectedValue = "Choose Gender";
  List<String> Gender = [
    'Male',
    'Female',
  ];

  var selectedValue1 = "Feet";
  var selectedValueh = "Length";
  var selectedValuew = "Width";
  List<int> Height1 = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
  ];

  var selectedValue2 = "Inches";
  List<int> Height2 = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
  ];

  var selectedValue3 = "Choose Education Level";
  List<String> Education = [];
  var Educationid = new Map<String, String>();

  var selectedValue4 = "Choose Ethnicity";
  List<String> Ethnicity = [];
  var Ethnicityid = new Map<String, String>();

  var selectedValue7 = "Choose Interest In";
  List<String> Interested = [];
  var InterestInid = new Map<String, String>();

  var selectedValue5 = "Choose Body Type";
  List<String> BodyType = [];
  var BodyTypeid = new Map<String, String>();

  var selectedValue6 = "Choose Income Level";
  List<int> Income = [
    10000,
    50000,
  ];

  var selectedValue8 = "Like to Party or not";
  List<String> Party = [
    'True',
    'False',
  ];

  final unmcontroller = TextEditingController();
  final desccontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final loccontroller = TextEditingController();
  final zipcontroller = TextEditingController();
  final workcontroller = TextEditingController();

  late UProfile userdata;
  late DynamicModel devModel;

  bool isloading = true;
  bool isLiked = false;
  bool isBlocked = false;
  dynamic work = "Work";
  dynamic joinDate = "joinDate";
  int totalLikes = 0;
  int totalPosts = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  var like_user = 0;
  late SharedPreferences pref;

  getData() async {
    pref = await SharedPreferences.getInstance();

    myUController.updateData(int.parse(widget.item.toString()));
    setState(() {
      like_user = pref.getInt(Constant.user_id + "like_user") ?? 0;
      if (like_user == 5) {}
    });
    getProfileDetails(widget.item).then((value) {
      if (value != null) {
        setState(() {
          userdata = value;

          isloading = false;
          setState(() {
            unmcontroller.text = userdata.username;
            agecontroller.text = userdata.age.toString();
            loccontroller.text = userdata.location;
            zipcontroller.text = userdata.zipcode;
            item.addAll(userdata.interests);
            selectedValue = userdata.gender;
            selectedValue5 = userdata.bodyType == ""
                ? selectedValue5
                : userdata.bodyType['name'];
            selectedValue7 = userdata.interestIn == ""
                ? selectedValue7
                : userdata.interestIn['name'];

            print("++++++++++");

            totalLikes = userdata.totalLikes;
            print(totalLikes);
            print("++++++++++");


            totalPosts = userdata.totalPosts;
            isLiked = userdata.isLiked;
            isBlocked = userdata.isBlocked;
            unmcontroller.text = userdata.username;
            emailcontroller.text = userdata.email;
            desccontroller.text = userdata.description;
            workcontroller.text = userdata.work;
            agecontroller.text = userdata.age.toString();
            loccontroller.text = userdata.location;
            zipcontroller.text = userdata.zipcode;
            item.addAll(userdata.interests);
            selectedValue = userdata.gender;
            selectedValueh = userdata.endowmentHeight.toString();
            selectedValuew = userdata.endowmentWidth.toString();
            selectedValue3 = userdata.education == "" ? "" : userdata.education['name'];
            selectedValue4 =  userdata.ethnicity == "" ? "" : userdata.ethnicity['name'];
            selectedValue5 = userdata.bodyType == "" ? "" : userdata.bodyType['name'];
            selectedValue7 = userdata.interestIn == "" ? "" : userdata.interestIn['name'];
            selectedValue6 = userdata.income.toString();
            joined = userdata.joinDate.toString().length==0?int.parse(joined.toString()):int.parse(userdata.joinDate.toString());
            if(userdata.height
                .toString().length!=0)
              selectedValue1 = userdata.height
                  .toString()
                  .substring(0, userdata.height.toString().indexOf('.'));

            if(userdata.height
                .toString().length!=0)
              selectedValue2 = userdata.height.toString().substring(
                  userdata.height.toString().indexOf('.') + 1,
                  userdata.height.toString().length);
          });
        });
      }
    });
    getDev().then((value) {
      if (value != null) {
        setState(() {
          devModel = value;
          setState(() {
            devModel.bodytype.forEach((element) {
              setState(() {
                BodyType.add(element['name']);
                BodyTypeid[element['name']] = element['id'].toString();
              });
            });
            devModel.education.forEach((element) {
              setState(() {
                Education.add(element['name']);
                Educationid[element['name']] = element['id'].toString();
              });
            });
            devModel.ethnicity.forEach((element) {
              setState(() {
                Ethnicity.add(element['name']);
                Ethnicityid[element['name']] = element['id'].toString();
              });
            });
            devModel.interestIn.forEach((element) {
              setState(() {
                Interested.add(element['name']);
                InterestInid[element['name']] = element['id'].toString();
              });
            });
          });
        });
      }
    });
  }

  blockData() async {
    EasyLoading.show(status: "Loading...");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };
    try {
      var request =
          http.Request('POST', Uri.parse(Constant.getUsersId + '/block'));
      request.body = json.encode({"userId": widget.item});
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        Get.back(result: "data");
      } else {
        debugPrint(response.reasonPhrase);
        EasyLoading.showError(jsonBody['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  AlertDelete() async {
    final pref = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Block!"),
        content: new Text("Do You Want To Block The User?"),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                Get.back();
              },
              isDefaultAction: true,
              child: new Text("Cancel")),
          CupertinoDialogAction(
              onPressed: () {
                blockData();
                Get.back();
              },
              isDefaultAction: true,
              child: new Text(
                "Block",
                style: TextStyle(color: FlutterFlowTheme.primaryColor),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height / 3 - 55;
    return WillPopScope(
      onWillPop: () async {
        bool? result = true;
        Get.back(result: "data");
        return result;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: false,
          appBar: PreferredSize(
            preferredSize: MediaQuery.of(context).size.height < 750
                ? Size.fromHeight(50.0)
                : Size.fromHeight(55.0),
            child: AppBar(
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  "assets/images/back.png",
                  scale: 1.6,
                ),
              ),
              backgroundColor: Colors.white.withOpacity(0),
              elevation: 0,

              centerTitle: true,
              // automaticallyImplyLeading: false,
              title: Image.asset(
                "assets/images/sneaky.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
              actions: [
                PopupMenuButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(
                        Icons.more_vert,
                        size:
                            MediaQuery.of(context).size.height < 750 ? 23 : 26,
                        color: FlutterFlowTheme.black,
                      ),
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Block Profile"),
                            value: 1,
                            onTap: () {
                              if (widget.item != Constant.user_id.toString())
                                AlertDelete();
                              else
                                showLongToast("You can't block yourself");
                              // showProfileDialog(context,widget.item);
                            },
                          ),
                          if (like_user < 5 && Constant.current_plan == "FREE")
                            PopupMenuItem(
                              child: Text(userdata.isLiked
                                  ? "Unsubscribe"
                                  : "Subscribe"),
                              value: 2,
                              onTap: () {
                                like_user++;
                                pref.setInt(
                                    Constant.user_id + "like_user", like_user);
                                receipt_dataSave().then((value) {});
                                likeP(widget.item, userdata.isLiked ? 0 : 1);
                              },
                            ),
                          if (Constant.current_plan != "FREE")
                            PopupMenuItem(
                              child: Text(userdata.isLiked
                                  ? "Unsubscribe"
                                  : "Subscribe"),
                              value: 2,
                              onTap: () {
                                likeP(widget.item, userdata.isLiked ? 0 : 1);
                              },
                            )
                        ]),
              ],
              // automaticallyImplyLeading: false,
            ),
          ),
          body: SingleChildScrollView(
            child: isloading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 0.0,
                                        bottom: 18.0,
                                        top: 0.0),
                                    child: SizedBox(
                                        height: MediaQuery.of(
                                                        context)
                                                    .size
                                                    .height /
                                                3 -
                                            40,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius
                                                .circular(10),
                                            child: userdata.photos.length > 0
                                                ? Carousel(
                                                    images: userdata.photos
                                                        .map((e) =>
                                                            CachedNetworkImage(
                                                              imageUrl:
                                                                  e['photo'],
                                                              fit: BoxFit.cover,
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      Center(
                                                                child: CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                "assets/images/discover.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ))
                                                        .toList(),
                                                    autoplay: false,
                                                    boxFit: BoxFit.cover,
                                                    showIndicator: false,
                                                    dotSize: 5.0,
                                                    dotSpacing: 15.0,
                                                    dotColor: Colors.white,
                                                    indicatorBgPadding: 5.0,
                                                    // noRadiusForIndicator: true,
                                                    // moveIndicatorFromBottom: 180.0,
                                                    dotBgColor: Colors.black
                                                        .withOpacity(0.3),
                                                    // borderRadius: false,
                                                    // showIndicator: false,
                                                    borderRadius: false,
                                                    moveIndicatorFromBottom:
                                                        180.0,
                                                    noRadiusForIndicator: true,
                                                    overlayShadow: true,
                                                    overlayShadowColors: Colors
                                                        .white
                                                        .withOpacity(0.3),
                                                    overlayShadowSize: 0.1,
                                                    onImageChange:
                                                        (ind, index) {
                                                      setState(() {
                                                        yourActiveIndex = index;
                                                      });
                                                    },
                                                  )
                                                : Container(
                                                    width: MediaQuery
                                                            .of(context)
                                                        .size
                                                        .width,
                                                    child: userdata.profilePicture !=
                                                            ""
                                                        ? CachedNetworkImage(
                                                            imageUrl:
                                                                "${userdata.profilePicture ?? ""}",
                                                            fit: BoxFit.cover,
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                        downloadProgress) =>
                                                                    Center(
                                                                      child: CircularProgressIndicator(
                                                                          value:
                                                                              downloadProgress.progress),
                                                                    ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                                      "assets/images/discover.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ))
                                                        : Image.asset(
                                                            "assets/images/discover.png",
                                                            fit: BoxFit.cover,
                                                          )))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 90.0,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7c94b6),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "${userdata.profilePicture ?? ""}",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          unmcontroller.text,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Text(
                                          emailcontroller.text,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Container(
                                  height: 65,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xFFF7006A)),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              totalLikes.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme
                                                      .secondaryColor1,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // width: 70,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Text(
                                              "Subscribers",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 0, 20, 0),
                                        child: VerticalDivider(
                                          // width: 20,
                                          thickness: 1,
                                          indent: 5,
                                          endIndent: 5,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              totalPosts.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme
                                                      .secondaryColor1,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // width: 70,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Text(
                                              "Post Created",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (like_user < 5 &&
                                      Constant.current_plan == "FREE") {
                                    like_user++;
                                    pref.setInt(Constant.user_id + "like_user",
                                        like_user);
                                    receipt_dataSave().then((value) {});
                                    likeP(widget.item, userdata.isLiked ? 0 : 1);
                                  }
                                  if (Constant.current_plan != "FREE") {
                                    likeP(widget.item, userdata.isLiked ? 0 : 1);
                                  }


                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: getHorizontalSize(
                                      27.00,
                                    ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40.00,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        getHorizontalSize(
                                          10.00,
                                        ),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment(
                                          0.5,
                                          -3.0616171314629196e-17,
                                        ),
                                        end: Alignment(
                                          0.5,
                                          0.9999999999999999,
                                        ),
                                        colors: [
                                          ColorConstant.pinkA500,
                                          ColorConstant.pinkA500,
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      userdata.isLiked
                                          ? "Unsubscribe"
                                          : "Subscribe",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: ColorConstant.whiteA700,
                                        fontSize: getFontSize(
                                          20,
                                        ),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 25, 0, 4),
                                      child: Container(
                                        child: Text(
                                          "About",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Poppins',
                                              color: Color(0xFFF7006A),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        // width: 70,
                                      ),
                                    ),
                                    Text(
                                      desccontroller.text,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500),
                                    ),

                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsets.fromLTRB(0, 5, 0, 4),
                                    //   child: Container(
                                    //     child: Text(
                                    //       "Work",
                                    //       style: TextStyle(
                                    //           fontSize: 17,
                                    //           fontFamily: 'Poppins',
                                    //           color: Color(0xFFF7006A),
                                    //           fontWeight: FontWeight.w500),
                                    //     ),
                                    //     // width: 70,
                                    //   ),
                                    // ),
                                    // Text(
                                    //   workcontroller.text,
                                    //   style: TextStyle(
                                    //       fontSize: 12,
                                    //       fontFamily: 'Poppins',
                                    //       fontWeight: FontWeight.w500),
                                    // ),

                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 5, 0, 4),
                                child: Container(
                                  child: Text(
                                    "Age",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFF7006A),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // width: 70,
                                ),
                              ),
                              Text(
                                agecontroller.text,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              // Padding(
                              //   padding:
                              //   const EdgeInsets.fromLTRB(0, 5, 0, 4),
                              //   child: Container(
                              //     child: Text(
                              //       "Location",
                              //       style: TextStyle(
                              //           fontSize: 17,
                              //           fontFamily: 'Poppins',
                              //           color: Color(0xFFF7006A),
                              //           fontWeight: FontWeight.w500),
                              //     ),
                              //     // width: 70,
                              //   ),
                              // ),
                              // Text(
                              //   loccontroller.text,
                              //   style: TextStyle(
                              //       fontSize: 12,
                              //       fontFamily: 'Poppins',
                              //       fontWeight: FontWeight.w500),
                              // ),

                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 5, 0, 4),
                                child: Container(
                                  child: Text(
                                    "Zipcode",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFF7006A),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // width: 70,
                                ),
                              ),
                              Text(
                                zipcontroller.text,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),

                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 5, 0, 4),
                                child: Container(
                                  child: Text(
                                    "Gender",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFF7006A),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // width: 70,
                                ),
                              ),
                              Text(
                                selectedValue,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),

                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 5, 0, 4),
                                child: Container(
                                  child: const Text(
                                    "Body Type",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFF7006A),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // width: 70,
                                ),
                              ),
                              Text(
                                selectedValue5,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 5, 0, 4),
                                child: Container(
                                  child: const Text(
                                    "Interest In",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFF7006A),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // width: 70,
                                ),
                              ),
                              Text(
                                selectedValue7,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 25, 0, 4),
                                      child: Container(
                                        child: Text(
                                          "Interests",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Poppins',
                                              color: Color(0xFFF7006A),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        // width: 70,
                                      ),
                                    ),
                                    Wrap(
                                      direction: Axis.horizontal,
                                      children: List.generate(
                                        item.length,
                                        (index) {
                                          return Container(
                                            height: 40,
                                            width: 80,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFFE6E6E6)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: pos == index
                                                  ? FlutterFlowTheme
                                                      .secondaryColor1
                                                  : FlutterFlowTheme
                                                      .secondaryColor,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  pos = index;
                                                });
                                              },
                                              child: Center(
                                                child: Text(
                                                  "${item[index]}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'Poppins',
                                                      color: pos == index
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 4),
                                      child: Container(
                                        child: Text(
                                          "Joined",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Poppins',
                                              color: Color(0xFFF7006A),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        // width: 70,
                                      ),
                                    ),
                                    Text(
                                      datTime1(joined),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 40,
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Obx(
                                        () => myUController.isoffline.value
                                            ? Center(child: ConnectionError(
                                                onTap: () {
                                                  getData();
                                                },
                                              ))
                                            : myUController.myList.length <= 0
                                                ? Container(
                                                    height: 200,
                                                    child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            Text("No Posts")),
                                                  )
                                                : myUController
                                                        .isDataProcessing.value
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            ClampingScrollPhysics(),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 2,
                                                                right: 2),
                                                        itemCount: myUController
                                                            .myList.length,
                                                        itemBuilder:
                                                            (BuildContext ctx,
                                                                index) {
                                                          if (index ==
                                                                  myUController
                                                                          .myList
                                                                          .length -
                                                                      1 &&
                                                              myUController
                                                                  .isMoreDataAvailable
                                                                  .value) {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          }
                                                          PartyPostModel item =
                                                              myUController
                                                                      .myList[
                                                                  index];
                                                          return Frame312ItemWidget(
                                                            item: item,
                                                            roomId: widget.item
                                                                .toString(),
                                                          );
                                                        }),
                                      ),

                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: const Icon(Icons.chat_bubble_outlined),
            backgroundColor: Color(0xFFF7006A),
            onPressed: () {
              var data = {
                'id': userdata.userId.toString(),
                'user': userdata.username.toString(),
                'image': userdata.profilePicture.toString(),
                'token': userdata.deviceToken.length == 0
                    ? ""
                    : userdata.deviceToken[0]['deviceToken'],
              };
              if (widget.item != Constant.user_id.toString()) {
                if (Constant.plan_active == 1) {
                  if (Constant.current_plan != "DIAMOND") {
                    if (userdata.isLiked == true) {
                      Get.to(Chat(data: data));
                    } else {
                      showLongToast(
                          "This user must like you before you can message them or you must upgrade to  the Diamond Plan");
                    }
                  } else {
                    Get.to(Chat(data: data));
                  }
                } else {
                  // showLongToast("Plan Expire");
                  Get.defaultDialog(
                    title: Constant.titleText,
                    radius: 30,
                    barrierDismissible: false,
                    content: Column(
                      children: [
                        Column(
                          children: [
                            const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  "assets/images/logo.png",
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              Constant.description,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("Later")),
                            ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                  Get.to(subscribe());
                                },
                                child: const Text("Upgrade"))
                          ],
                        )
                      ],
                    ),
                  );
                }
              } else {
                showLongToast("You can't chat yourself");
              }
            },
          )),
    );
  }

  dynamic datTime1(dtime) {
    return DateFormat("d MMM yyyy").format(datTime(dtime));
  }
  DateTime datTime(dtime) {
    return DateTime.fromMillisecondsSinceEpoch(
        int.parse(dtime.toString()) * 1000);
  }

  Future likeP(id, status) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.Request('POST', Uri.parse(Constant.getUsersId + "/like"));
      request.body = json.encode({"matchedUserId": id, "status": status});
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      debugPrint("++++++++" + jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        setState(() {
          userdata.isLiked = !userdata.isLiked;
        });
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

  Future rejectP(id) async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request =
          http.Request('POST', Uri.parse(Constant.getUsersId + "/like"));
      request.body = json.encode({"matchedUserId": id, "status": 0});
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      debugPrint("++++++++" + jsonBody.toString());
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
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
