import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'flutter_flow_theme.dart';


class SearchBar extends StatelessWidget {
  SearchBar({
    this.controller,
    this.obscureText,
    this.hintT,
    this.onChange,
  });

  var controller;
  var obscureText;
  var hintT;
  var onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color:  FlutterFlowTheme.grey1, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.zero,
        prefixIcon: Icon(
          Icons.search,
          color: FlutterFlowTheme.grey1,
        ),
        hintText: hintT,
        focusColor:  FlutterFlowTheme.grey3,
// labelStyle: texts,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:  FlutterFlowTheme.grey3,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.grey3,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChange,
    );
  }
}
