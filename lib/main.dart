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
  bool showPopup = false;

  int totalTries = 0;

  List<String> fourDigitsActual = [];

  List<List> answersHistory = [];

  List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());

  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    totalTries = 0;
    fourDigitsActual = [];
    answersHistory = [];
    generateFourDigitsActual();
  }

  generateFourDigitsActual() {
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

  void performGuessAction() {
    List<String> fourDigitsAnswer = [];
    for (var controller in controllers) {
      fourDigitsAnswer.add(controller.text);
    }
    final response = check(fourDigitsAnswer, fourDigitsActual);

    List<String> singleAnswerHistory = [fourDigitsAnswer.join(''), response];
    answersHistory.insert(0, singleAnswerHistory);

    totalTries += 1;
    if (response == '4 A & 0 B') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Congratulations!'),
            content: Text('You have solved the four digits!\n\n'
                    "Total Tries: " +
                totalTries.toString()),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                  // Restart the game
                  setState(() {
                    startGame();
                  });
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }

    // Clear all inputs
    for (var controller in controllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4 Digits Game'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                const Text(
                  'Welcome to the 4 digits game!',
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black)),
                      ),
                      child: Center(
                        child: TextField(
                            controller: controllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            focusNode: focusNodes[index],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              if (value.length > 0) {
                                if (index < controllers.length - 1) {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[index + 1]);
                                } else {
                                  FocusScope.of(context).unfocus();
                                }
                              }
                            },
                            onSubmitted: (value) {
                              if (index < controllers.length - 1) {
                                FocusScope.of(context)
                                    .requestFocus(focusNodes[index + 1]);
                              } else {
                                // If it's the last TextField, perform the guessing action
                                performGuessAction();
                              }
                            }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text("Total tries: " + totalTries.toString()),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Move focus to the first TextField
                    FocusScope.of(context).requestFocus(focusNodes[0]);

                    List<String> fourDigitsAnswer = [];
                    for (var controller in controllers) {
                      fourDigitsAnswer.add(controller.text);
                    }
                    performGuessAction();
                  },
                  child: const Text('Guess'),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Answers History:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: answersHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Split the entry into answer and response
                      final answer = answersHistory[index][0];
                      final response = answersHistory[index][1];

                      // Create a custom ListTile for each entry
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      answer,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      response,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (showPopup)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Rules:\n\n'
                  'You have to guess a 4-digit number where each digit is unique.\n\n'
                  'After you have entered all 4 digits to guess, feedback will be provided in the form of A and B.\n\n'
                  'A indicates a digit exists in the answer and is in the right position.\n\n'
                  'B indicates a digit exists in the answer but is in the wrong position.\n\n'
                  'Example: Answer is 1234 and you input 1320, feedback will be 1A & 2B because one number (\'1\') exists and is in the right position and two numbers (\'2\' and \'3\') exists but is in the wrong position\n\n'
                  'Good luck and have fun!',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showPopup = !showPopup;
          });
        },
        child: Icon(showPopup ? Icons.close : Icons.info),
      ),
    );
  }
}
