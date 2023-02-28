import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/AuthScreen/change_pwd_screen.dart';

class VerifyScreen extends StatefulWidget {
  String email;

  VerifyScreen({Key? key,required this.email}) : super(key: key);

  @override
  _Forget2State createState() => _Forget2State();
}

class _Forget2State extends State<VerifyScreen>{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  final codecontroller=TextEditingController();
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
          icon: Icon(Icons.arrow_back_ios,
          ),
        ),
        toolbarHeight: MediaQuery.of(context).size.height<750?45:55,
        backgroundColor: Colors.white.withOpacity(0),
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Verification",style: TextStyle(
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
             SizedBox(height: 20,),
              Expanded(
                flex: 3,
                child: Image.asset("assets/images/verify.png",
                  scale: MediaQuery.of(context).size.height<750?1:0.85,),
              ),
              Expanded(
                flex:1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Please Enter The 4 Digit Code Sent To \n"+widget.email,
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      // letterSpacing: 2.0,
                      fontSize: MediaQuery.of(context).size.height<750?13:17,
                      // fontWeight: FontWeight.w900,
                      fontFamily: 'LibreFranklin',
                    ),
                  ),
                ),
              ),

              OTPTextField(
                length: 4,
                width: MediaQuery.of(context).size.width,
                fieldWidth: MediaQuery.of(context).size.height<750?35:42,
                outlineBorderRadius: 3,
                otpFieldStyle: OtpFieldStyle(
                  backgroundColor: Color(0xFFFFE5F5),
                    // focusBorderColor: Colors.orange //(here)
                ),
                onChanged: (str){

                },
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height<750?18:27,
                  fontWeight: FontWeight.bold,
                  // decoration: TextDecoration.underline,
                  // decorationColor: Colors.purple


                ),
                textFieldAlignment: MainAxisAlignment.spaceEvenly,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) {
                  print("Completed: " + pin);
                  setState(() {
                    codecontroller.text=pin;

                  });
                },
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: MediaQuery.of(context).size.height<750?const EdgeInsets.only(top : 35.0):const EdgeInsets.only(top : 45.0),
                  child: MaterialButton(
                    focusColor: Colors.grey,
                    height: MediaQuery.of(context).size.height<750?40:58,
                    minWidth: MediaQuery.of(context).size.height<750?180:200,
                    color: Colors.pink.shade600,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height<750?20.0:27,)
                    ),
                    onPressed: () {
                      _verifyemail();

                    },
                    child: Text("Verify",textAlign:TextAlign.center,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height<750?15:20
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


  Future _verifyemail() async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json'
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.verify_pwd));
      request.body = json.encode({
        "email":widget.email,
        "code":codecontroller.text

      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        Get.to(ChangePwdScreen(email:widget.email));

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
