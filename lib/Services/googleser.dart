import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:sneaky_links/Services/connectionerror.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Components/constants.dart';

final mapkey = "AIzaSyCICfk-dh166H3MEaF2SgmtHhDcNlcf-8w";

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launch(launchUri.toString());
}

Future<void> sentMail(String email) async {
  final Uri launchUri = Uri(
    scheme: 'mailto',
    path: email,
  );
  await launch(launchUri.toString());
}

Future<void> openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showLongToast("Could not open");
    throw 'Could not launch $url';
  }
}

void showConnectivitySnackBar(ConnectivityResult result) {
  final hasInternet = result != ConnectivityResult.none;
  if (!hasInternet) Get.offAll(ConnectionError());
}

Widget errmsg(show) {
  //error message widget.
  if (show == true) {
    //if error is true then show error message box
    return Container(
      padding: EdgeInsets.all(10.00),
      margin: EdgeInsets.only(bottom: 10.00),
      color: Colors.red,
      child: Row(children: [
        Container(
          margin: EdgeInsets.only(right: 6.00),
          child: Icon(Icons.info, color: Colors.white),
        ), // icon for error message

        Text("Could not connect to internet",
            style: TextStyle(color: Colors.white)),
        //show error message text
      ]),
    );
  } else {
    return Container();
    //if error is false, return empty container.
  }
}

onShareData(text) async {
  await Share.share(text);
}
