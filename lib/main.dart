// import 'dart:ui';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = await loadCSV();
  runApp(Quiz(data: data));
}

// List<List<dynamic>> data = [];

loadCSV() async {
  final rawData = await rootBundle.loadString('assets/data/test.csv');
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
  @override
  Widget build(BuildContext context) {
    Widget quizQuestion = Container(
        child: Column(children: [
          const Text(
            'What is the meaning of:',
            style: const TextStyle(fontSize: 25),
          ),
          Text(widget.data[1][0],
              style: const TextStyle(
                  fontSize: 20, height: 2, fontStyle: FontStyle.italic)),
        ]),
        margin: const EdgeInsets.all(40));

    Widget answerButtons = Column(
      // mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            _buildAnswerButton('answer 1'),
            _buildAnswerButton('answer 2')
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        Row(children: [
          _buildAnswerButton('answer 3'),
          _buildAnswerButton('ans 4')
        ], mainAxisAlignment: MainAxisAlignment.center),
      ],
    );
    return MaterialApp(
      title: 'Kovol quiz',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kovol quiz'),
        ),
        body: Center(
            child: Column(
          children: [quizQuestion, answerButtons],
        )),
      ),
    );
  }

  Widget _buildAnswerButton(String label) {
    final buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Expanded(
        child: Container(
      child: ElevatedButton(
          style: buttonStyle, onPressed: () {}, child: Text(label)),
      margin: const EdgeInsets.all(8),
      height: 70,
    ));
  }
}
