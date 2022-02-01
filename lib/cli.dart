import 'dart:io';
import 'package:csv/csv.dart';
import 'dart:math';

List readFileSync() {
  String contents = File(
          '/home/steve/Documents/Computing/Flutter_projects/kovol_quiz/assets/data/words.csv')
      .readAsStringSync();
  List<List<dynamic>> _listData =
      const CsvToListConverter(eol: '\n').convert(contents);
  return _listData;
}

void prompt(word) {
  print('what is the meaning of $word?');
}

List getOptions(data) {
  List options = data.sublist(0, 4);
  return options;
}

void printOptions(options) {
  print("""
  1. ${options[0][1]}
  2. ${options[1][1]}
  3. ${options[2][1]}
  4. ${options[3][1]}
  """);
}

int pickRandomInt() {
  var random = Random();
  return random.nextInt(4);
}

void checkAnswer(word, answer, options) {
  if (options[answer][0] == word) {
    print('Correct!\n');
  } else {
    print('Wrong\n');
  }
}

void main() {
  List data = readFileSync();
  
  while (true) {
    data.shuffle();
    String word = data[pickRandomInt()][0];
    List options = getOptions(data);

    prompt(word);
    printOptions(options);
    checkAnswer(word, int.parse(stdin.readLineSync()!) - 1, options);
  }
}
