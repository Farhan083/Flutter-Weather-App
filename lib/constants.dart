import 'package:flutter/material.dart';

class Constants {
  static const tealGradient = LinearGradient(
    colors: [
      Color(0xFF72EFED),
      Color.fromARGB(255, 85, 235, 213),
      Color.fromARGB(255, 64, 225, 207),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const orangeGradient = LinearGradient(
    colors: [
      Color(0xFFFAE177),
      Color(0xFFFFBE94),
      Color(0xFFFDCD87),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const blueGradient = LinearGradient(
    colors: [
      Color(0xFF5AE3FE),
      Color(0xFF5CB7D8),
      Color(0xFF5ACFFB),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const detailScreenColor = Color(0xFF232634);
  static const blackColor = Colors.black;
  static const whiteColor = Colors.white;
  final greyColor = Colors.grey[600];
  static const primaryTeal = Color(0xFF72EFED);
  static const primaryOrange = Color(0xFFFFBE94);
  static const primaryBlue = Color(0xFF5AE3FE);
  static const cardColorT = Color.fromARGB(255, 128, 239, 237);
  static const cardColorS = Color(0xFFFFCDA5);
  static const cardColorB = Color(0xFF88D9FB);
  static const iconColor = Color(0xFF517795);
  static const messageColor = Color(0xFF2E3341);

  static TextStyle textStyle({
    double fontSize = 16,
    Color? fontColor = const Color(0xFF2E2D60),
    FontWeight fontWeight = FontWeight.w500,
  }) =>
      TextStyle(
        fontFamily: 'MPlus',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: fontColor,
      );
}

class GlobalVariable {
  /// This global key is used in material app for navigation through firebase notifications.
  static final GlobalKey<ScaffoldMessengerState> navigatorState =
      GlobalKey<ScaffoldMessengerState>();
}
