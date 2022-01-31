// import 'dart:ui';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

void main() {
  runApp(const Quiz());
}

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {

  // Future<String> _loadData() async {
  //   return await rootBundle.loadString('assets/data/words.csv');
  // }

  Future<String> _loadData() async {
    final _rawData = await rootBundle.loadString("assets/data/words.csv");
    List _listData = CsvToListConverter().convert(_rawData);
    return _listData[0];
  }

  @override
  Widget build(BuildContext context) {
    Widget quizQuestion = Container(
        child: Column(children: [
          const Text(
            'What is the meaning of:',
            style: const TextStyle(fontSize: 25),
          ),

          FutureBuilder<String>(
            future: _loadData(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Result: ${snapshot.data}'),
                  )
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),


          Text('question',
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
