import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/MsgModel.dart';
import 'package:sneaky_links/Models/recentModel.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/userProfileD.dart';
import 'package:sneaky_links/Pages/message/autoDeleteIntervals.dart';
import 'package:sneaky_links/Pages/message/gender.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/msgController.dart';
import 'package:sneaky_links/controllers/recentcontroller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:http/http.dart' as http;


import '../AuthScreen/signIn.dart';
import 'chat.dart';

class MessageScreen extends StatefulWidget {
   MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool Tag = true;
  bool status = true;
  bool status1 = true;

  final myController = Get.put(MsgController());
  final recentController = Get.put(RecentController());
  late ViewersModel viewersdata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getOptions();
  }

  getData() {
    recentController.updateData("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 20,
            ),
            Tag
                ? Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: Container(
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        // border: Border.all(
                        //     color: FlutterFlowTheme.primaryColor),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 45.0,
                              width: 180,
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      // side: BorderSide(color: Colors.red)
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                        FlutterFlowTheme.secondaryColor1)),
                                child: const Text(
                                  'Messages',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    Tag = true;
                                    getData();
                                  });
                                },
                                // color: Colors.pink,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 45.0,
                              width: 180,
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      // side: BorderSide(color: Colors.red)
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.grey.shade300,
                                    )),
                                child: const Text(
                                  'Options',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: FlutterFlowTheme.ButtonC1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    // Tag=value;
                                    Tag = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: Container(
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        // border: Border.all(
                        //     color: FlutterFlowTheme.primaryColor),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 45.0,
                              width: 180,
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      // side: BorderSide(color: Colors.red)
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.grey.shade300,
                                    )),
                                child: const Text(
                                  'Messages',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: FlutterFlowTheme.ButtonC1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    // Tag=value;
                                    Tag = true;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 45.0,
                              width: 180,
                              margin: EdgeInsets.only(right: 1),
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      // side: BorderSide(color: Colors.red)
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                        FlutterFlowTheme.secondaryColor1)),

                                child: const Text(
                                  'Options',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {
                                  // debugPrint(myController.toString());
                                  setState(() {
                                    // Tag=value;
                                    Tag = false;
                                  });
                                },
                                // color: Colors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: 25,
            ),
            Tag
                ? Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 35,
                            right: 35,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                // contentPadding: EdgeInsets.all(0),
                                hintText: "Search...",
                                suffixIcon: Icon(
                                  Icons.search,
                                  size: 20,
                                  color: Colors.grey,
                                )),
                            style: TextStyle(
                              color: ColorConstant.bluegray900,
                              fontSize: 18,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                            ),
                            onChanged: (str) {
                              recentController.updateData(str);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 23,
                            left: 25,
                            right: 25,
                          ),
                          child: Container(
                            height: 80.00,
                            child: Obx(
                              () => myController.myList.length <= 0
                                  ? Container(
                                      height: 200,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text("No Viwers")),
                                    )
                                  : myController.isDataProcessing.value
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : ListView.builder(
                                          controller:
                                              myController.scrollController,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics: ClampingScrollPhysics(),
                                          padding: EdgeInsets.only(
                                              left: 2, right: 2),
                                          itemCount: myController.myList.length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            if (index ==
                                                    myController.myList.length -
                                                        1 &&
                                                myController.isMoreDataAvailable
                                                    .value) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            ViewersModel item =
                                                myController.myList[index];
                                            return index == 0
                                                ? Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 12),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: getSize(
                                                                55.00,
                                                              ),
                                                              width: getSize(
                                                                55.00,
                                                              ),
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                  getHorizontalSize(
                                                                    25.00,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Card(
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                elevation: 0,
                                                                margin:
                                                                EdgeInsets
                                                                    .all(0),
                                                                shape:
                                                                RoundedRectangleBorder(
                                                                  side:
                                                                  BorderSide(
                                                                    width:
                                                                    getHorizontalSize(
                                                                      1.00,
                                                                    ),
                                                                  ),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                    getHorizontalSize(
                                                                      25.00,
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .center,
                                                                  child:
                                                                  Container(
                                                                      child:
                                                                      Icon(
                                                                        Icons
                                                                            .remove_red_eye,
                                                                        size: 20,
                                                                      )),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    4.0),
                                                                child:
                                                                Container(
                                                                  width: 55,
                                                                  child: Text(
                                                                    "Viewed Me",
                                                                    maxLines:
                                                                    1,
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                    style:
                                                                    TextStyle(
                                                                      color: ColorConstant
                                                                          .gray400,
                                                                      fontSize:
                                                                      17,
                                                                      fontFamily:
                                                                      'Rubik',
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 12),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.to(UserProfileD(
                                                                item: item
                                                                    .userId
                                                                    .toString()));
                                                          },
                                                          child: Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  getHorizontalSize(
                                                                    30.08,
                                                                  ),
                                                                ),
                                                                child: item.profilePicture ==
                                                                        ""
                                                                    ? Image
                                                                        .asset(
                                                                        "assets/images/discover.png",
                                                                        height:
                                                                            getSize(
                                                                          58.06,
                                                                        ),
                                                                        width:
                                                                            getSize(
                                                                          58.06,
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : CachedNetworkImage(
                                                                        imageUrl:
                                                                            item.profilePicture,
                                                                        height:
                                                                            getSize(
                                                                          58.06,
                                                                        ),
                                                                        width:
                                                                            getSize(
                                                                          58.06,
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Center(child: Image.asset(
                                                                                  "assets/images/discover.png",
                                                                                  height:
                                                                                  getSize(
                                                                                    58.06,
                                                                                  ),
                                                                                  width:
                                                                                  getSize(
                                                                                    58.06,
                                                                                  ),
                                                                                  fit: BoxFit.cover,
                                                                                )),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Icon(Icons.error),
                                                                      ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child:
                                                                      Container(
                                                                    width: 50,
                                                                    child: Text(
                                                                      item.username,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        color: ColorConstant
                                                                            .gray400,
                                                                        fontSize:
                                                                            17,
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 12),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        var res = await Get.to(
                                                            UserProfileD(
                                                                item: item
                                                                    .userId
                                                                    .toString()));
                                                        if (res != null) {
                                                          getData();
                                                        }
                                                      },
                                                      child: Column(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              getHorizontalSize(
                                                                30.08,
                                                              ),
                                                            ),
                                                            child: item.profilePicture ==
                                                                    ""
                                                                ? Image.asset(
                                                                    "assets/images/discover.png",
                                                                    height:
                                                                        getSize(
                                                                      58.06,
                                                                    ),
                                                                    width:
                                                                        getSize(
                                                                      58.06,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : CachedNetworkImage(
                                                                    imageUrl: item
                                                                        .profilePicture,
                                                                    height:
                                                                        getSize(
                                                                      58.06,
                                                                    ),
                                                                    width:
                                                                        getSize(
                                                                      58.06,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:Image.asset(
                                                                              "assets/images/discover.png",
                                                                              height:
                                                                              getSize(
                                                                                58.06,
                                                                              ),
                                                                              width:
                                                                              getSize(
                                                                                58.06,
                                                                              ),
                                                                              fit: BoxFit.cover,
                                                                            )),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                  ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Container(
                                                                width: 50,
                                                                child: Text(
                                                                  item.username,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    color: ColorConstant
                                                                        .gray400,
                                                                    fontSize:
                                                                        17,
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                          }),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 35,
                            top: 12,
                            right: 35,
                          ),
                          child: Text(
                            "Recent",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: ColorConstant.bluegray900,
                              fontSize: 23,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 27,
                          top: 22,
                          right: 27,
                        ),
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            color: ColorConstant.gray400,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 14,
                            left: 20,
                            right: 20,
                          ),
                          child: Obx(
                            () => recentController.isoffline.value
                                ? Center(child: ConnectionError(
                                    onTap: () {
                                      getData();
                                      // myController.updateData(searchController.text);
                                    },
                                  ))
                                : recentController.myList.length <= 0
                                    ? Container(
                                        height: 200,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text("No Messages")),
                                      )
                                    : ListView.builder(
                                        controller: recentController.scrollController,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: ClampingScrollPhysics(),
                                        padding:
                                            EdgeInsets.only(left: 2, right: 2),
                                        itemCount:
                                            recentController.myList.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          if (index ==
                                                  recentController
                                                          .myList.length -
                                                      1 &&
                                              recentController
                                                  .isMoreDataAvailable.value) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          RecentModel item1 =
                                              recentController.myList[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: InkWell(
                                              onTap: () async {
                                                var data = {
                                                  'id': item1.receiverId
                                                              .toString() ==
                                                          Constant.user_id
                                                      ? item1.senderId
                                                          .toString()
                                                      : item1.receiverId
                                                          .toString(),
                                                  'user':
                                                      item1.username.toString(),
                                                  'image': item1.profilePicture
                                                      .toString(),
                                                  'token': "",
                                                };
                                                var res = await Get.to(Chat(
                                                  data: data,
                                                ));
                                                if (res != null) getData();
                                              },
                                              child: ListTile(
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    getHorizontalSize(
                                                      30.08,
                                                    ),
                                                  ),
                                                  child: item1.profilePicture ==
                                                          ""
                                                      ? Image.asset(
                                                          "assets/images/discover.png",
                                                    height:
                                                    getSize(
                                                      58.06,
                                                    ),
                                                    width:
                                                    getSize(
                                                      58.06,
                                                    ), fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: item1
                                                              .profilePicture,
                                                    height:
                                                    getSize(
                                                      58.06,
                                                    ),
                                                    width:
                                                    getSize(
                                                      58.06,
                                                    ),
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              Center(
                                                                  child:Image.asset(
                                                                    "assets/images/discover.png",
                                                                    height: getSize(
                                                                      70.06,
                                                                    ),
                                                                    width: getSize(
                                                                      70.06,
                                                                    ),
                                                                    fit: BoxFit.cover,
                                                                  )
                                                              ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                ),
                                                title: Text(
                                                  "${item1.username}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: ColorConstant
                                                        .bluegray900,
                                                    fontSize: 20,
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "${item1.message}",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        ColorConstant.gray400,
                                                    fontSize: 16,
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  "${(DateFormat("d MMMM yyyy").format(DateTime.now()) == datTime1(item1.createdAt) ? "${datTime2(item1.createdAt)}" : (DateFormat("d MMMM yyyy").format(DateTime.now().subtract(Duration(days: 1))) == datTime1(item1.createdAt)) ? 'Yesterday' : datTime1(item1.createdAt))}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color:
                                                        ColorConstant.gray400,
                                                    fontSize: 17,
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 35,
                          top: 31,
                          right: 35,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: 24,
                              width: 4,
                              decoration: BoxDecoration(
                                color: ColorConstant.pinkA400,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 9,
                              ),
                              child: Text(
                                "Message Preferences",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ColorConstant.black900,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 35,
                            top: 35,
                            right: 35,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(GenderScreen());
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Gender",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: ColorConstant.black900,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.10,
                                      ),
                                    ),
                                    Container(
                                        height: 24,
                                        width: 24,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 45.00,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Only upgraded members can message me",
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: ColorConstant.black900,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.10,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 0.80,
                                        bottom: 0.80,
                                      ),
                                      child: Container(
                                        height: 22.40,
                                        width: 36.40,
                                        child: Switch(
                                          activeColor: Colors.white,
                                          activeTrackColor:
                                              FlutterFlowTheme.secondaryColor,
                                          activeThumbImage: AssetImage(
                                            "assets/images/img.png",
                                          ),
                                          inactiveThumbImage: AssetImage(
                                              "assets/images/img_1.png"),
                                          value: Constant.upgradedMembermsg,
                                          onChanged: (value) {
                                            // save(value);
                                            setState(() {
                                              // status = value;
                                              Constant.upgradedMembermsg =
                                                  value;
                                              // debugPrint(Constant.upgradedMembermsg);

                                              updateOptions();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 45.00,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Only members with profile pictures can message me",
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: ColorConstant.black900,
                                          fontSize: 15,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.10,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 0.80,
                                        bottom: 0.80,
                                      ),
                                      child: Container(
                                        height: 22.40,
                                        width: 36.40,
                                        child: Switch(
                                          activeColor: Colors.white,
                                          activeTrackColor:
                                              FlutterFlowTheme.secondaryColor,
                                          activeThumbImage: AssetImage(
                                            "assets/images/img.png",
                                          ),
                                          inactiveThumbImage: AssetImage(
                                              "assets/images/img_1.png"),
                                          value: Constant.membersWithProfile,
                                          onChanged: (value) {
                                            // save(value);
                                            setState(() {
                                              // status1 = value;
                                              Constant.membersWithProfile =
                                                  value;
                                              // debugPrint(
                                              //     Constant.membersWithProfile);

                                              updateOptions();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  dynamic datTime1(dtime) {
    return DateFormat("d MMM yyyy").format(datTime(dtime));
  }

  dynamic datTime2(dtime) {
    return DateFormat('hh:mm a').format(datTime(dtime));
  }

  DateTime datTime(dtime) {
    // return DateTime.fromMillisecondsSinceEpoch(dtime * 1000);
    return DateTime.fromMillisecondsSinceEpoch(
        int.parse(dtime.toString()) * 1000);
  }
  getOptions() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {
      'Authorization': 'Bearer ' + Constant.access_token
    };
    var request = http.Request('GET', Uri.parse(Constant.updateOptions));

    request.headers.addAll(headers);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);
    debugPrint(jsonBody.toString()) ;

    if (response.statusCode == 200) {
      debugPrint(jsonBody.toString()) ;
      final jsonBody1=jsonBody['data'];

      setState(() {
        Constant.AutoIntervals=jsonBody1['autoIntervalDeleteInSeconds'];
        Constant.gender=jsonBody['data']['gender'];
        Constant.upgradedMembermsg=jsonBody['data']['onlyUpgradedMembersCanMessage'];
        Constant.membersWithProfile=jsonBody['data']['onlyMembersWithProfileCanMessage'];
      });
      // debugPrint(jsonBody['data']['autoIntervalDeleteInSeconds']);

    }
    else if (response.statusCode == 401) {
      EasyLoading.dismiss();

      pref.setString("username", "");
      pref.setString("email", "");
      pref.setBool("isLogin", false);
      Get.offAll(SignIn());
    } else {
      debugPrint(response.reasonPhrase);
    }

  }

}
