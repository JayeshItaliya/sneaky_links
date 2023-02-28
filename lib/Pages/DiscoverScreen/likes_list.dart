import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Models/UserModel.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/app-contact.class.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/userProfileD.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/like_controller.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class ULikesList extends StatefulWidget {
  // String search;
  // ULikesList(this.search);

  @override
  State<ULikesList> createState() => _ULikesListState();
}

class _ULikesListState extends State<ULikesList> {
  final myController = Get.put(LikesController());
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData(){
    myController.updateData("");
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, left: 18, right: 18),

          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              errorBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: FlutterFlowTheme.grey1, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: EdgeInsets.zero,
              prefixIcon: Icon(
                Icons.search,
                color: FlutterFlowTheme.grey1,
              ),
              hintText: "Search",
              focusColor: FlutterFlowTheme.grey3,
// labelStyle: texts,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.grey3,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.grey3,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (str) {
              myController.updateData(str);
            },
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height*0.78,
          padding: EdgeInsets.only(top:4, left: 18, right: 18),
          child: Obx(
            () => myController.isoffline.value
                ? Center(child: ConnectionError(
                    onTap: () {
                      // getData();
                      myController.updateData(searchController.text);
                    },
                  ))
                : myController.myList.length <= 0
                    ? Container(
                        height: 200,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("No Users Liked Me")),
                      )
                    : myController.isDataProcessing.value
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            controller: myController.scrollController,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding:
                                EdgeInsets.only(left: 12, right: 12, top: 20),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemCount: myController.myList.length,
                            itemBuilder: (BuildContext ctx, index) {
                              UserlikesModel item = myController.myList[index];

                              if (index == myController.myList.length - 1 &&
                                  myController.isMoreDataAvailable.value) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        var res =await Get.to(UserProfileD(
                                          item: item.id.toString(),
                                        ));
                                        if(res!=null){
                                          getData();
                                        }
                                      },
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.username +
                                                    ", " +
                                                    item.age.toString(),
                                                style: TextStyle(
                                                    color: Colors.white,shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 3.0,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 8.0,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
                                                ],),
                                              ),
                                              Text(
                                                item.location,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 3.0,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 8.0,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
                                                ],),
                                              ),
                                            ],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            // borderRadius: BorderRadius.circular(15),
                                            image: item.profilePicture == ""
                                                ? DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/discover.png"),
                                                    fit: BoxFit.cover)
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                        item.profilePicture),
                                                    fit: BoxFit.cover),
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
                                                    FractionalOffset.topCenter,
                                                end: FractionalOffset
                                                    .bottomCenter,
                                                tileMode: TileMode.repeated)),
                                      ),
                                    ),
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                );
                              }
                              return InkWell(
                                onTap: () {
                                  Get.to(UserProfileD(
                                    item: item.id.toString(),
                                  ));
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.username +
                                              ", " +
                                              item.age.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          item.location,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      // borderRadius: BorderRadius.circular(15),
                                      image: item.profilePicture == ""
                                          ? DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/discover.png"),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: NetworkImage(
                                                  item.profilePicture),
                                              fit: BoxFit.cover),
                                      gradient: new LinearGradient(
                                          colors: [
                                            Color(0xE0E0E0),
                                            Color(0xD4A8A8A8),
                                          ],
                                          stops: [
                                            0.0,
                                            1.0
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          tileMode: TileMode.repeated)),
                                ),
                              );
                            }),
          ),
        ),
      ],
    );
  }
}

