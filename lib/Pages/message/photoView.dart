import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photo_view/photo_view.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class PView extends StatefulWidget {
  String media;
  String messageId;
  String userName;
  PView(this.media,this.messageId,this.userName);

  @override
  _PViewState createState() => _PViewState();
}

class _PViewState extends State<PView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_rounded)),
        title: Text(
          widget.userName,
          textAlign: TextAlign.center,
          style: TextStyle(
            // letterSpacing: 2.0,
            fontSize: MediaQuery
                .of(context)
                .size
                .height < 750 ? 20 : 24,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body:  Container(
        width: MediaQuery.of(context).size.width,
        height:  MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: widget.messageId,
              child: _blueRectangle(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _blueRectangle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height:  MediaQuery.of(context).size.height/1.2,
      // color: Colors.pinkAccent,
      // child:Image.network(widget.media)
      child:PhotoView(
        imageProvider: NetworkImage(widget.media),
      )
    );
  }
}
