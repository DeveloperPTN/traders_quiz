import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:traders_quiz/models/quiz_model.dart';

class ApiService {
  static const String baseUrl = "http://18.136.217.168:3000";

// Admin Login
  static Future<Map<String, dynamic>> login(String password) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"password": password}),
        )
        .timeout(const Duration(seconds: 10));
    return jsonDecode(res.body);
  }

  // Get quizzes
  static Future<List<QuizData>> getQuizzes() async {
    final res = await http
        .get(Uri.parse("$baseUrl/quizzes"))
        .timeout(const Duration(seconds: 10));
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
    final res = await http
        .post(
          Uri.parse("$baseUrl/create_quiz"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(quizData),
        )
        .timeout(const Duration(seconds: 10));
    return jsonDecode(res.body);
  }

  // Update quiz
  static Future<Map<String, dynamic>> updateQuiz(QuizData quizData) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/update_quiz"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(quizData),
        )
        .timeout(const Duration(seconds: 10));
    return jsonDecode(res.body);
  }

  // Delete quiz
  static Future<Map<String, dynamic>> deleteQuiz(int quizId) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/delete_quiz"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"id": quizId}),
        )
        .timeout(const Duration(seconds: 10));
    return jsonDecode(res.body);
  }

  // Get quiz by code
  static Future<List<dynamic>> getQuiz(int quizCode) async {
    final res = await http
        .get(Uri.parse("$baseUrl/quizzes/$quizCode"))
        .timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to load quiz");
  }

  // Submit answers
  static Future<Map<String, dynamic>> submitAnswers(
      int quizId, List<Map<String, dynamic>> answers) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/quizzes/$quizId/submit"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"answers": answers}),
        )
        .timeout(const Duration(seconds: 10));
    return jsonDecode(res.body);
  }

  // Delete quiz
  static Future<String> uploadImage({File? image}) async {
    // Step 1: Get presigned URL from your backend
    final urlRes = await http
        .get(Uri.parse("$baseUrl/presign"))
        .timeout(const Duration(seconds: 10));
    if (urlRes.statusCode != 200) throw Exception("Failed to get URL");
    Map<String, dynamic> body = jsonDecode(urlRes.body);
    final uploadUrl = body['uploadUrl'].toString();
    String fileUrl = body['fileUrl'].toString();
    final url = Uri.parse(uploadUrl.replaceAll('"', ''));

    // Step 2: Upload image directly to S3
    final res = await http.put(
      url,
      body: image?.readAsBytesSync(),
      headers: {"Content-Type": "image/jpeg"},
    ).timeout(const Duration(seconds: 30));
    String urlPath = "";
    if (res.statusCode == 200) urlPath = fileUrl;
    return urlPath;
  }
}
