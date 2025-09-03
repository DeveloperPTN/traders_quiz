import 'package:flutter/material.dart';
import 'package:traders_quiz/models/quiz_model.dart';
import 'package:traders_quiz/screens/review_screen.dart';

class QuizResultPage extends StatefulWidget {
  final int score;
  final int total;
  final QuizData quizData;
  const QuizResultPage(
      {super.key,
      required this.score,
      required this.total,
      required this.quizData});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage>
    with SingleTickerProviderStateMixin {
  double _scale = 0.5;
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    // Trigger animation when page opens
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _scale = 1.0;
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPassed = widget.score >= (widget.total / 2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Quiz Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              child: Image.asset(
                isPassed
                    ? "assets/images/success.png"
                    : "assets/images/failure.png",
                width: 150,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 800),
              child: Column(
                children: [
                  const Text(
                    "Your Score",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${widget.score} / ${widget.total}",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizReviewPage(
                                    userPoints: widget.score,
                                    totalPoints: widget.total,
                                    questions: widget.quizData.questions,
                                  )));
                    },
                    icon: const Icon(Icons.checklist),
                    label: const Text("Review"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
