import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sneaky_links/Pages/SearchScreen/filter_screen.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

import '../../Models/UserModel.dart';
import '../../Services/connectionerror.dart';
import '../../controllers/users_controller.dart';
import '../DiscoverScreen/userProfileD.dart';

class SearchScreen extends StatefulWidget {
  bool value;

  SearchScreen(this.value);

  @override
  _MemoriesBlankWidgetState createState() => _MemoriesBlankWidgetState();
}

class _MemoriesBlankWidgetState extends State<SearchScreen> {
  bool Tag = true;
  final myController = Get.put(UsersController());
  TextEditingController searchController = new TextEditingController();

  void initState() {
    super.initState();
    checkpermission_opencamera();
    getData();
  }

  getData() {
    myController.updateData("", true);
  }

  checkpermission_opencamera() async {
    var photosStatus = await Permission.location.status;
    if (!photosStatus.isGranted) await Permission.contacts.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        // side: BorderSide(color: Colors.red)
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              FlutterFlowTheme
                                                  .secondaryColor1)),
                                  child: const Text(
                                    'Nearby',
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        // side: BorderSide(color: Colors.red)
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.grey.shade300,
                                      )),
                                  child: const Text(
                                    'Filters',
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        // side: BorderSide(color: Colors.red)
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.grey.shade300,
                                      )),
                                  child: const Text(
                                    'Nearby',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: FlutterFlowTheme.ButtonC1),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      // Tag=value;
                                      Tag = true;
                                      getData();
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        // side: BorderSide(color: Colors.red)
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              FlutterFlowTheme
                                                  .secondaryColor1)),

                                  child: const Text(
                                    'Filters',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onPressed: () {
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
                  ? RefreshIndicator(
                      onRefresh: () async {
                        getData();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.78,
                        padding: EdgeInsets.only(
                          left: 18, right: 18,
                          // bottom: MediaQuery.of(context).size.height/3.8,
                        ),
                        child: Obx(
                          () => myController.isoffline.value
                              ? Center(child: ConnectionError(
                                  onTap: () {
                                    // getData();
                                    myController.updateData(
                                        searchController.text, true);
                                  },
                                ))
                              : myController.isDataProcessing.value
                                  ? Center(child: CircularProgressIndicator())
                                  : myController.myList.length <= 0
                                      ? Container(
                                          height: 200,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text("No Users")),
                                        )
                                      : myController.isDataProcessing.value
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : GridView.builder(
                                              controller:
                                                  myController.scrollController,
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              padding: EdgeInsets.only(
                                                  left: 12, right: 12),
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 200,
                                                      childAspectRatio: 0.8,
                                                      crossAxisSpacing: 20,
                                                      mainAxisSpacing: 20),
                                              itemCount:
                                                  myController.myList.length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                UserModel item =
                                                    myController.myList[index];
                                                if (index ==
                                                        myController
                                                                .myList.length -
                                                            1 &&
                                                    myController
                                                        .isMoreDataAvailable
                                                        .value) {
                                                  return Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          debugPrint(item.id.toString());
                                                          Get.to(UserProfileD(
                                                            item: item.id
                                                                .toString(),
                                                          ));
                                                        },
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  item.username +
                                                                      ", " +
                                                                      item.age
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Text(
                                                                  item.location,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  // borderRadius: BorderRadius.circular(15),
                                                                  image: item.profilePicture ==
                                                                          ""
                                                                      ? DecorationImage(
                                                                          image: AssetImage(
                                                                              "assets/images/discover.png"),
                                                                          fit: BoxFit
                                                                              .cover)
                                                                      : DecorationImage(
                                                                          image: NetworkImage(item
                                                                              .profilePicture),
                                                                          fit: BoxFit
                                                                              .cover),
                                                                  gradient: new LinearGradient(
                                                                      colors: [
                                                                        Color(
                                                                            0xE0E0E0),
                                                                        Color(
                                                                            0xD4A8A8A8),
                                                                      ],
                                                                      stops: [
                                                                        0.0,
                                                                        1.0
                                                                      ],
                                                                      begin: FractionalOffset
                                                                          .topCenter,
                                                                      end: FractionalOffset
                                                                          .bottomCenter,
                                                                      tileMode:
                                                                          TileMode
                                                                              .repeated)),
                                                        ),
                                                      ),
                                                      Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    ],
                                                  );
                                                }
                                                return InkWell(
                                                  onTap: () {
                                                    debugPrint(item.id.toString());
                                                    Get.to(UserProfileD(
                                                      item: item.id.toString(),
                                                    ));
                                                  },
                                                  child: Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.username +
                                                                ", " +
                                                                item.age
                                                                    .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              shadows: <Shadow>[
                                                                Shadow(
                                                                  offset:
                                                                      Offset(
                                                                          1.0,
                                                                          1.0),
                                                                  blurRadius:
                                                                      3.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                ),
                                                                Shadow(
                                                                  offset:
                                                                      Offset(
                                                                          1.0,
                                                                          1.0),
                                                                  blurRadius:
                                                                      8.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            item.location,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              shadows: <Shadow>[
                                                                Shadow(
                                                                  offset:
                                                                      Offset(
                                                                          1.0,
                                                                          1.0),
                                                                  blurRadius:
                                                                      3.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                ),
                                                                Shadow(
                                                                  offset:
                                                                      Offset(
                                                                          1.0,
                                                                          1.0),
                                                                  blurRadius:
                                                                      8.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blueGrey,
                                                        // borderRadius: BorderRadius.circular(15),
                                                        image: item.profilePicture ==
                                                                ""
                                                            ? DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/images/discover.png"),
                                                                fit: BoxFit
                                                                    .cover)
                                                            : DecorationImage(
                                                                image: NetworkImage(item
                                                                    .profilePicture),
                                                                fit: BoxFit
                                                                    .cover),
                                                        gradient: new LinearGradient(
                                                            colors: [
                                                              Color(0xE0E0E0),
                                                              Color(0xD4A8A8A8),
                                                            ],
                                                            stops: [
                                                              0.0,
                                                              1.0
                                                            ],
                                                            begin:
                                                                FractionalOffset
                                                                    .topCenter,
                                                            end: FractionalOffset
                                                                .bottomCenter,
                                                            tileMode: TileMode
                                                                .repeated)),
                                                  ),
                                                );
                                              }),
                        ),
                      ),
                    )
                  : FiltersScreen()
            ],
          ),
        ),
      ),
    );
  }
}
