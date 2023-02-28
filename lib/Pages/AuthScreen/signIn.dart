import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/LoginModal.dart';
import 'package:sneaky_links/Pages/AuthScreen/forgot_screen.dart';
import 'package:sneaky_links/Pages/AuthScreen/signUp.dart';
import 'package:sneaky_links/Pages/main_page.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailfield = TextFormField(
      style: TextStyle(
          fontSize: 15.0,
          // height: 0.6,
          color: Colors.black),
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Username");
        }
        // if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA_Z0-9.-]+.[a-z]").hasMatch(value))
        // {
        //   return ("Please Enter Valid Email");
        // }
        return null;
      },
      decoration: InputDecoration(
        focusColor: Colors.pinkAccent,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.pinkAccent,
          width: 3,
        )),
        contentPadding: EdgeInsets.only(left: 25),
        hintText: "Email, phone & username",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(05),
        ),
      ),
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final passwordField = TextFormField(
      style: TextStyle(
          fontSize: 15.0,
          // height: 0.6,
          color: Colors.black),
      autofocus: false,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please Enter Password");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Password Of 6 length");
        }
      },
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
      controller: passwordController,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final loginButton = MaterialButton(
      focusColor: Colors.grey,
      height: MediaQuery.of(context).size.height < 750 ? 40 : 55,
      minWidth: 350,
      color: Colors.pink.shade600,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: () {
        if (_formKey1.currentState!.validate()) {
          _getLogin();
          // Navigator.push(context,MaterialPageRoute(builder: (context)=>NavBarPage()));
        }
      },
      child: Text(
        "Sign In",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height < 750 ? 17 : 22),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: MediaQuery.of(context).size.height < 750
                    ? const EdgeInsets.fromLTRB(25, 170, 10, 0)
                    : EdgeInsets.fromLTRB(25, 200, 10, 0),
                child: Text(
                  "Lets Sign you in",
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
              padding: MediaQuery.of(context).size.height < 750
                  ? const EdgeInsets.fromLTRB(25, 7, 10, 7)
                  : const EdgeInsets.fromLTRB(25, 7, 10, 12),
              child: Text(
                "Welcome Back,\nYou have been missed",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: MediaQuery.of(context).size.height < 750 ? 20 : 27,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Form(
              key: _formKey1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: MediaQuery.of(context).size.height < 750
                        ? const EdgeInsets.fromLTRB(20, 17, 20, 10)
                        : const EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: emailfield,
                  ),
                  Padding(
                    padding: MediaQuery.of(context).size.height < 750
                        ? const EdgeInsets.fromLTRB(20, 4, 20, 18)
                        : const EdgeInsets.fromLTRB(20, 6, 20, 25),
                    child: passwordField,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(ForgotScreen());
                            // Get.to(ChangePwdScreen( email: '',));
                          },
                          child: Text(
                            "Forgot Password ?",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height < 750
                                        ? 14
                                        : 18,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: MediaQuery.of(context).size.height < 750
                        ? const EdgeInsets.fromLTRB(20, 10, 20, 10)
                        : const EdgeInsets.fromLTRB(20, 15, 20, 18),
                    child: loginButton,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dont Have an account? ",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height < 750
                              ? 15
                              : 18,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(SignUp());
                          },
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height < 750
                                        ? 15
                                        : 18,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future _getLogin() async {
    EasyLoading.show(status: "Loading...");

    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {'Content-Type': 'application/json'};

    try {
      var request = http.Request('POST', Uri.parse(Constant.login));
      request.body = json.encode({
        "email": emailController.text,
        "password": passwordController.text,
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      print(jsonBody.toString());
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
          Constant.phone = user.phone;
          Constant.user_id = user.id;
          Constant.avatarUrl = user.profilePicture;
          Constant.access_token = user.authentication.accessToken;
          Constant.refreshToken = user.authentication.refreshToken;
        });

        EasyLoading.showSuccess("Login successfully");
        Get.offAll(NavBarPage(
          currentPage: 'DiscoverScreen',
        ));
      } else {
        EasyLoading.dismiss();
        // print(jsonBody.toString());
        Get.defaultDialog(
            title: "Incorrect Email/Password",
            middleText:
                "The email/password you entered doesn't appear to belong to an account. Please check your email/password and try again.",
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Try Again")),
            ]);
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
