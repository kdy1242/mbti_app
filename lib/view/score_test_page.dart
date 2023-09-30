import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mbti_app/util/app_color.dart';
import 'package:mbti_app/util/app_text_style.dart';
import 'package:mbti_app/data/question.dart';
import 'package:mbti_app/view/result_page.dart';

class ScoreTestPage extends StatefulWidget {
  const ScoreTestPage({super.key});

  @override
  State<ScoreTestPage> createState() => _ScoreTestPageState();
}

class _ScoreTestPageState extends State<ScoreTestPage> {
  PageController pageController = PageController();
  List<List<int?>> answer = List.generate(3, (_) => List.generate(7, (_) => null)); // a, b 선택값이 담겨있는 2차원배열
  int eiScore = 0, snScore = 0, tfScore = 0, jpScore = 0;
  int progress = 0;

  void updateChoice(int row, int column, int value) {
    setState(() {
      if (progress < questions.length && answer[row][column] == null) {
        progress++;
      }
      answer[row][column] = value;
    });
    log('$answer', name: 'answer');
  }

  String getMbti() {
    int eiMiddleScore = answer.length * 3;
    int otherMiddleScore = (answer.length*2)*3;
    String ei, sn, tf, jp;

    for (int i=0; i<answer.length; i++) {
      eiScore += answer[i][0]!;
      snScore += answer[i][1]! + answer[i][2]!;
      tfScore += answer[i][3]! + answer[i][4]!;
      jpScore += answer[i][5]! + answer[i][6]!;
    }

    log('ei: $eiScore, sn: $snScore, tf: $tfScore, jp:$jpScore');

    ei = (eiMiddleScore > eiScore) ? 'e' : 'i';
    sn = (otherMiddleScore > snScore) ? 's' : 'n';
    tf = (otherMiddleScore > tfScore) ? 't' : 'f';
    jp = (otherMiddleScore > jpScore) ? 'j' : 'p';

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
                  padding: const EdgeInsets.fromLTRB(20,0,20,100),
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
                      Text('A: ${questions[index]['options'][0]}', textAlign: TextAlign.center,),
                      SizedBox(height: 14),
                      Text('B: ${questions[index]['options'][1]}', textAlign: TextAlign.center,),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '완전A',
                            style: AppTextStyle.m(fontSize: 18),
                          ),
                          Text(
                            '완전B',
                            style: AppTextStyle.m(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                                updateChoice(row, column, index+1);
                              },
                              child: CircleAvatar(
                                radius: (((2-index)*3).abs() + 10) * 2,
                                backgroundColor: answer[row][column] == index+1 ? AppColor.blue : AppColor.bgBlue,
                              ),
                            ),
                          );
                        }),
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
                              if(answer[i][j] == null) {
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
}
