class Question {
  String questionText;
  int points;
  String? questionImagePath;
  String questionType;
  List<Option> options;
  String answer;
  Question({
    required this.questionText,
    required this.points,
    required this.questionImagePath,
    required this.questionType,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionText: json["question_text"],
        points: json["points"],
        questionImagePath: json["question_image_path"],
        questionType: json["question_type"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question_text": questionText,
        "points": points,
        "question_image_path": questionImagePath,
        "question_type": questionType,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "answer": answer,
      };
}

class Option {
  String optionText;
  int optionPoints;
  bool optionCorrect;
  bool optionAnswer;
  Option({
    required this.optionText,
    required this.optionPoints,
    required this.optionCorrect,
    required this.optionAnswer,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        optionText: json["option_text"],
        optionPoints: json["option_points"],
        optionCorrect: json["option_correct"],
        optionAnswer: json["option_answer"],
      );

  Map<String, dynamic> toJson() => {
        "option_text": optionText,
        "option_points": optionPoints,
        "option_correct": optionCorrect,
        "option_answer": optionAnswer,
      };
}
