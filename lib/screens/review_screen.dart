import 'package:flutter/material.dart';
import 'package:traders_quiz/models/question_model.dart';

class QuizReviewPage extends StatelessWidget {
  final int userPoints;
  final int totalPoints;
  final List<Question> questions;

  const QuizReviewPage({
    super.key,
    required this.userPoints,
    required this.totalPoints,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    int score = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Review"),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          dynamic correctAnswer;
          dynamic userAnswer;

          bool isCorrect = false;
          if (question.questionType == "Single Select") {
            for (Option opt in question.options) {
              if (opt.optionCorrect) correctAnswer = opt.optionText;
              if (opt.optionAnswer) userAnswer = opt.optionText;
            }
          } else if (question.questionType == "Multiple Choice") {
            correctAnswer = <String>[];
            userAnswer = <String>[];
            for (Option opt in question.options) {
              if (opt.optionCorrect) correctAnswer.add(opt.optionText);
              if (opt.optionAnswer) userAnswer.add(opt.optionText);
            }
          } else if (question.questionType == "Paragraph") {
            if (question.answer.isNotEmpty) {
              correctAnswer = question.answer;
              userAnswer = question.answer;
            }
          }

          // 🔹 Single Answer Check
          if (correctAnswer is String && userAnswer is String) {
            isCorrect = userAnswer == correctAnswer;
          }
          // 🔹 Multiple Choice Check
          else if (correctAnswer is List<String> &&
              userAnswer is List<String>) {
            isCorrect = _listEqualsIgnoreOrder(userAnswer, correctAnswer);
          }

          if (isCorrect) score++;

          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Text(
                    "Q${index + 1}: ${question.questionText}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // User Answer with icon
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Your Answer: ${_formatAnswer(userAnswer)}",
                          style: TextStyle(
                            fontSize: 15,
                            color: isCorrect ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Correct Answer (if wrong)
                  if (!isCorrect)
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Correct Answer: ${_formatAnswer(correctAnswer)}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),

      // Show score at bottom
      bottomNavigationBar: Container(
        color: Colors.blueGrey[50],
        padding: const EdgeInsets.all(16),
        child: Text(
          "Your Score: $userPoints / $totalPoints",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// 🔹 Helper: Format answer (string or list)
  String _formatAnswer(dynamic answer) {
    if (answer is String) return answer;
    if (answer is List<String>) return answer.join(", ");
    return "";
  }

  /// 🔹 Helper: Compare two lists ignoring order
  bool _listEqualsIgnoreOrder(List<String> a, List<String> b) {
    final sortedA = [...a]..sort();
    final sortedB = [...b]..sort();
    if (sortedA.length != sortedB.length) return false;
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }
}
