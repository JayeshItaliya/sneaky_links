import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Services/api_repository.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<GenderScreen> {

  int val = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Constant.gender=='male')
    {
      setState(() {
        val=1;
      });
    }
    else if(Constant.gender=='female')
    {
      setState(() {
        val=2;
      });
    }
    else if(Constant.gender=='trans')
    {
      setState(() {
        val=3;
      });
    }
    else if(Constant.gender=='other')
    {
      setState(() {
        val=4;
      });
    }else
    {
      setState(() {
        val=-1;
      });
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
            'Choose Gender',
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
              title: Text("All"),
              onTap: () {
                setState(() {
                  val = -1;
                  Constant.gender="null";
                  updateOptions();
                });
              },
              leading: Radio(
                value: -1,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = -1;
                    Constant.gender="null";
                    updateOptions();

                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,

              ),
            ),
            ListTile(
              title: Text("Male"),
              onTap: () {
                setState(() {
                  val = 1;
                  Constant.gender="male";
                  updateOptions();
                });
              },
              leading: Radio(
                value: 1,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = 1;
                    Constant.gender="male";
                    updateOptions();

                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,

              ),
            ),
            ListTile(
              title: Text("Female"),
              onTap: () {
                setState(() {
                  val = 2;
                  Constant.gender="female";
                  updateOptions();
                });
              },
              leading: Radio(
                value: 2,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = 2;
                    Constant.gender="female";
                    updateOptions();
                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,
              ),
            ),
            // ListTile(
            //   title: Text("Bi"),
            //   onTap: () {
            //     setState(() {
            //       val = 3;
            //     });
            //   },
            //   leading: Radio(
            //     value: 3,
            //     groupValue: val,
            //     onChanged: (value) {
            //       setState(() {
            //         val = 3;
            //       });
            //     },
            //     activeColor: FlutterFlowTheme.primaryColor,
            //   ),
            // ),
            ListTile(
              title: Text("Trans"),
              onTap: () {
                setState(() {
                  val = 3;
                  Constant.gender="trans";
                  updateOptions();
                });
              },
              leading: Radio(
                value: 3,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = 3;
                    Constant.gender="trans";
                    updateOptions();
                  });
                },
                activeColor: FlutterFlowTheme.primaryColor,
              ),
            ),
            // ListTile(
            //   title: Text("Other"),
            //   onTap: () {
            //     setState(() {
            //       val = 4;
            //       Constant.gender="other";
            //       updateOptions();
            //     });
            //   },
            //   leading: Radio(
            //     value: 4,
            //     groupValue: val,
            //     onChanged: (value) {
            //       setState(() {
            //         val = 4;
            //         Constant.gender="other";
            //         updateOptions();
            //       });
            //     },
            //     activeColor: FlutterFlowTheme.primaryColor,
            //   ),
            // ),

          ],
        )
    );
  }

}
