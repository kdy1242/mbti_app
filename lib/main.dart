import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mbti_app/home_page.dart';
import 'package:mbti_app/question.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('엠비티아이'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: HomePage(),
      ),
    );
  }
}
