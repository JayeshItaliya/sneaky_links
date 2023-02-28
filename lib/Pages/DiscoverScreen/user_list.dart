import 'package:get/get.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/block_list.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/contacts.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/likes_list.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/mylikes_list.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

import '../../Components/constants.dart';

class UserList extends StatefulWidget {
  @override
  _MemoriesBlankWidgetState createState() => _MemoriesBlankWidgetState();
}

class _MemoriesBlankWidgetState extends State<UserList> {
  bool Tag = true;
  int yourActiveIndex = 0;
  String Search = "";
  TextEditingController searchController = new TextEditingController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   setState(() {
  //     Constant.current_plan = "DIAMOND";
  //     Constant.plan_active = 1;
  //   });
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                    ),
                  ),
                ),
                Column(
                  children: [
                    yourActiveIndex == 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 55, right: 55),
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
                                                    FlutterFlowTheme.secondaryColor1)),
                                        child: Text(
                                          'Hide Me',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            yourActiveIndex = 0;
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
                                        child: Text(
                                          'Blocks',
                                          style: TextStyle(
                                            color: FlutterFlowTheme.ButtonC1,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            yourActiveIndex = 1;
                                          });
                                        },
                                        // color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                  if (Constant.plan_active == 0)
                                    ...[]
                                  else if (Constant.current_plan == 'DIAMOND' ||
                                      Constant.current_plan == 'PREMIUM') ...[
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
                                          child: Text(
                                            'Liked Me',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: FlutterFlowTheme.ButtonC1),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              yourActiveIndex = 2;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    Container(),
                                  ],
                                  if (Constant.plan_active == 0)
                                    ...[]
                                  else if (Constant.current_plan == "DIAMOND") ...[
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
                                          child: Text(
                                            'Liked By Me',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 8,
                                                color: FlutterFlowTheme.ButtonC1),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              yourActiveIndex = 3;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    Container()
                                  ],
                                ],
                              ),
                            ),
                          )
                        : yourActiveIndex == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 55, right: 55),
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
                                                      BorderRadius.circular(
                                                          18.0),
                                                  // side: BorderSide(color: Colors.red)
                                                )),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.grey.shade300,
                                                )),
                                            child: Text(
                                              'Hide Me',
                                              style: TextStyle(
                                                color: FlutterFlowTheme.ButtonC1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                yourActiveIndex = 0;
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
                                                      BorderRadius.circular(
                                                          18.0),
                                                  // side: BorderSide(color: Colors.red)
                                                )),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        FlutterFlowTheme
                                                            .secondaryColor1)),
                                            child: Text(
                                              'Blocks',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                yourActiveIndex = 1;
                                              });
                                            },
                                            // color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                      if (Constant.plan_active == 0)
                                        ...[]
                                      else if (Constant.current_plan ==
                                              'DIAMOND' ||
                                          Constant.current_plan ==
                                              "PREMIUM") ...[
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 45.0,
                                            width: 180,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    // side: BorderSide(color: Colors.red)
                                                  )),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.grey.shade300,
                                                  )),
                                              child: Text(
                                                'Liked Me',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: FlutterFlowTheme.ButtonC1),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  yourActiveIndex = 2;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        Container(),
                                      ],
                                      if (Constant.plan_active == 0)
                                        ...[]
                                      else if (Constant.current_plan ==
                                          "DIAMOND") ...[
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 45.0,
                                            width: 180,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    // side: BorderSide(color: Colors.red)
                                                  )),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.grey.shade300,
                                                  )),
                                              child: Text(
                                                'Liked By Me',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 8,
                                                    color: FlutterFlowTheme.ButtonC1),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  // Tag=value;
                                                  yourActiveIndex = 3;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        Container()
                                      ],
                                    ],
                                  ),
                                ),
                              )
                            : yourActiveIndex == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 55, right: 55),
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
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      // side: BorderSide(color: Colors.red)
                                                    )),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Colors.grey.shade300,
                                                    )),
                                                child: Text(
                                                  'Hide Me',
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.ButtonC1,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    yourActiveIndex = 0;
                                                    ;
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
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      // side: BorderSide(color: Colors.red)
                                                    )),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Colors.grey.shade300,
                                                    )),
                                                child: Text(
                                                  'Blocks',
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.ButtonC1,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    yourActiveIndex = 1;
                                                  });
                                                },
                                                // color: Colors.pink,
                                              ),
                                            ),
                                          ),
                                          if (Constant.plan_active == 0)
                                            ...[]
                                          else if (Constant.current_plan ==
                                                  'DIAMOND' ||
                                              Constant.current_plan ==
                                                  "PREMIUM") ...[
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
                                                            BorderRadius
                                                                .circular(18.0),
                                                        // side: BorderSide(color: Colors.red)
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        FlutterFlowTheme.secondaryColor1,
                                                      )),
                                                  child: Text(
                                                    'Liked Me',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      yourActiveIndex = 2;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ] else ...[
                                            Container(),
                                          ],
                                          if (Constant.plan_active == 0)
                                            ...[]
                                          else if (Constant.current_plan ==
                                              "DIAMOND") ...[
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
                                                            BorderRadius
                                                                .circular(18.0),
                                                        // side: BorderSide(color: Colors.red)
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        Colors.grey.shade300,
                                                      )),
                                                  child: Text(
                                                    'Liked By Me',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 8,
                                                        color: FlutterFlowTheme.ButtonC1),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      // Tag=value;
                                                      yourActiveIndex = 3;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ] else ...[
                                            Container()
                                          ],
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 55, right: 55),
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
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      // side: BorderSide(color: Colors.red)
                                                    )),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Colors.grey.shade300,
                                                    )),
                                                child: Text(
                                                  'Hide Me',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                      color: FlutterFlowTheme.ButtonC1),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    // Tag=value;
                                                    yourActiveIndex = 0;
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
                                              child: TextButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      // side: BorderSide(color: Colors.red)
                                                    )),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Colors.grey.shade300,
                                                    )),
                                                child: Text(
                                                  'Blocks',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                      color: FlutterFlowTheme.ButtonC1),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    // Tag=value;
                                                    yourActiveIndex = 1;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          if (Constant.plan_active == 0)
                                            ...[]
                                          else if (Constant.current_plan ==
                                                  'DIAMOND' ||
                                              Constant.current_plan ==
                                                  "PREMIUM") ...[
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
                                                            BorderRadius
                                                                .circular(18.0),
                                                        // side: BorderSide(color: Colors.red)
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        Colors.grey.shade300,
                                                      )),
                                                  child: Text(
                                                    'Liked Me',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: FlutterFlowTheme.ButtonC1),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      yourActiveIndex = 2;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ] else ...[
                                            Container(),
                                          ],
                                          if (Constant.plan_active == 0)
                                            ...[]
                                          else if (Constant.current_plan ==
                                              "DIAMOND") ...[
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height: 45.0,
                                                width: 180,
                                                margin:
                                                    EdgeInsets.only(right: 1),
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                        // side: BorderSide(color: Colors.red)
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  FlutterFlowTheme
                                                                      .secondaryColor1)),

                                                  child: Text(
                                                    'Liked By Me',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      // Tag=value;
                                                      yourActiveIndex = 3;
                                                    });
                                                  },
                                                  // color: Colors.pink,
                                                ),
                                              ),
                                            ),
                                          ] else ...[
                                            Container()
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            yourActiveIndex == 0
                ? ContactListScreen(
                    search: Search,
                  )
                : yourActiveIndex == 1
                    ? UBlockList()
                    : yourActiveIndex == 2
                        ? ULikesList()
                        : MyLikesList(),
          ],
        ),
      ),
    );
  }
}
