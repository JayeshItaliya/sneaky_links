import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sneaky_links/Models/notiModel.dart';
import '../../controllers/notification_controller.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final myController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: MediaQuery.of(context).size.height < 750 ? 20 : 24,
            ),
          ),
          color: Colors.black,
        ),
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Notification",
          style: TextStyle(
            // letterSpacing: 2.0,
            fontSize: MediaQuery.of(context).size.height < 750 ? 20 : 24,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),

      ),

      body: Container(

        child:Obx( () =>
        // NotificationController.isoffline.value
        //     ? Center(child: ConnectionError(
        //   onTap: () {
        //     // getData();
        //     // myController.updateData(searchController.text);
        //   },
        // ))
        //     :  NotificationController.myList.length <= 0
        //     ? Container(
        //   height: 200,
        //   child: Align(
        //       alignment: Alignment.center,
        //       child: Text("No Data Found")),
        // )
        //     :
        ListView.builder(
            // controller: recentController
            //     .scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics:
            ClampingScrollPhysics(),
            padding: EdgeInsets.only(
                left: 2, right: 2),
            itemCount: myController.myList.length,
            itemBuilder:
                (BuildContext ctx, index) {
                  NotiModel item = myController.myList[index];

              return Padding(
                padding:
                const EdgeInsets.all(
                    8.0),
                child: InkWell(
                  onTap: () async {

                    // var data = {
                    //   'id': item1.receiverId.toString()==Constant.user_id?item1.senderId.toString():item1.receiverId.toString(),
                    //   'user': item1.username.toString(),
                    //   'image': item1.profilePicture.toString(),
                    //   'token': "",
                    // };
                    // var res=await
                    // Get.to(Chat(data: data,));
                    // if(res!=null)
                    //   getData();
                  },
                  child: ListTile(
                    leading:  ClipRRect(
                      borderRadius: BorderRadius.circular(
                        getHorizontalSize(
                          30.08,
                        ),
                      ),
                      child:
                      item.profilePicture==""?
                      Image.asset(
                        "assets/images/discover.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ):
                      Image.network(
                        "${item.profilePicture}",
                        height: getSize(
                          70.06,
                        ),
                        width: getSize(
                          70.06,
                        ),
                        fit: BoxFit.cover,
                      )


                    ),
                    title: Text(
                      "${item.username}",
                      overflow: TextOverflow
                          .ellipsis,
                      textAlign:
                      TextAlign.left,
                      style: TextStyle(
                        color: ColorConstant
                            .bluegray900,
                        fontSize: 20,
                        fontFamily: 'Rubik',
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "${item.message}",
                      maxLines: null,
                      textAlign:
                      TextAlign.left,
                      style: TextStyle(
                        color: ColorConstant
                            .gray400,
                        fontSize: 16,
                        fontFamily: 'Rubik',
                        fontWeight:
                        FontWeight.w400,
                      ),
                    ),
                    trailing: Text(
                      "${(DateFormat("d MMMM yyyy").format(DateTime.now()) == datTime1(item.createdAt) ? "${datTime2(item.createdAt)}" : (DateFormat("d MMMM yyyy").format(DateTime.now().subtract(Duration(days: 1))) == datTime1(item.createdAt)) ? 'Yesterday' : datTime1(item.createdAt))}",
                      textAlign:
                      TextAlign
                          .left,
                      style: TextStyle(
                        color:
                        ColorConstant
                            .gray400,
                        fontSize: 17,
                        fontFamily:
                        'Rubik',
                        fontWeight:
                        FontWeight
                            .w400,
                      ),
                    ),
                  ),
                ),
              );
            }),
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
}
