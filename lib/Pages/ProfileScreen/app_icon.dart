import 'dart:io';

import 'package:flutter/services.dart';

enum IconType {Default,Book,Beauty,Doctor,Birds,Lion,MyHeart }

class AppIcon {
  static const MethodChannel platform = MethodChannel('appIconChannel');

  static Future<void> setLauncherIcon(IconType icon) async {
    if (!Platform.isIOS) return null;

    String iconName;

    switch (icon) {
      case IconType.Default:
        iconName = 'Default';
        break;
      case IconType.Book:
        iconName = 'Book';
        break;
      case IconType.Beauty:
        iconName = 'Beauty';
        break;
      case IconType.Doctor:
        iconName = 'Doctor';
        break;
      case IconType.Birds:
        iconName = 'Birds';
        break;
      case IconType.Lion:
        iconName = 'Lion';
        break;
      case IconType.MyHeart:
        iconName = 'MyHeart';
        break;
      default:
        iconName = 'Default';
        break;
    }

    return await platform.invokeMethod('changeIcon', iconName);
  }
}