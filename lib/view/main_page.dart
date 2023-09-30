import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mbti_app/util/app_color.dart';
import 'package:mbti_app/util/app_text_style.dart';

import 'score_test_page.dart';
import 'test_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SvgPicture.asset(
                  'assets/image/main_image.svg',
                ),
              ),
              Text.rich(
                TextSpan(
                  style: AppTextStyle.b(fontSize: 36),
                  children: [
                    TextSpan(text: '당신의 '),
                    TextSpan(text: 'MBTI', style: TextStyle(color: AppColor.blue)),
                    TextSpan(text: '는?'),
                  ]
                )
              ),
              SizedBox(height: 23),
              Text(
                textAlign: TextAlign.center,
                '내 엠비티아이는 뭘까?\n간단한 테스트를 통해 알아보자!',
                style: AppTextStyle.r(fontSize: 18),
              ),
              SizedBox(height: 23),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestPage())
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColor.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                        '시작하기 (A or B)',
                        style: AppTextStyle.m(fontSize: 20,color: Colors.white)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScoreTestPage())
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColor.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '시작하기 (1 ~ 5)',
                      style: AppTextStyle.m(fontSize: 20,color: Colors.white)
                    )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
