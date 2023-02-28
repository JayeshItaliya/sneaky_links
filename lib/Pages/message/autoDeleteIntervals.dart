import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Services/api_repository.dart';
import 'package:http/http.dart'as http;
import '../../flutter_flow/flutter_flow_theme.dart';

class AutoDeleteScreen extends StatefulWidget {
  String id;

  AutoDeleteScreen({Key? key,required this.id}) : super(key: key);

  @override
  _AutoDeleteState createState() => _AutoDeleteState();
}

class _AutoDeleteState extends State<AutoDeleteScreen> {
  bool _value = false;
  int val = 6;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(" heyyyyyy");
    getauto_delete_interval();

  }

  getauto_delete_interval() async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };
    var request = http.Request('GET',Uri.parse(Constant.auto_delete_interval+"/${widget.id}/set-auto-delete-intervals"));

    request.headers.addAll(headers);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);
    print(jsonBody.toString()) ;

    if (response.statusCode == 200) {
      print(jsonBody.toString()) ;
      // print(jsonBody['data']['autoIntervalDeleteInSeconds']);
      final jsonBody1=jsonBody['data'];
      Constant.AutoIntervals=jsonBody1['autoIntervalDeleteInMinutes']??0;
      if(Constant.AutoIntervals==0)
      {
        setState(() {
          val=6;
        });
      }
      if(Constant.AutoIntervals==10)
      {
        setState(() {
          val=1;
        });
      }
      if(Constant.AutoIntervals==30)
      {
        setState(() {
          val=2;
        });
      }
      if(Constant.AutoIntervals==60)
      {
        setState(() {
          val=3;
        });
      }
      if(Constant.AutoIntervals==720)
      {
        setState(() {
          val=4;
        });
      }
      if(Constant.AutoIntervals==1440)
      {
        setState(() {
          val=5;
        });
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x00FFFFFF).withOpacity(.1),
          iconTheme: IconThemeData(color: FlutterFlowTheme.black),
          automaticallyImplyLeading: true,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_rounded)),
          title: Text(
            "Auto Delete Intervals",
            textAlign: TextAlign.center,
            style: TextStyle(
              // letterSpacing: 2.0,
              fontSize: MediaQuery.of(context).size.height<750?20:24,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: Text("10 mins"),
              onTap: (){
                setState(() {
                  val=1;
                  Constant.AutoIntervals=10;
                  print("Hello 10 mins");
                  auto_delete_interval();
                });                  },
              leading: Radio(
                value: 1,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val=1;
                    Constant.AutoIntervals=10;
                    auto_delete_interval();
                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,
              ),
            ),
            ListTile(
              title: Text("30 mins"),
              onTap: (){
                setState(() {
                  val=2;
                  Constant.AutoIntervals=30;
                  print("Hello 30 mins");
                  auto_delete_interval();
                });
              },
              leading: Radio(
                value: 2,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val=2;
                    Constant.AutoIntervals=30;
                    auto_delete_interval();
                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,
              ),
            ),
            ListTile(
              title: Text("1 Hrs"),
              onTap: (){
                setState(() {
                  val=3;
                  Constant.AutoIntervals=60;
                  print("Hello 1hr");
                  auto_delete_interval();
                });
              },
              leading: Radio(
                value: 3,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val=3;
                    Constant.AutoIntervals=60;
                    auto_delete_interval();
                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,
              ),
            ),
            ListTile(
              title: Text("12 Hrs"),
              onTap: (){
                setState(() {
                  val=4;
                  Constant.AutoIntervals=720;
                  print("Hello 12hr");
                  auto_delete_interval();
                });
              },
              leading: Radio(
                value:4,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val=4;
                    Constant.AutoIntervals=720;
                    auto_delete_interval();

                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,
              ),
            ),
            ListTile(
              title: Text("24 Hrs"),
              onTap: (){
                setState(() {
                  val=5;
                  Constant.AutoIntervals=1440;
                  print("Hello 24hr");
                  auto_delete_interval();
                });
              },
              leading: Radio(
                value: 5,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val=5;
                    Constant.AutoIntervals=1440;
                    auto_delete_interval();

                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,
              ),
            ),
            ListTile(
              title: Text("Never"),
              onTap: (){
                setState(() {
                  val=6;
                  Constant.AutoIntervals=0;
                  print("Hello Never");
                  auto_delete_interval();
                });
              },
              leading: Radio(
                value: 6,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val=6;
                    Constant.AutoIntervals=0;
                    auto_delete_interval();

                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,
              ),
            ),
          ],
        )
    );
  }

  Future auto_delete_interval() async {
    EasyLoading.show(status: "Loading...");


    print(Constant.auto_delete_interval+"/${widget.id}/set-auto-delete-intervals");
    try {
      var headers = {
      'Content-Type': 'application/json',
              'Accept': 'application/json',
        'Authorization': 'Bearer ' + Constant.access_token
      };
      var request = http.Request('POST', Uri.parse(Constant.auto_delete_interval+"/${widget.id}/set-auto-delete-intervals"));
      request.body = json.encode({
        "autoIntervalDeleteInMinutes": Constant.AutoIntervals,
      });
      request.headers.addAll(headers);

      request.headers.addAll(headers);
      print(request.body.toString());

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      print(jsonBody.toString());

      if (response.statusCode == 200) {
        print(jsonBody.toString());
        EasyLoading.dismiss();
      }
      else {
        EasyLoading.dismiss();
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
