import 'package:flutter/material.dart';

class AppTextStyle {
  static const semiBold = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w600);
  static const medium = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500);
  static const regular = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w400);
  static const light = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w300);

  static TextStyle b({double fontSize = 10, Color color = Colors.black}) => semiBold.copyWith(fontSize: fontSize, color: color);
  static TextStyle m({double fontSize = 10, Color color = Colors.black}) => medium.copyWith(fontSize: fontSize, color: color);
  static TextStyle r({double fontSize = 10, Color color = Colors.black}) => regular.copyWith(fontSize: fontSize, color: color);
  static TextStyle l({double fontSize = 10, Color color = Colors.black}) => light.copyWith(fontSize: fontSize, color: color);
}
