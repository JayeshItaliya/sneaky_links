import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Models/LoginModal.dart';
import 'package:sneaky_links/Pages/AuthScreen/verify_screen.dart';
class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  _Forgot1State createState() => _Forgot1State();
}

class _Forgot1State extends State<ForgotScreen> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final f0controller=TextEditingController();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leadingWidth: 80,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios,),
        ),
        toolbarHeight: MediaQuery.of(context).size.height<750?45:55,
        backgroundColor: Colors.white.withOpacity(0),
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Forget Password",style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
               flex: 4,
                  child: Container(
                    child: Image.asset("assets/images/forgot.png",
                    scale: MediaQuery.of(context).size.height<750?1:0.85,),
                  ),
              ),
              Expanded(
                flex:1,
                child: Text("Please Enter Your Email Address or Phone Number to Recieve a Verification Code.",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    // letterSpacing: 2.0,
                    fontSize: MediaQuery.of(context).size.height<750?13:17,
                    // fontWeight: FontWeight.w900,
                    fontFamily: 'LibreFranklin',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25),
                child: Form(
                  key: _formKey,
                  child: TextFormField(

                    cursorColor: Colors.grey,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                        // height: 0.6,
                        color: Colors.black
                    ),
                    autofocus: false,

                    validator:(value){
                      if(value!.isEmpty)
                      {
                        return ("Please Enter Email Or Phone Number");
                      }
                      // if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA_Z0-9.-]+.[a-z]").hasMatch(value))
                      // {
                      //   return ("Please Enter Valid Email");
                      // }
                      // return null;
                    },
                    decoration: InputDecoration(
                      focusColor: Colors.pinkAccent,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width:3,
                          )
                      ),
                      contentPadding: EdgeInsets.only(left: 25),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      hintText: "Phone or Email",
                      hintStyle: TextStyle(
                        // color: Colors.grey, // <-- Change this
                        fontSize: 14,
                        // fontWeight: FontWeight.w400,
                        // fontStyle: FontStyle.normal,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width:3,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width:3,
                          ),
                        borderRadius: BorderRadius.circular(18),
                      ),

                    ),
                    controller: f0controller,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value){
                      f0controller.text=value!;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top : 35.0),
                  child: MaterialButton(
                    focusColor: Colors.grey,
                    height: MediaQuery.of(context).size.height<750?40:58,
                    minWidth: MediaQuery.of(context).size.height<750?180:200,
                    color: Colors.pink.shade600,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height<750?20.0:27),
                    ),
                    onPressed: () {

                      if (_formKey.currentState!.validate())
                      {
                        _ForgotPWD();
                        // Navigator.push(context,MaterialPageRoute(builder: (context)=>VerifyScreen()));
                      }
                    },
                    child: Text("Send",textAlign:TextAlign.center,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height<750?12:20
                    ),),


        ),
                ),
              ),
              Expanded(
                  flex:2,
                  child: Container())
            ],
          ),
        ),
      ),

    );
  }

  Future _ForgotPWD() async {
    EasyLoading.show(status: "Loading...");

    SharedPreferences pref = await SharedPreferences.getInstance();

    var headers = {
      'Content-Type': 'application/json'
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.forgot_pwd));
      request.body = json.encode({
        "email":f0controller.text,
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        Get.to(VerifyScreen(email:f0controller.text));

      } else {
        EasyLoading.dismiss();
        print(jsonBody['message']);
        EasyLoading.showError(jsonBody['message']);
        // EasyLoading.showError("The email you entered doesn't appear to belong to an account. Please check your email and try again.");
      }

    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }
}
