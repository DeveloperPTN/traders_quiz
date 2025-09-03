import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:traders_quiz/models/quiz_model.dart';
import 'package:traders_quiz/constants.dart';

class ApiService {
  static const String baseUrl = "http://18.136.217.168:3000";

// Admin Login
  static Future<Map<String, dynamic>> login(String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"password": password}),
    );
    return jsonDecode(res.body);
  }

  // Get quizzes
  static Future<List<QuizData>> getQuizzes() async {
    final res = await http.get(Uri.parse("$baseUrl/quizzes"));
    if (res.statusCode == 200) {
      List<dynamic> rawData = jsonDecode(res.body);
      return rawData
          .map((item) => QuizData.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception("Failed to load quizzes");
  }

  // Create quiz
  static Future<Map<String, dynamic>> createQuiz(QuizData quizData) async {
    final res = await http.post(
      Uri.parse("$baseUrl/create_quiz"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(quizData),
    );
    return jsonDecode(res.body);
  }

  // Update quiz
  static Future<Map<String, dynamic>> updateQuiz(QuizData quizData) async {
    final res = await http.post(
      Uri.parse("$baseUrl/update_quiz"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(quizData),
    );
    return jsonDecode(res.body);
  }

  // Delete quiz
  static Future<Map<String, dynamic>> deleteQuiz(int quizId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/delete_quiz"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": quizId}),
    );
    return jsonDecode(res.body);
  }

  // Get quiz by code
  static Future<List<dynamic>> getQuiz(int quizCode) async {
    final res = await http.get(Uri.parse("$baseUrl/quizzes/$quizCode"));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to load quiz");
  }

  // Submit answers
  static Future<Map<String, dynamic>> submitAnswers(
      int quizId, List<Map<String, dynamic>> answers) async {
    final res = await http.post(
      Uri.parse("$baseUrl/quizzes/$quizId/submit"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"answers": answers}),
    );
    return jsonDecode(res.body);
  }
}
