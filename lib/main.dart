
import 'package:flutter/material.dart';
import 'package:mbti_app/view/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Pretendard"),
      home: MainPage(),
    );
  }
}
