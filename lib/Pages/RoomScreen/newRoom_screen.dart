import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sneaky_links/Pages/RoomScreen/inside_the_room_without_comment_screen.dart';
import 'package:sneaky_links/Pages/RoomScreen/nearbyroom.dart';
import 'package:sneaky_links/Pages/RoomScreen/room_screen.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import '../../controllers/party_controller.dart';

class NewRoomScreen extends StatefulWidget {
  @override
  _MemoriesBlankWidgetState createState() => _MemoriesBlankWidgetState();
}

class _MemoriesBlankWidgetState extends State<NewRoomScreen> {
  bool Tag = true;
  final myController = Get.put(PartyController());

  @override
  void initState() {
    super.initState();

    checkpermission_opencamera();
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
        child:  RefreshIndicator(
          onRefresh: ()async{
            myController.getTask(0);
          },
          child: SingleChildScrollView(
            controller: myController.scrollController,
            physics: ClampingScrollPhysics(),
            child: Column(
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              children: [
                SizedBox(
                  height: 20,
                ),
                Tag ? Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 65, right: 35),
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
                                    child: SizedBox(
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
                                        child: const Text(
                                          'Nearby Parties',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            Tag = true;
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
                                          'My Parties',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
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
                          ),
                          Align(
                            alignment: Alignment(-0.9,0.0),
                            child: InkWell(
                              onTap: (){
                                Get.to(InsideTheRoomWithoutCommentScreen("109"));
                              },
                              child: Image.asset(
                                "assets/images/slp.png",
                                height: 45,
                                width: 45,
                                // fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 65, right: 35),
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
                                          'Nearby Parties',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
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
                                      margin: const EdgeInsets.only(right: 1),
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
                                        child: const Text(
                                          'My Parties',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
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
                        Align(
                          alignment: Alignment(-0.9,0.0),
                          child: InkWell(
                            onTap: (){
                              Get.to(InsideTheRoomWithoutCommentScreen("109"));

                            },
                            child: Image.asset(
                              "assets/images/slp.png",
                              height: 45,
                              width: 45,
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                Tag ? nearbyRoomsScreen() : RoomsScreen()

              ],
            ),
          ),
        ),
      ),
    );
  }
}
