import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4 Digits Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FourDigitsGame(),
    );
  }
}

class FourDigitsGame extends StatefulWidget {
  @override
  _FourDigitsGameState createState() => _FourDigitsGameState();
}

class _FourDigitsGameState extends State<FourDigitsGame> {
  List<String> fourDigitsActual = [];

  List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    generateFourDigitsActual();
  }

  void generateFourDigitsActual() {
    String numberList = "0123456789";
    final random = Random();
    for (int i = 0; i < 4; i++) {
      final randomIndexChosen = random.nextInt(numberList.length);
      final digitChosen = numberList[randomIndexChosen];
      fourDigitsActual.add(digitChosen);
      setState(() {
        numberList = numberList.substring(0, randomIndexChosen) +
            numberList.substring(randomIndexChosen + 1);
      });
    }

    print(fourDigitsActual);
  }

  String check(List<String> fourDigitsAnswer, List<String> fourDigitsActual) {
    int A = 0;
    int B = 0;

    for (int i = 0; i < 4; i++) {
      final currentAnswerDigit = fourDigitsAnswer[i];
      if (fourDigitsActual.contains(currentAnswerDigit)) {
        B++;
      }
    }

    for (int i = 0; i < 4; i++) {
      if (fourDigitsAnswer[i] == fourDigitsActual[i]) {
        A++;
        B--;
      }
    }

    return '$A A & $B B';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4 Digits Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the 4 digits game!',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'You have to guess a 4 digit number where each digit is unique.',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'After you have entered all 4 digits to guess, I will provide feedback in the form of A and B.',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'eg. 1A = 1 digit exists in the answer and is in the right position',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '1B = 1 digit exists in the answer but not in the right position',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '1A 1B = 2 digits exist in the answer but only 1 is in the right position',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '2A 2B = All digits exist in the answer but only 2 are in the right position',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Hope you understand the rules, best of luck!',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Find the 4 digits:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                4,
                (index) => Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: TextField(
                      controller: controllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.length > 0) {
                          if (index < controllers.length - 1) {
                            FocusScope.of(context).nextFocus();
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                List<String> fourDigitsAnswer = [];
                for (var controller in controllers) {
                  fourDigitsAnswer.add(controller.text);
                }
                final response = check(fourDigitsAnswer, fourDigitsActual);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Result'),
                      content: Text(response),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            if (response == '4 A & 0 B') {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Congratulations!'),
                                    content: Text(
                                      'You have solved the four digits!',
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.popUntil(
                                            context,
                                            (route) => route.isFirst,
                                          );
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Guess'),
            ),
          ],
        ),
      ),
    );
  }
}
