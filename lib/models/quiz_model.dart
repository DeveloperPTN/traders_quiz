import 'dart:convert';
import 'package:traders_quiz/models/question_model.dart';

QuizModel quizModelFromJson(String str) => QuizModel.fromJson(json.decode(str));

String quizModelToJson(QuizModel data) => json.encode(data.toJson());

class QuizModel {
  List<QuizData> data;

  QuizModel({
    required this.data,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        data:
            List<QuizData>.from(json["data"].map((x) => QuizData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class QuizData {
  int id;
  String code;
  String title;
  String description;
  List<Question> questions;
  QuizData({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.questions,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) => QuizData(
        id: json["id"],
        code: json["code"],
        title: json["title"],
        description: json["description"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "title": title,
        "description": description,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}
