import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

class HelpScreen extends StatefulWidget {
  HelpScreen({Key? key}) : super(key: key);

  @override
  _ContactusWidgetState createState() => _ContactusWidgetState();
}

class _ContactusWidgetState extends State<HelpScreen> {
  late TextEditingController msgController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    msgController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
          key: scaffoldKey,
          extendBodyBehindAppBar: true,
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
              'Help',
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
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding:
                          EdgeInsetsDirectional
                              .fromSTEB(0,
                              10, 0, 0),
                          child: Text(
                            'Have a question?\nGet in touch and We\'ll get back to you',
                            textAlign: TextAlign
                                .center,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional
                                .fromSTEB(
                                0, 4, 0, 16),
                            child: TextFormField(
                              controller: msgController,
                              obscureText: false,
                              maxLines: MediaQuery.of(context).size.height<670?6:MediaQuery.of(context).size.height<770?8:15,
                              decoration:
                              InputDecoration(
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 2),borderRadius: BorderRadius.circular(8),),
                                hintText:
                                'Maximum 400 characters',
                                focusColor:
                                FlutterFlowTheme.primaryColor,
                                // labelStyle: texts,
                                enabledBorder:
                                OutlineInputBorder(
                                  borderSide:
                                  BorderSide(
                                    color: FlutterFlowTheme
                                        .primaryColor,
                                    width: 0.5,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                ),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderSide:
                                  BorderSide(
                                    color: FlutterFlowTheme
                                        .primaryColor,
                                    width: 0.5,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                ),
                                filled: true,
                                fillColor:
                                Colors.white,
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        // Spacer(flex: 2),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 20, bottom: 0),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: FlutterFlowTheme.primaryColor,
                            height: 48,
                            minWidth: MediaQuery.of(context).size.width,
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18),
                            ),
                            onPressed: ()  {
                              if (formKey
                                  .currentState
                              !.validate()) {
                                _getHelp();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ]),
                ),
              )
            ],
          )),
    );
  }

  Future _getHelp() async {

    EasyLoading.show(status: "Loading...");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + Constant.access_token
    };

    try {

      var request = http.Request('POST', Uri.parse(Constant.help));
      request.body = json.encode({
          "email": Constant.email,
          "name": Constant.name,
          "problem": msgController.text
      });
      request.headers.addAll(headers);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
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
