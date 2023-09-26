
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mbti_app/question.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  List<List<String>> answer = List.generate(10, (_) => List.generate(7, (_) => '')); // a, b 선택값이 담겨있는 2차원배열
  String mbti = '';

  void updateChoice(int row, int column, String value) {
    setState(() {
      answer[row][column] = value;
      log('$answer', name: 'answer');
    });
  }

  void getMbti() {
    int eScore = 0, iScore = 0, sScore = 0, nScore = 0, tScore = 0, fScore = 0, jScore = 0, pScore = 0;
    String ei, sn, tf, jp;
    for (int i=0; i<answer.length; i++) {
      if (answer[i][0] == 'a') eScore++; else iScore++;
      if (answer[i][1] == 'a' || answer[i][2] == 'a') sScore++; else nScore++;
      if (answer[i][3] == 'a' || answer[i][4] == 'a') tScore++; else fScore++;
      if (answer[i][5] == 'a' || answer[i][6] == 'a') jScore++; else pScore++;
    }
    log('e: $eScore, i: $iScore, s: $sScore, n: $nScore, t: $tScore, f: $fScore, j: $jScore, p:$pScore');
    if (eScore > iScore) ei = 'e'; else ei = 'i';
    if (sScore > nScore) sn = 's'; else sn = 'n';
    if (tScore > fScore) tf = 't'; else tf = 'f';
    if (jScore > pScore) jp = 'j'; else jp = 'p';
    mbti = '${ei+sn+tf+jp}';
    setState(() {});
    log('$mbti', name: 'mbti');
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: questions.length + 1,
      itemBuilder: (context, index) {
        int row = index ~/ 7;
        int column = index % 7;
        return index < questions.length ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. ${questions[index]['question']}'),
            Text('A: ${questions[index]['options'][0]}'),
            Text('A: ${questions[index]['options'][1]}'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    updateChoice(row, column, 'a');
                    pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
                  },
                  child: Text('A'),
                ),
                ElevatedButton(
                  onPressed: () {
                    updateChoice(row, column, 'b');
                    pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
                  },
                  child: Text('B'),
                ),
              ],
            )
          ],
        ) : Column(
          children: [
            ElevatedButton(
              onPressed: () {
                log('$answer', name: '결과보기');
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
                }
                log('$notSolveQuestion', name: 'notSolveQuestion');
                getMbti();
              },
              child: Text('결과보기'),
            ),
            Text('$mbti'),
          ],
        );
      },
    );
  }
}
