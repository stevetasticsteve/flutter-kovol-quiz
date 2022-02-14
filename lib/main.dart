import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import './aboutScreen.dart';

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
  bool newQuestion = true;
  bool? correctAnswer;
  late List _options;
  late List _question;

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
      if (newQuestion) {
        // only mark as correct if it was a new question (answer not shown)
        correct++;
        total++;
      }
      setState(() {
        correctAnswer = true;
        newQuestion = true;
      });
    } else {
      if (newQuestion) {
        total++;
      }
      setState(() {
        correctAnswer = false;
        newQuestion = false;
      });
      
    }
    
  }

  void resetQuiz() {
    setState(() {
      correct = 0;
      total = 0;
      correctAnswer = null;
      newQuestion = true;
    });
  }

  Widget _buildAnswerButton(String label, List _question) {
    var buttonStyle;
    if (newQuestion == false && label == _question[1]) {
      buttonStyle = ElevatedButton.styleFrom(
          primary: Colors.green, textStyle: const TextStyle(fontSize: 20));
    } else {
      buttonStyle =
          ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    }
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

  @override
  Widget build(BuildContext context) {
    if (newQuestion) {
      _options = pickOptions(widget.data);
      _question = pickQuestion(_options);
    }
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
        drawer: const AppDrawer(),
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
}

class AnswerWidget extends StatelessWidget {
  const AnswerWidget({required this.answer, Key? key}) : super(key: key);
  final bool? answer;

  @override
  Widget build(BuildContext context) {
    String responseText;
    if (answer == null) {
      responseText = '';
    } else if (answer == true) {
      responseText = 'Correct';
    } else {
      responseText = 'Wrong, tap correct answer to continue';
    }
    return Text(responseText,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          height: 2,
          color: answer ?? true ? Colors.green : Colors.red,
        ));
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Kovol quiz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const AboutPage()));
            },
          ),
        ],
      ),
    );
  }
}
