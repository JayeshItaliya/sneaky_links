import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/AuthScreen/signIn.dart';
import '../../controllers/payServices.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'MyDialog.dart';
import 'package:http/http.dart' as http;

class subscribe extends StatefulWidget {
  @override
  _subscribeState createState() => _subscribeState();
}

class _subscribeState extends State<subscribe> {
  var selectedPlan = "";
  var selectedPlanDays = "";
  var selected = true;
  var selected1 = false;
  var selected2 = false;
  var selected3 = false;
  var selected4 = false;
  var value = 'Your Plan: 1 months';

  @override
  void initState() {
    var provider = Provider.of<ProviderModel>(context, listen: false);

    provider.initialize();
    currentPlan();
    super.initState();
  }

  Future<void> _buyProduct(ProductDetails productDetails) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(
            plan: productDetails.title
                .toString()
                .replaceAll(" (Sneaky Links Meet New Friends)", ""),
            initialValue: value,
            onValueChange: (String data) {
              setState(() {
                value = data;
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderModel>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0x00FFFFFF),
        iconTheme: IconThemeData(color: FlutterFlowTheme.black),
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_rounded)),
        title: Text(
          'Membership',
          textAlign: TextAlign.center,
          style: TextStyle(
            // letterSpacing: 2.0,
            fontSize: MediaQuery.of(context).size.height < 750 ? 20 : 24,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 8.0,right: 8.0,bottom: 70),
        child: SafeArea(
          child: Consumer<ProviderModel>(builder: (context, viewModel, child) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: ClampingScrollPhysics(),
              children: [
                if (Constant.current_plan == "FREE")
                  getPlanEx("Free - Voyeur", "Free / Month", selected,
                      "25 Days Left"),
                if (Constant.current_plan != "FREE")
                  getPlan("Free - Voyeur", "Free / Month", selected,
                      "25 Days Left"),
                for (var prod in (provider.products))
                  if (provider.hasPurchased(prod.id) == true) ...[
                    Container(
                      height: 10,
                    ),
                  ] else ...[
                    if (Platform.isIOS) ...[
                      if (prod.title
                              .toString()
                              .toUpperCase()
                              .replaceAll(" PLAN", "") ==
                          Constant.current_plan)
                        planEx(
                          "${prod.title.toString()}",
                          "${prod.price + " / Month"}",
                          false,
                          "${prod.title.toString()}",
                        )
                      else
                        getPlanios(
                            "${prod.title.toString()}",
                            "${prod.price + " / Month"}",
                            false,
                            "${prod.title.toString()}",
                            prod)
                    ],
                    if (Platform.isAndroid) ...[
                      if (prod.title
                              .toString()
                              .toUpperCase()
                              .replaceAll(" PLAN", "") ==
                          Constant.current_plan)
                        planEx(
                          "${prod.title.toString()}",
                          "${prod.price + " / Month"}",
                          false,
                          "${prod.title.toString()}",
                        )
                      else
                        getPlans(
                            "${prod.title.toString().replaceAll(" (Sneaky Links Meet New Friends)", "")}",
                            "${prod.price + " / Month"}",
                            false,
                            "${prod.title.toString().replaceAll(" (Sneaky Links Meet New Friends)", "")}",
                            prod)
                    ],
                    Container(
                      height: 10,
                    )
                  ],
              ],
            );
          }),
        ),
      )),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 40.0, right: 40, top: 10, bottom: 10),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: FlutterFlowTheme.primaryColor,
          height: 48,
          minWidth: 100,
          child: const Text(
            "Invite Code",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 18),
          ),
          onPressed: () {
            _displayTextInputDialog(context);
          },
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    TextEditingController _textFieldController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invite Code'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter Your Code"),
            ),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.black,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Get.back();
                  });
                },
              ),
              FlatButton(
                color: FlutterFlowTheme.primaryColor,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  if(_textFieldController.text==Constant.inviteCode){
                    setState(() {
                      Constant.current_plan="PREMIUM";
                      pref.setString("currentPlan", "PREMIUM");
                      receipt_data(Constant.inviteCode,"PREMIUM");
                    });
                    Get.back();
                  }
                  else if(_textFieldController.text==Constant.inviteCode3){
                    setState(() {
                      Constant.current_plan="DIAMOND";
                      pref.setString("currentPlan", "DIAMOND");
                      receipt_data(Constant.inviteCode3,"DIAMOND");
                    });
                    Get.back();
                  }
                  else if(_textFieldController.text==Constant.inviteCode2){
                    setState(() {
                      Constant.current_plan="ELITE";
                      pref.setString("currentPlan", "ELITE");
                      receipt_data(Constant.inviteCode2,"ELITE");
                    });
                    Get.back();
                  }
                  else if(_textFieldController.text==Constant.inviteCode1){
                    setState(() {
                      Constant.current_plan="FREE";
                      pref.setString("currentPlan", "FREE");
                      receipt_data(Constant.inviteCode1,"FREE");
                    });
                    Get.back();
                  }
                  else{
                    showLongToast("Code not valid");
                  }
                },
              ),
            ],
          );
        });
  }
  Future receipt_data(receipt, productID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    EasyLoading.show(status: "Loading...");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + Constant.access_token
      };
      var request =
      http.Request('POST', Uri.parse(Constant.subscription + "/save"));
      request.body = json.encode({
        "receipt": {
          "receipt": receipt,
          "expiredate": DateTime(
            DateTime.now().year,
            DateTime.now().month + Constant.currentM,
            DateTime.now().day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second,
            DateTime.now().millisecond,
          ).millisecondsSinceEpoch,
          "month": Constant.currentM,
          "likerejectcount": 0,
          "partycount": 0,
          "messagecount": 0,
        },
        "planName": Constant.current_plan.toLowerCase()=="free"?"VOYEUR":Constant.current_plan.toLowerCase()=="platinum"?"PREMIUM":Constant.current_plan.toUpperCase(),
        "productId": "$productID",
        "platform": Constant.device_type
      });
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        pref.setString("currentPlan",
            productID.toString().replaceAll("plan", "").toUpperCase());
        pref.setInt("plan_active", 1);
        Constant.current_plan =
            productID.toString().replaceAll("plan", "").toUpperCase();
        Constant.plan_active = 1;

      } else {
        EasyLoading.showError(Constant.current_plan + jsonBody['message']);
      }
    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }
  Future currentPlan() async {
    // EasyLoading.show(status: "Loading...");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {
      var request = http.Request('get', Uri.parse(Constant.subscription));
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      pref.setString("currentPlan", "FREE");
      pref.setInt("plan_active", 1);

      setState(() {
        Constant.current_plan = "FREE";
        Constant.plan_active = 1;
      });

      print(jsonBody.toString());
      if (response.statusCode == 200) {
        pref.setString("currentPlan", jsonBody['data']['planName'].toString());
        pref.setInt("plan_active", 1);
        setState(() {
          Constant.current_plan = jsonBody['data']['planName'].toString();
          print(jsonBody['data']['receipt']['expiredate'].toString());

          if (DateTime.now().millisecondsSinceEpoch <=
              jsonBody['data']['receipt']['expiredate']) {
            pref.setInt("plan_active", 1);
            Constant.plan_active = 1;
          } else {
            pref.setInt("plan_active", 0);
            Constant.plan_active = 0;
          }

          // Constant.plan_active = 0;
        });

        // EasyLoading.dismiss();
      } else if (response.statusCode == 401) {
        // EasyLoading.dismiss();
        pref.setString("username", "");
        pref.setString("email", "");
        // pref.setString("accessToken", "");
        pref.setBool("isLogin", false);
        Get.offAll(SignIn());
      } else {
        // EasyLoading.dismiss();
        // EasyLoading.showError(jsonBody.toString());
        setState(() {
          Constant.current_plan = "FREE";
          Constant.plan_active = 1;
        });
      }
    } catch (e) {
      print(e.toString());
      // EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Widget getPlanios(title, price, action, days, prod) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _buyProduct(prod);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: action
                      ? FlutterFlowTheme.black
                      : FlutterFlowTheme.primaryColor,
                  width: 2)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          days == "Premium Plan" ? "Platinum Plan" : title,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (days == "Free - Voyeur") ...[
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Voyers",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "5 Like",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "5 Messages",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Can attend paid parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ] else if (days == "Elite Plan") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Likes",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Messaging",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "SL Passport To Any Location",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Messages a month",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Hide Advertisements",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Join 5 Parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ] else if (days == "Diamond Plan") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Message before Matching",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Prioritised Likes",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "See the likes you've sent \nin the last 7 days",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Disappearing Messages",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Host Live Parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "And everything you love \nfrom SL Platinum",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ] else if (days == "Premium Plan") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Likes",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Messaging",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "See Who Likes You",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "New Top Picks every day",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Join a party",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "And everything you love \nfrom SL Elite",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ]
                    else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Unlimited Likes",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Unlimited Messaging",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "See Who Likes You",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "New Top Picks every day",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Join a party",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "And everything you love \nfrom SL Elite",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ]
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "(20% off for 3 months)",
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "(30% off for 6 months)",
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "(40% off for a year)",
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget planEx(
    title,
    price,
    action,
    days,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 250,
          decoration: BoxDecoration(
              color: FlutterFlowTheme.primaryColor.withOpacity(.7),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  // color: Colors.grey[200].withOpacity(.2),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                ), //BoxS
              ]),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          days == "Premium Plan" ? "Platinum Plan" : title,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (days == "Free - Voyeur") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Voyers",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "5 Like",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "5 Messages",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Can attend paid parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ] else if (days == "Elite Plan") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Likes",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Messaging",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "SL Passport To Any Location",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Messages a month",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Hide Advertisements",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Join 5 Parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ] else if (days == "Diamond Plan") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Message before Matching",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Prioritised Likes",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "See the likes you've sent \nin the last 7 days",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Disappearing Messages",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Host Live Parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "And everything you love \nfrom SL Platinum",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ] else if (days == "Premium Plan") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Likes",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Messaging",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "See Who Likes You",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "New Top Picks every day",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Join a party",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "And everything you love \nfrom SL Elite",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ]
                    else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Unlimited Likes",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Unlimited Messaging",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "See Who Likes You",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "New Top Picks every day",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Join a party",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              minRadius: 4,
                              backgroundColor: FlutterFlowTheme.secondaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "And everything you love \nfrom SL Elite",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ]
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "(20% off for 3 months)",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "(30% off for 6 months)",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "(40% off for a year)",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPlans(title, price, action, days, prod) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _buyProduct(prod);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: action
                      ? FlutterFlowTheme.black
                      : FlutterFlowTheme.primaryColor,
                  width: 2)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (days == "Free - Voyeur") ...[
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Voyers",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "5 Like",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "5 Messages",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Can attend paid parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ] else if (days == "Elite Plan") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Likes",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Messaging",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "SL Passport To Any Location",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Messages a month",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Hide Advertisements",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Join 5 Parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ] else if (days == "Diamond Plan") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Message before Matching",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Prioritised Likes",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "See the likes you've sent \nin the last 7 days",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Disappearing Messages",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Host Live Parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Parties",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "And everything you love \nfrom SL Platinum",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ] else if (days == "Platinum Plan") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Likes",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Unlimited Messaging",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "See Who Likes You",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "New Top Picks every day",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Join a party",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            minRadius: 4,
                            backgroundColor: FlutterFlowTheme.secondaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "And everything you love \nfrom SL Elite",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "(20% off for 3 months)",
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "(30% off for 6 months)",
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "(40% off for a year)",
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPlan(title, price, action, days) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            selected = true;
            selected1 = false;
            selected2 = false;
            selected3 = false;
            selected4 = false;
            showLongToast("Activate " + title);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: action
                      ? FlutterFlowTheme.black
                      : FlutterFlowTheme.primaryColor,
                  width: 2)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          minRadius: 4,
                          backgroundColor: FlutterFlowTheme.secondaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Voyers",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          minRadius: 4,
                          backgroundColor: FlutterFlowTheme.secondaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "5 Like",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          minRadius: 4,
                          backgroundColor: FlutterFlowTheme.secondaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "5 Messages",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          minRadius: 4,
                          backgroundColor: FlutterFlowTheme.secondaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Can attend paid parties",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPlanEx(title, price, action, days) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 150,
          decoration: BoxDecoration(
              color: FlutterFlowTheme.primaryColor.withOpacity(.7),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  // color: Colors.grey[200].withOpacity(.2),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                ), //BoxS
              ]),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          minRadius: 4,
                          backgroundColor: FlutterFlowTheme.secondaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Voyers",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          minRadius: 4,
                          backgroundColor: FlutterFlowTheme.secondaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "5 Like",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          minRadius: 4,
                          backgroundColor: FlutterFlowTheme.secondaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "5 Messages",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          minRadius: 4,
                          backgroundColor: FlutterFlowTheme.secondaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Can attend paid parties",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
