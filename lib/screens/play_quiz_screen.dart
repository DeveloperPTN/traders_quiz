import 'dart:io';
import 'package:flutter/material.dart';
import 'package:traders_quiz/models/question_model.dart';
import 'package:traders_quiz/models/quiz_model.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:traders_quiz/screens/result_screen.dart';

class PlayQuizPage extends StatefulWidget {
  final QuizData quizData;

  const PlayQuizPage({super.key, required this.quizData});

  @override
  State<PlayQuizPage> createState() => _PlayQuizPageState();
}

class _PlayQuizPageState extends State<PlayQuizPage> {
  final TextEditingController _answerTextCtrl = TextEditingController();
  void _submitQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => QuizResultPage(
                score: userPoints,
                total: totalPoints,
                quizData: widget.quizData,
              )),
    );
  }

  int currentIndex = 0;
  Option? selectedOption;
  int userPoints = 0;
  int totalPoints = 0;

  void _nextQuestion() {
    // check answer
    Question question = widget.quizData.questions[currentIndex];
    if (question.questionType == "Single Select") {
      int maxPoint = 0;
      for (Option opt in question.options) {
        if (opt.optionPoints > maxPoint) maxPoint = opt.optionPoints;
        if (selectedOption != null &&
            selectedOption?.optionText == opt.optionText) {
          opt.optionAnswer = true;
        }
      }
      totalPoints += maxPoint;
      if (selectedOption != null) {
        userPoints += selectedOption!.optionPoints;
      }
    } else if (question.questionType == "Multiple Choice") {
      for (Option opt in question.options) {
        totalPoints += opt.optionPoints;
        if (opt.optionAnswer == opt.optionCorrect) {
          userPoints += opt.optionPoints;
        }
      }
    } else if (question.questionType == "Paragraph") {
      widget.quizData.questions[currentIndex].answer = _answerTextCtrl.text;
      totalPoints += question.points;
      if (_answerTextCtrl.text.isNotEmpty) {
        userPoints += question.points;
      }
    }

    if (currentIndex < widget.quizData.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null; // reset selection
      });
    } else {
      // quiz finished
      _submitQuiz();
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (q.questionImagePath != null &&
                q.questionImagePath.toString() != "")
              Center(
                child: GestureDetector(
                  onTap: () {
                    FullscreenImageViewer.open(
                      context: context,
                      child: Hero(
                        tag: 'hero_image', // Unique tag for Hero animation
                        child: Image.file(
                          File(q.questionImagePath.toString()),
                        ),
                      ),
                    );
                  },
                  child: Image.file(
                    File(q.questionImagePath.toString()),
                    height: 300,
                  ),
                ),
              ),
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
                    }),
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
                      }),
                    },
                  },
                },
              ],
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        ElevatedButton.icon(
          onPressed: _nextQuestion,
          label: Text(currentIndex == widget.quizData.questions.length - 1
              ? "Finish"
              : "Next"),
        ),
      ],
    );
  }
}
