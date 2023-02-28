import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Models/UserModel.dart';
import 'package:sneaky_links/Pages/DiscoverScreen/userProfileD.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:sneaky_links/controllers/users_controller.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class FUsersList extends StatefulWidget {
  bool value;

  FUsersList(this.value);

  @override
  State<FUsersList> createState() => _ULikesListState();
}

class _ULikesListState extends State<FUsersList> {
  final myController = Get.put(UsersController());
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    myController.updateData("", widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size.height < 750
            ? Size.fromHeight(50.0)
            : Size.fromHeight(55.0),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back(result: "data");
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(
                Icons.arrow_back_ios,
                size: MediaQuery.of(context).size.height < 750 ? 22 : 26,
              ),
            ),
            color: Colors.black,
          ),
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0,
          // automaticallyImplyLeading: false,
          title: Text(
            "",
            style: TextStyle(
              // letterSpacing: 2.0,
              fontSize: MediaQuery.of(context).size.height < 750 ? 20 : 24,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 18, right: 18),
        child: Obx(
          () => myController.isoffline.value
              ? Center(child: ConnectionError(
                  onTap: () {
                    // getData();
                    myController.updateData(
                        searchController.text, widget.value);
                  },
                ))
              : myController.isDataProcessing.value
                  ? Center(child: CircularProgressIndicator())
                  : myController.myList.length <= 0
                      ? Container(
                          height: 200,
                          child: const Align(
                              alignment: Alignment.center,
                              child: Text("No Users")),
                        )
                      : myController.isDataProcessing.value
                          ? Center(child: CircularProgressIndicator())
                          : GridView.builder(
                              controller: myController.scrollController,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              padding: EdgeInsets.only(left: 12, right: 12),
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 0.8,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              itemCount: myController.myList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                UserModel item = myController.myList[index];
                                if (index == myController.myList.length - 1 &&
                                    myController.isMoreDataAvailable.value) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.to(UserProfileD(
                                            item: item.id.toString(),
                                          ));
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
                                                  style: const TextStyle(
                                                    color: Colors.pink,
                                                    shadows: <Shadow>[
                                                      Shadow(
                                                        offset:
                                                            Offset(10.0, 10.0),
                                                        blurRadius: 3.0,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                      Shadow(
                                                        offset:
                                                            Offset(10.0, 10.0),
                                                        blurRadius: 8.0,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  item.location,
                                                  style: const TextStyle(
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
                                                  begin: FractionalOffset
                                                      .topCenter,
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
                                    print(item.id);
                                    Get.to(UserProfileD(
                                      item: item.id.toString(),
                                    ));
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
                                              color: Colors.white,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 3.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 8.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            item.location,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 3.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 8.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
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
                                        image: item.profilePicture == ""
                                            ? DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/discover.png"),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: NetworkImage(item.profilePicture),
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
    );
  }
}
