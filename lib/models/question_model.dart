import 'dart:ffi';

class Question {
  int questionId;
  String questionText;
  int points;
  String? questionImagePath;
  String questionType;
  List<Option> options;

  Question({
    required this.questionId,
    required this.questionText,
    required this.points,
    required this.questionImagePath,
    required this.questionType,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionId: json["question_id"],
        questionText: json["question_text"],
        points: json["points"],
        questionImagePath: json["question_image_path"],
        questionType: json["question_type"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "question_text": questionText,
        "points": points,
        "question_image_path": questionImagePath,
        "question_type": questionType,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  int optionId;
  String optionText;
  int optionPoints;
  bool optionCorrect;

  Option({
    required this.optionId,
    required this.optionText,
    required this.optionPoints,
    required this.optionCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        optionId: json["option_id"],
        optionText: json["option_text"],
        optionPoints: json["option_points"],
        optionCorrect: json["option_correct"],
      );

  Map<String, dynamic> toJson() => {
        "option_id": optionId,
        "option_text": optionText,
        "option_points": optionPoints,
        "option_correct": optionCorrect,
      };
}
