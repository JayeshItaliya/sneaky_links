import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/AuthScreen/signIn.dart';

class ChangePwdScreen extends StatefulWidget {
  String email;
  ChangePwdScreen({Key? key,required this.email}) : super(key: key);

  @override
  _Forget3State createState() => _Forget3State();
}

class _Forget3State extends State<ChangePwdScreen> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final pcontroller=TextEditingController();
  final ccontroller=TextEditingController();

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
            size: MediaQuery.of(context).size.height<750?21:27,),
        ),
        toolbarHeight: MediaQuery.of(context).size.height<750?45:55,
        backgroundColor: Colors.white.withOpacity(0),
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Change Password",style: TextStyle(
          // letterSpacing: 2.0,
          fontSize: MediaQuery.of(context).size.height<750?23:28,
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
                flex: 5,
                child: Image.asset("assets/images/chngpwd.png",
                  scale:MediaQuery.of(context).size.height<750?1.1:0.8,
                ),

              ),

              Expanded(
                flex:1,
                child: Text("Your New Password Must Be Different From Previously Used Password",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    // letterSpacing: 2.0,
                    fontSize: MediaQuery.of(context).size.height<750?15:17,
                    // fontWeight: FontWeight.w900,
                    fontFamily: 'LibreFranklin',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Colors.black,
                        obscureText: true,
                        obscuringCharacter: "*",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            // height: 0.6,
                            color: Colors.black
                        ),
                        autofocus: false,

                        validator:(value){
                          RegExp regex =new RegExp(r'^.{6,}$');
                          if(value!.isEmpty)
                          {
                            return ("Please Enter Your Password");
                          }
                          if(!regex.hasMatch(value))
                          {
                            return ("Please Enter Valid Password Of 6 length");
                          }
                        },
                        decoration: InputDecoration(

                          // contentPadding: EdgeInsets.only(left: 25),
                          labelText: 'Password',
                          // border: InputBorder.none,

                        ),
                        controller: pcontroller,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value){
                          pcontroller.text=value!;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        obscureText: true,
                        obscuringCharacter: "*",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            // height: 0.6,
                            color: Colors.black
                        ),
                        autofocus: false,
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return ("Please Enter Confirm Password");
                          }
                          if(value!=pcontroller.text )
                          {
                            return "Password Don't Match";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.only(left: 25),
                          labelText: 'Confirm Password',
                          // border: InputBorder.none,
                        ),
                        controller: ccontroller,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value){
                          ccontroller.text=value!;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                    ],
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
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height<750?20.0:27,),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate())
                      {
                        _change_Pwd();
                        // Navigator.push(context,MaterialPageRoute(builder: (context)=>SignIn()));
                      }
                    },
                    child: Text("Save",textAlign:TextAlign.center,style: TextStyle(
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

  Future _change_Pwd() async {
    EasyLoading.show(status: "Loading...");

    var headers = {
      'Content-Type': 'application/json'
    };

    try {
      var request = http.Request('POST', Uri.parse(Constant.reset_pwd));
      request.body = json.encode({
        "email":widget.email,
        "newPassword": pcontroller.text,
        "confirmNewPassword": ccontroller.text
      });
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(jsonBody['message']);
        Get.to(SignIn());


      } else {
        EasyLoading.dismiss();
        print(jsonBody['message']);
        EasyLoading.showError(jsonBody['message']);
      }

    } catch (e) {
      EasyLoading.showError("Oops!");
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

}
