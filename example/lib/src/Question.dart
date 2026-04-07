
import 'package:dart_ts_generator/dart_ts_generator.dart';

@TsGenerate()
class Option {
  String text;
  bool isSelected = false;
  bool isCorrect = false;
  String index;
  Option({this.text = '', this.index = ''});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Option && runtimeType == other.runtimeType && text == other.text;

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() {
    return 'Option{text: $text}';
  }
}

class Question {
  String? id;
  String? question;
  List<Option> options = List.empty(growable: true);
  String? asset;
  late int correctOption;
  int? questionNumber;
  bool isAnswered = false;
  Option? answeredOption;

  bool isCorrect(Option option) {
    return options[correctOption - 1] == option;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'option1': options[0].text,
      'option2': options[1].text,
      'option3': options[2].text,
      'asset': asset,
      'correct_answer': options.indexOf(options[correctOption - 1])
    };
  }

  static Question fromJson(Map<String, dynamic> model) {
    Question q = Question();
    q.id = model['qid'].toString();
    q.questionNumber = model['qid'.toString()];
    q.question = model['question'];
    q.options.add(
      Option(text: model['option1'], index: 'a'),
    );
    q.options.add(
      Option(text: model['option2'], index: 'b'),
    );
    q.options.add(
      Option(text: model['option3'], index: 'c'),
    );
    q.correctOption = model['correct_answer'];
    q.options[q.correctOption - 1].isCorrect = true;
    q.asset = model['image'];
    return q;
  }
}
