
import 'package:flutter/material.dart';

import '../util/app_color.dart';
import '../util/app_text_style.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key, required this.mbti}) : super(key: key);

  final String mbti;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                style: AppTextStyle.b(fontSize: 36),
                children: [
                  TextSpan(text: '우와 '),
                  TextSpan(text: '${mbti.toUpperCase()}', style: TextStyle(color: AppColor.blue)),
                  TextSpan(text: '다!'),
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}
