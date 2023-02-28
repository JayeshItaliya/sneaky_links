import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class termsconditionWidget extends StatefulWidget {
  termsconditionWidget({Key? key}) : super(key: key);

  @override
  _termsconditionWidgetState createState() => _termsconditionWidgetState();
}

class _termsconditionWidgetState extends State<termsconditionWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Terms & Condition',
            textAlign: TextAlign.center,
            style: TextStyle(
              // letterSpacing: 2.0,
              fontSize: MediaQuery
                  .of(context)
                  .size
                  .height < 750 ? 20 : 24,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(children: [
          SafeArea(
            child: SingleChildScrollView(
              child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 50, 10, 20),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                            Expanded(
                            flex: 1,
                            child: Text(
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\nContrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.',
                              textAlign: TextAlign.start,

                            )
                            )
                            ]))
                  ]),
            ),
          ),
        ]));
  }
}
