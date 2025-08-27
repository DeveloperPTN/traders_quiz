import 'dart:io';
import 'package:flutter/material.dart';
import 'package:traders_quiz/models/question_model.dart';
import 'package:traders_quiz/models/quiz_model.dart';

class PlayQuizPage extends StatefulWidget {
  final QuizData quizData;

  const PlayQuizPage({super.key, required this.quizData});

  @override
  State<PlayQuizPage> createState() => _PlayQuizPageState();
}

class _PlayQuizPageState extends State<PlayQuizPage> {
  final TextEditingController _answerTextCtrl = TextEditingController();
  void _submitQuiz() {
    int score = 0;
    int totalPoints = 0;

    for (var question in widget.quizData.questions) {
      totalPoints += question.points;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Result"),
        content: Text("Your Score: $score / $totalPoints"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  bool _listsEqual(List<String> a, List<String> b) {
    final setA = a.toSet();
    final setB = b.toSet();
    return setA.length == setB.length && setA.containsAll(setB);
  }

  int currentIndex = 0; // current question index
  Option? selectedOption; // user’s selected answer
  int score = 0; // total score

  void _nextQuestion() {
    // check answer
    if (selectedOption == widget.quizData.questions[currentIndex].answer) {
      score++;
    }

    if (currentIndex < widget.quizData.questions.length) {
      setState(() {
        currentIndex++;
        selectedOption = null; // reset selection
      });
    } else {
      // quiz finished
      _submitQuiz();
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Quiz Completed"),
        content:
            Text("Your score is $score / ${widget.quizData.questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // exit quiz page
            },
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quizData.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No quiz questions available")),
      );
    }

    final q = widget.quizData.questions[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Play Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (q.questionImagePath != null &&
                q.questionImagePath.toString() != "")
              Image.file(File(q.questionImagePath!)),
            const SizedBox(height: 20),
            Text(
              "${currentIndex + 1}. ${q.questionText}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                if (q.questionType == "Paragraph") ...{
                  TextField(
                    controller: _answerTextCtrl,
                    minLines: 1,
                    maxLines: 5,
                    decoration:
                        const InputDecoration(labelText: "Write Answer"),
                  ),
                } else ...{
                  if (q.questionType == "Single Select") ...{
                    ...q.options.map((option) {
                      return RadioListTile<Option>(
                        title: Text(option.optionText),
                        value: option,
                        groupValue: selectedOption,
                        onChanged: (val) {
                          setState(() {
                            selectedOption = val!;
                          });
                        },
                      );
                    }).toList(),
                  } else ...{
                    if (q.questionType == "Multiple Choice") ...{
                      ...q.options.map((option) {
                        return CheckboxListTile(
                          title: Text(option.optionText),
                          value: option.optionAnswer,
                          onChanged: (val) {
                            setState(() {
                              option.optionAnswer = val ?? false;
                            });
                          },
                        );
                      }).toList(),
                    },
                  },
                },
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: _nextQuestion,
          label: Text(currentIndex == widget.quizData.questions.length - 1
              ? "Finish"
              : "Next"),
        ),
      ),
    );
  }
}
