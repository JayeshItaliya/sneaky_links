import 'package:get/get.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/PartyModel.dart';
import 'package:sneaky_links/Pages/RoomScreen/create_room_popup.dart';
import 'package:sneaky_links/Pages/RoomScreen/inside_the_room_without_comment_screen.dart';
import 'package:sneaky_links/Pages/RoomScreen/room_item_widget.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/user_party_controller.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_widgets.dart';

class RoomsScreen extends StatefulWidget {
  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final myController = Get.put(UserPartyController());
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
    return Padding(
      padding: const EdgeInsets.only(
        top: 27,),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 26,
                  right: 26,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SearchBar(
                        obscureText: false,
                        hintT: 'Search',
                        onChange: (str) {
                          myController.updateData(str);
                          print(str);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(CreateRoomPopupScreen());
                        // showCustomDialog(context);
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 1,
                                    color: Colors.pink,
                                    spreadRadius: 0.2)
                              ],
                            ),
                            child: Icon(
                              Icons.celebration,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(

            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: 26,
              top: 10,
              right: 26,
            ),

            child: Obx(
              () => myController.isoffline.value
                  ? Center(child: ConnectionError(
                      onTap: () {
                        // getData();
                        myController.updateData(searchController.text);
                      },
                    ))
                  : myController.isDataProcessing.value
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          controller: myController.scrollController,
                          itemCount: myController.myList.length,
                          itemBuilder: (context, index) {
                            PartyModel item = myController.myList[index];
                            if (index == myController.myList.length - 1 &&
                                myController.isMoreDataAvailable.value) {
                              return Column(
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        print("+++++++++");
                                        print(item.toJson());
                                        var res=await Get.to(InsideTheRoomWithoutCommentScreen(item.roomId.toString()));
                                        if(res!=null){
                                          getData();
                                        }
                                      },
                                      child: RoomsItemWidget(item)),
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              );
                            }
                            return InkWell(
                                onTap: () async {
                                  var res=await Get.to(InsideTheRoomWithoutCommentScreen(item.roomId.toString()));
                                  if(res!=null){
                                    getData();
                                  }
                                },
                                child: RoomsItemWidget(item));
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

}
