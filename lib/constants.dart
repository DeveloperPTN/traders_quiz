import 'package:flutter/material.dart';
import 'package:traders_quiz/models/quiz_model.dart';

class ConstTheme {
  static const Color themeBackColor = Color.fromRGBO(2, 14, 38, 0.612);
  static const Color titleBackColor = Color.fromRGBO(0, 0, 0, 100);
  static const Color titleFontColor = Color.fromRGBO(30, 119, 243, 100);
}

class ConstQuiz {
  static List<QuizData> quizzes = [];
}

enum UserRole { Guest, Member, Admin }
