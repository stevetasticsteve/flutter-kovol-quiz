import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: aboutWidget,
    );
  }
}

Widget aboutWidget = Container(
  padding: EdgeInsets.all(8.0),
  child: Center(
    child: Column(
      children: [
        Image.asset('assets/images/madang_map.png'),
        Container( padding:EdgeInsets.all(10),
        child: Text(
          aboutString, 
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),),)
      ],
    ),
));

const String aboutString =
    '''
The Kovol language of Papua New Guinea has roughly 1000 speakers.
It has the ethnologue language code of kgu.

This quiz is built using data gathered by missionaries who have been studying the language.
    ''';
