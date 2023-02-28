import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneaky_links/Models/UserModel.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/app-contact.class.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/block_controller.dart';
import 'package:sneaky_links/controllers/like_controller.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class UBlockList extends StatefulWidget {
  // String search;
  // ULikesList(this.search);

  @override
  State<UBlockList> createState() => _ULikesListState();
}

class _ULikesListState extends State<UBlockList> {
  final myController = Get.put(BlockController());
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
          padding: EdgeInsets.only(top: 10,left: 18,right: 18),

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
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 04,left: 18,right: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => myController.isoffline.value
                    ? Center(child: ConnectionError(
                        onTap: () {
                          // getData();
                          myController.updateData(searchController.text);
                        },
                      ))
                    :myController.myList.length<=0
                    ? Container(
                  height: 200,
                      child: Align(
                      alignment:Alignment.center,
                      child: Text(
                         "No Users Blocked"
                        )),
                    )
                    : myController.isDataProcessing.value
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            controller: myController.scrollController,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.only(left: 2, right: 2),
                            itemCount: myController.myList.length,
                            itemBuilder: (BuildContext ctx, index) {
                              if(index==myController.myList.length-1&&myController.isMoreDataAvailable.value){
                                return Center(child: CircularProgressIndicator(),);
                              }
                              UserModel item = myController.myList[index];
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(item.username.toString()),
                                    subtitle: Text(item.phone.toString()),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    onTap: (){
                                      showProfileDialog(context,item.id);
                                    },
                                    // leading: ContactAvatar(contact, 36)
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 18.0, right: 18),
                                    child: Divider(
                                      height: 1,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              );
                            }),
              ),
            ],
          ),
        ),
      ],
    );
  }
  showProfileDialog(context,id) async {
    // print(id);
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        // title: new Text("Choose Action"),
        content:   Text("Are you sure you would like to unblock this user?"),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                myController.unblock(id);
                Get.back();
              },
              isDefaultAction: true,
              child: new Text("Yes",
                style: TextStyle(color: FlutterFlowTheme.primaryColor),)),
          CupertinoDialogAction(
              onPressed: () {
                // takePhoto(ImageSource.gallery);
                Get.back();
              },
              isDefaultAction: true,
              child: new Text(
                "No",
                style: TextStyle(color: FlutterFlowTheme.black),
              ))
        ],
      ),
    );
  }

}
