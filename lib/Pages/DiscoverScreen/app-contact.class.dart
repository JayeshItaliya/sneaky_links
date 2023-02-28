import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class AppContact {
  Contact info;
  bool hide;

  AppContact({ Key? key, required this.info,required this.hide});
}