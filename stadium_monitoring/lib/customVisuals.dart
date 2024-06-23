import 'package:flutter/material.dart';

// Class to define text style field
class CustomTextFieldStyle {
  static TextStyle labelStyleInputText = const TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
    color: Colors.black,
  );

  static TextStyle labelStyleDefault({Color?color, bool bold = false, double?fontsize}){
    return TextStyle(
      fontSize: fontsize,
      fontFamily: 'Montserrat',
      color: color ?? AppColors.appfontPurple,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
}

// Class to define button style
class CustomButtonStyle {
  static ButtonStyle elevatedButtonStyle({
    Color primaryColor = AppColors.appButtonPurple,
    double elevation = 2,
    double borderRadius = 0,
    double width = 315,
    double height = 20,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      minimumSize: Size(width, height),
    );
  }
}

// class for colors
class AppColors {
  //Basic colors
  static const Color primaryColor = Color(0xFF221F21);
  static const Color appBarColor = Color(0xFF1B191C);
  static const Color appYellowColor = Color(0xFFEDAF10);
  static const Color backSensorWidget = Color(0xFF312C2F);

  //Button color
  static const Color appButtonPurple = Color(0xFF5C5261);

  //Font colors
  static const Color appfontPurple = Color(0xFF321C3D);
  static const Color appfontWhite = Color(0xFFFFFFFF);
}