import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mbti_app/util/app_color.dart';
import 'package:mbti_app/util/app_text_style.dart';
import 'package:mbti_app/data/question.dart';
import 'package:mbti_app/view/result_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  PageController pageController = PageController();
  List<List<String>> answer = List.generate(3, (_) => List.generate(7, (_) => '')); // a, b 선택값이 담겨있는 2차원배열
  int progress = 0;

  void updateChoice(int row, int column, String value) {
    setState(() {
      if (progress < questions.length && answer[row][column] == '') {
        progress++;
      }
      answer[row][column] = value;

      log('$answer', name: 'answer');
      log('$progress', name: 'progress');
    });
  }

  String getMbti() {
    int eScore = 0, iScore = 0, sScore = 0, nScore = 0, tScore = 0, fScore = 0, jScore = 0, pScore = 0;
    String ei, sn, tf, jp;

    for (int i=0; i<answer.length; i++) {
      if (answer[i][0] == 'a') eScore++; else iScore++;
      if (answer[i][1] == 'a' || answer[i][2] == 'a') sScore++; else nScore++;
      if (answer[i][3] == 'a' || answer[i][4] == 'a') tScore++; else fScore++;
      if (answer[i][5] == 'a' || answer[i][6] == 'a') jScore++; else pScore++;
    }

    log('e: $eScore, i: $iScore, s: $sScore, n: $nScore, t: $tScore, f: $fScore, j: $jScore, p:$pScore');

    ei = (eScore > iScore) ? 'e' : 'i';
    sn = (sScore > nScore) ? 's' : 'n';
    tf = (tScore > fScore) ? 't' : 'f';
    jp = (jScore > pScore) ? 'j' : 'p';

    return '${ei+sn+tf+jp}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('< $progress / ${questions.length} >', style: AppTextStyle.r(fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 10,
                color: AppColor.progressGrey,
                child: Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width-30) / questions.length * progress,
                      decoration: BoxDecoration(
                        color: AppColor.blue,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: questions.length + 1,
              itemBuilder: (context, index) {
                int row = index ~/ 7;
                int column = index % 7;
                return index < questions.length ? Padding(
                  padding: const EdgeInsets.fromLTRB(30,0,30,100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, bottom: 28),
                        child: SvgPicture.asset(
                          'assets/image/question_image.svg',
                        ),
                      ),
                      Text(
                        '${index + 1}. ${questions[index]['question']}',
                        style: AppTextStyle.m(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      Column(
                        children: [
                          AnswerButton(row, column, true, questions[index]['options'][0], answer[row][column] == 'a'),
                          SizedBox(height: 15),
                          AnswerButton(row, column, false, questions[index]['options'][1], answer[row][column] == 'b'),
                        ],
                      )
                    ],
                  ),
                ) : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: SvgPicture.asset(
                          'assets/image/main_image.svg',
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: (){
                          List notSolveQuestion = [];
                          for(int i=0; i<answer.length; i++) {
                            for (int j=0; j<answer[i].length; j++) {
                              if(answer[i][j] == '') {
                                int questionNumber = i * answer[i].length + j + 1;
                                notSolveQuestion.add('$questionNumber번');
                              };
                            }
                          }
                          if (notSolveQuestion.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('안푼문제: ${notSolveQuestion}'),
                                  duration: Duration(seconds: 3),
                                )
                            );
                          } else {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ResultPage(mbti: getMbti());
                              },
                            ));
                          }
                          log('$notSolveQuestion', name: 'notSolveQuestion');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColor.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('결과 보기', style: AppTextStyle.m(fontSize: 20,color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget AnswerButton(int row, int column, bool isA, String option, bool isSelected) {
    return GestureDetector(
      onTap: (){
        pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
        updateChoice(row, column, isA ? 'a': 'b');
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 35),
        decoration: BoxDecoration(
          color: !isSelected ? AppColor.bgGrey : AppColor.bgBlue,
          border: Border.all(color: !isSelected ? AppColor.borderGrey : AppColor.blue, width: !isSelected ? 1 : 6),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          textAlign: TextAlign.center,
          '${isA ? 'A.' : 'B.'} $option',
          style: !isSelected
            ? AppTextStyle.r(fontSize: 16, color: Colors.black)
            : AppTextStyle.b(fontSize: 16, color: AppColor.blue),
        ),
      ),
    );
  }
}
