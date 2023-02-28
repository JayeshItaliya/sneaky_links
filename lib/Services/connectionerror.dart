import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';

class ConnectionError extends StatefulWidget {
  final VoidCallback? onTap;

  ConnectionError({this.onTap});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<ConnectionError> {
  @override
  Widget build(BuildContext context) => Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/errorimage.png",
            fit: BoxFit.cover,
            height: 300,
            width: 300,
          ),
          Text(
            "OOPS!\nYOUR CONNECTION HAS LOST",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: FlutterFlowTheme.primaryColor,
              ),
              onPressed: widget.onTap,
              child: Text("Refresh"))
        ],
      ));
}
