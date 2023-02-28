import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/LoginModal.dart';
import 'package:sneaky_links/Pages/AuthScreen/set_profile_screen.dart';
import 'package:sneaky_links/Pages/AuthScreen/signIn.dart';
import 'package:sneaky_links/Pages/main_page.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../RoomScreen/WebviewTermandCondition.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final fcontroller = TextEditingController();
  final econtroller = new TextEditingController();
  final pcontroller = new TextEditingController();
  final ccontroller = new TextEditingController();

  var _value=false;
  String completePhone="";

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 80,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 70,
                      ),
                    ),
                Container(
                  child: Padding(
                    padding: MediaQuery.of(context).size.height < 750
                        ? EdgeInsets.fromLTRB(25, 30, 10, 0)
                        : EdgeInsets.fromLTRB(25, 60, 10, 0),
                    child: Text(
                      "Ready to be sneaky ?",
                      style: TextStyle(
                        // letterSpacing: 2.0,
                        fontSize:
                            MediaQuery.of(context).size.height < 750 ? 23 : 30,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 10, 7),
                  child: Text(
                    "Let's signup",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize:
                          MediaQuery.of(context).size.height < 750 ? 20 : 27,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Form(
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 30, 0),
                        child:  TextFormField(
                          style:
                         const TextStyle(fontSize: 15.0, fontFamily: 'Poppins', color: Colors.black),
                          autofocus: false,
                          decoration: InputDecoration(
                            focusColor: Colors.pinkAccent,
                            focusedBorder:const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pinkAccent,
                                  width: 3,
                                )),
                            contentPadding:const EdgeInsets.only(left: 25),
                            hintText: "Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          controller: fcontroller,
                          onSaved: (value) {
                            fcontroller.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{8,}$');
                            if (value!.isEmpty) {
                              return ("Please Enter Username");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid Username(Min 8 Character)");
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 15, 30, 0),
                        child: TextFormField(
                          style:const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              // height: 0.6,
                              color: Colors.black),
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Email");
                            }
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA_Z0-9.-]+.[a-z]").hasMatch(value)) {
                              return ("Please Enter Valid Email");
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusColor: Colors.pinkAccent,
                            focusedBorder:const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pinkAccent,
                                  width: 3,
                                )),
                            contentPadding:const EdgeInsets.only(left: 25),
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          controller: econtroller,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            econtroller.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(25, 15, 30, 0),
                        child: IntlPhoneField(
                          decoration:const InputDecoration(
                            hintText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          onChanged: (phone) {
                            print(phone.completeNumber);
                            setState(() {
                              completePhone=phone.completeNumber;
                            });
                          },
                          onCountryChanged: (country) {
                            print('Country changed to: ' + country.name);
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(25, 15, 30, 0),
                      //   child: TextFormField(
                      //     style: TextStyle(
                      //         fontFamily: 'Poppins',
                      //         fontSize: 15.0,
                      //         // height: 0.6,
                      //         color: Colors.black),
                      //     cursorHeight: 25,
                      //     decoration: InputDecoration(
                      //       focusColor: Colors.pinkAccent,
                      //       focusedBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             color: Colors.pinkAccent,
                      //             width: 3,
                      //           )),
                      //       contentPadding: EdgeInsets.only(left: 25),
                      //       hintText: "Phone",
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(05),
                      //       ),
                      //       counter: Offstage(),
                      //     ),
                      //     controller: lcontroller,
                      //     keyboardType: TextInputType.phone,
                      //     onSaved: (value) {
                      //       lcontroller.text = value!;
                      //     },
                      //     textInputAction: TextInputAction.next,
                      //     // maxLength: 10,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return ("Please Enter Phone Number");
                      //       }
                      //       // if(value.length != 10)
                      //       // {
                      //       //   return ("Enter Valid phone number of 10 digits");
                      //       // }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 10, 30, 0),
                        child: TextFormField(
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              // height: 0.6,
                              color: Colors.black),
                          autofocus: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            focusColor: Colors.pinkAccent,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pinkAccent,
                                  width: 3,
                                )),

                            contentPadding: EdgeInsets.only(left: 25),
                            hintText: "Password",
                            // labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{8,}$');
                            if (value!.isEmpty) {
                              return ("Please Enter Password");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Please Enter Valid Password Of 6 length");
                            }
                          },
                          controller: pcontroller,
                          onSaved: (value) {
                            pcontroller.text = value!;
                          },
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 15, 30, 0),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Poppins',
                              // height: 0.6,
                              color: Colors.black),
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Confirm Password");
                            }
                            if (value != pcontroller.text) {
                              return "Password Don't Match";
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            focusColor: Colors.pinkAccent,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pinkAccent,
                                  width: 3,
                                )),

                            contentPadding: EdgeInsets.only(left: 25),
                            hintText: "Confirm Password",
                            // labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(05),
                            ),
                          ),
                          controller: ccontroller,
                          onSaved: (value) {
                            ccontroller.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            focusColor: FlutterFlowTheme.primaryColor,
                            activeColor: FlutterFlowTheme.primaryColor,
                            value: _value,
                            onChanged: (bool? str) {
                              setState(() {
                                _value = !_value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              onPressed: (){
                                Get.to(WebViewClass('Terms & Conditions',Constant.termsUrl));
                              },
                              child: Text(
                              "By signing up you are agreeing to the terms and conditions provided",
                                // textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ], //<Widget>[]
                      ),
                      Padding(
                        padding: MediaQuery.of(context).size.height < 750
                            ? const EdgeInsets.fromLTRB(25, 15, 30, 0)
                            : const EdgeInsets.fromLTRB(25, 40, 30, 0),
                        child: MaterialButton(
                          focusColor: Colors.grey,
                          height: MediaQuery.of(context).size.height < 750 ? 40 : 55,
                          minWidth: 350,
                          color: Colors.pink.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () {

                            if (_formKey.currentState!.validate()) {
                              if(_value)
                              _getRagister();
                              else
                                EasyLoading.showError(
                                    "Please accept all Terms and Conditions");
                            }
                          },
                          child: Text(
                            "Sign Up",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.height < 750 ? 17 : 22),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 15, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account ? ",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height < 750
                                        ? 15
                                        : 18,
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Get.to(SignIn());
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height <
                                                  750
                                              ? 15
                                              : 18,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ])),
        ),
      ),
    );
  }

  Future _getRagister() async {
    EasyLoading.show(status: "Loading...");
    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {'Content-Type': 'application/json'};
    try {
      var request = http.Request('POST', Uri.parse(Constant.register));
      request.body = json.encode({
        "email": econtroller.text.toString(),
        "password": pcontroller.text.toString(),
        "confirmPassword": ccontroller.text.toString(),
        "username": fcontroller.text.toString(),
        "phone": completePhone
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      // print(jsonBody.toString());
      if (response.statusCode == 200) {
        UserData user = UserData.fromJson(jsonBody['data']);
        pref.setString(
          "email",
          user.email,
        );
        pref.setString("username", user.username.toString());
        pref.setString("userid", user.id.toString());
        pref.setString("avatarUrl", user.profilePicture.toString());
        pref.setString("phone", user.phone.toString());
        pref.setString(
            "accessToken", user.authentication.accessToken.toString());
        pref.setString(
            "refreshToken", user.authentication.refreshToken.toString());
        pref.setBool("isLogin", true);


        setState(() {
          Constant.isLogin = true;
          Constant.email = user.email;
          Constant.name = user.username;
          Constant.user_id = user.id;
          Constant.avatarUrl = user.profilePicture;
          Constant.access_token = user.authentication.accessToken;
          Constant.refreshToken = user.authentication.refreshToken;
        });

        EasyLoading.showSuccess("Register successfully");
        Get.offAll(NavBarPage(currentPage: 'DiscoverScreen',));

      } else {
        EasyLoading.dismiss();
        print(jsonBody['message']);
        EasyLoading.showError(jsonBody['message']);
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
