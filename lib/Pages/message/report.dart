
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../Components/constants.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'chat.dart';
import 'package:http/http.dart' as http;


class Report extends StatefulWidget {
String userId;
  Report(this.userId);
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  int val = 1;
  String reason="Bad Behaviour";

  TextEditingController? reportController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height:MediaQuery.of(context).size.height,
            // margin: EdgeInsets.only(
            //     left: 30,
            //     right: 30,
            //     top: MediaQuery.of(context).size.height / 5,
            //     bottom: 80),
            decoration: BoxDecoration(
              // borderRadius:
              // BorderRadius
              //     .circular(
              //     15),
              color: ColorConstant.whiteA700,
              // boxShadow: const [
              //   BoxShadow(
              //       blurRadius: 1,
              //       color: Colors.grey,
              //       spreadRadius: 0.2)
              // ],
            ),
            child: Column(
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(

                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 28,
                        )),
                    Align(
                      child: Text(
                        "Report this User?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                          MediaQuery.of(context)
                              .size
                              .height <
                              750
                              ? 20
                              : 22,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      alignment:
                      Alignment.bottomRight,
                    ),
                    Container(),
                  ],
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
                ListTile(
                  title: Text("Bad Behaviour"),
                  onTap: () {
                    setState(() {
                      val = 1;
                      reason="Bad Behaviour";
                      print(reason);



                    });
                  },
                  leading: Radio(
                    value: 1,
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = 1;
                        reason="Bad Behaviour";
                        print(reason);


                      });
                    },
                    activeColor: FlutterFlowTheme
                        .primaryColor,
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
                ListTile(
                  title: Text(
                      "Inapproppriate Convo"),
                  onTap: () {
                    setState(() {
                      val = 2;
                      reason="Inappropriate Convo";
                      print(reason);
                    });
                  },
                  leading: Radio(
                    value: 2,
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = 2;
                        print(val);
                        reason="Inappropriate Convo";
                        print(reason);
                      });
                    },
                    activeColor: FlutterFlowTheme
                        .primaryColor,
                  ),
                ),
                TextField(
                  maxLines: 4,
                  controller: reportController,
                  cursorHeight: 20,
                  autofocus: false,

                  // controller: TextEditingController(
                  //     text: "Initial Text here"),
                  decoration: InputDecoration(
                    // labelText: 'Enter your username',
                    hintText: "Include details about the concern",
                    // prefixIcon: Icon(Icons.star),
                    // suffixIcon:
                    //     Icon(Icons.keyboard_arrow_down),
                    contentPadding:
                    const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(0),
                      borderSide:BorderSide.none,
                    ),
                    filled: true,

                    fillColor: Colors.grey.shade200,
                    // enabledBorder: OutlineInputBorder(
                    //   // borderRadius:
                    //   //     BorderRadius.circular(30),
                    //   borderSide: BorderSide(
                    //       color: Colors.grey, width: 1.5),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   gapPadding: 0.0,
                    //   // borderRadius:
                    //   //     BorderRadius.circular(30),
                    //   borderSide: BorderSide(
                    //       color: Colors.pinkAccent, width: 1.5),
                    // ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),

      floatingActionButton: Container(
        // height:MediaQuery.of(context).size.height / 1.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Divider(
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            InkWell(
              onTap: () {
                print("Helo");
                Get.back();
              },
              child: Padding(
                padding:
                const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Cancel",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                        FontWeight.bold,
                        fontSize:
                        MediaQuery.of(context)
                            .size
                            .height <
                            750
                            ? 14
                            : 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceAround,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            InkWell(
              onTap: () {
                reportUser();
                print("Helo");
              },
              child: Padding(
                padding:
                const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Report",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                        FontWeight.bold,
                        fontSize:
                        MediaQuery.of(context)
                            .size
                            .height <
                            750
                            ? 14
                            : 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceAround,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
  Future reportUser() async {
    EasyLoading.show(status: "Loading...");
    // SharedPreferences pref = await SharedPreferences.getInstance();


    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('POST',Uri.parse(Constant.report));
      print("INNNNNN");

      request.body = json.encode({
        "userIdTo": widget.userId,
        "reason": reason,
        "description": reportController!.text
      });
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print(jsonBody.toString());
      if (response.statusCode == 200) {
        print("success");
        print(reportController!.text);

        EasyLoading.showSuccess("Successfully Reported");
        Get.back();
      } else {
        EasyLoading.showError(jsonBody['message']);
        print(jsonBody.toString());
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

}
