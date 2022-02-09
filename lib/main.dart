import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = await loadCSV();
  runApp(Quiz(data: data));
}

loadCSV() async {
  final rawData = await rootBundle.loadString('assets/data/words.csv');
  List<List<dynamic>> listData = CsvToListConverter(eol: '\n').convert(rawData);
  return listData;
}

class Quiz extends StatefulWidget {
  final List data;
  const Quiz({Key? key, required this.data}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int correct = 0;
  int total = 0;
  bool? correctAnswer;

  List pickOptions(data) {
    data.shuffle();
    List options = data.sublist(0, 4);
    return options;
  }

  List pickQuestion(options) {
    var random = Random();
    return options[random.nextInt(options.length)];
  }

  void checkAnwer(question, buttonPress) {
    if (question[1] == buttonPress) {
      setState(() {
        correctAnswer = true;
      });
      correct++;
    } else {
      setState(() {
        correctAnswer = false;
      });
      
    }
    total++;
  }

  @override
  Widget build(BuildContext context) {
    List _options = pickOptions(widget.data);
    List _question = pickQuestion(_options);
    Widget quizQuestion = Container(
        child: Column(children: [
          const Text(
            'What is the meaning of:',
            style: const TextStyle(fontSize: 25),
          ),
          Text(_question[0],
              style: const TextStyle(
                  fontSize: 20, height: 1.5, fontStyle: FontStyle.italic)),
        ]),
        margin: const EdgeInsets.all(20));

    Widget answerButtons = Column(
      children: [
        Row(
          children: [
            _buildAnswerButton(_options[0][1], _question),
            _buildAnswerButton(_options[1][1], _question)
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        Row(children: [
          _buildAnswerButton(_options[2][1], _question),
          _buildAnswerButton(_options[3][1], _question)
        ], mainAxisAlignment: MainAxisAlignment.center),
      ],
    );

    return MaterialApp(
      title: 'Kovol quiz',
      home: Scaffold(
        appBar: AppBar(title: const Text('Kovol quiz'), actions: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 20.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.done),
                    Text('$correct/$total',
                        style: const TextStyle(fontSize: 20)),
                  ]))
        ]),
        body: Center(
            child: Column(
          children: [
            quizQuestion,
            answerButtons,
            AnswerWidget(answer: correctAnswer)
          ],
        )),
      ),
    );
  }

  Widget _buildAnswerButton(String label, List _question) {
    final buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Expanded(
        child: Container(
      child: ElevatedButton(
          style: buttonStyle,
          onPressed: () {
            checkAnwer(_question, '$label');
          },
          child: Text(label)),
      margin: const EdgeInsets.all(8),
      height: 50,
    ));
  }
}

class AnswerWidget extends StatefulWidget {
  const AnswerWidget({required this.answer, Key? key}) : super(key: key);
  final bool? answer;
  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  late String responseText;

  void nextQuestion() {
    print('next question');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.answer == null) {
      responseText = '';
    } else if (widget.answer == true) {
      responseText = 'Correct';
    } else {
      responseText = 'Wrong, tap to continue';
    }
    return GestureDetector(
        onTap: nextQuestion,
        child: Text(responseText,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              height: 2,
              color: widget.answer ?? true ? Colors.green : Colors.red,
            )));
  }
}
