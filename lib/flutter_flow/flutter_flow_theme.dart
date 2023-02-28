import 'package:flutter/material.dart';
import 'dart:ui';

class FlutterFlowTheme {
  static const Color primaryColor = Color(0xFFD60048);
  static const Color secondaryColor = Color(0xFFFF99BB);
  static const Color secondaryColor1 = Color(0xFFF7006A);
  static const Color tertiaryColor = Color(0xFFFFE5F5);
  static const Color ButtonC1 = Color(0xFFF7006A);

  static const Color black = Color(0xFF000000);
  static const Color grey1 = Color(0xFF878787);
  static const Color grey2 = Color(0xFF566469);
  static const Color grey3 = Color(0xCCD2DADB);
  static const Color grey4 = Color(0xCCF9F9F9);
  // static const Color grey4 = Color(0xFF666666);
  static const Color alert = Color(0xFFDB2032);
  static const Color blue = Color(0xFF307AFF);
  static const Color iconsC = Color(0xFF9747FF);

  String primaryFontFamily = 'Poppins';
  String secondaryFontFamily = 'Roboto';
}


class ColorConstant {
  static Color gray400 = fromHex('#bdbdbd');
  static Color black900 = fromHex('#000000');
  static Color gray500A1 = fromHex('#a1a8a8a8');
  static Color gray50 = fromHex('#fffafc');
  static Color gray30000 = fromHex('#00e0e0e0');
  static Color bluegray900 = fromHex('#262b42');
  static Color gray300 = fromHex('#e6e6e6');
  static Color pinkA400 = fromHex('#d60047');
  static Color pinkA500 = fromHex('#F7006A');
  static Color bluegray100 = fromHex('#d9d9d9');
  static Color pink500 = fromHex('#e6008a');
  static Color whiteA700 = fromHex('#ffffff');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

}


Size size = WidgetsBinding.instance!.window.physicalSize /
    WidgetsBinding.instance!.window.devicePixelRatio;

///This method is used to set padding/margin (for the left and Right side) & width of the screen or widget according to the Viewport width.
double getHorizontalSize(double px) {
  return px * (size.width / 414);
}

///This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
double getVerticalSize(double px) {
  num statusBar = MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
      .viewPadding
      .top;
  num screenHeight = size.height - statusBar;
  return px * (screenHeight / 896);
}

///This method is used to set text font size according to Viewport
double getFontSize(double px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

///This method is used to set smallest px in image height and width
double getSize(double px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

