import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traders_quiz/constants.dart';
import 'package:traders_quiz/models/quiz_model.dart';
import 'package:traders_quiz/screens/create_question_screen.dart';
import 'package:traders_quiz/models/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateQuizPage extends StatefulWidget {
  final int quizIndex;
  final QuizData? quizData;
  const CreateQuizPage({super.key, required this.quizIndex, this.quizData});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    if (widget.quizData != null) {
      _editQuiz();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _editQuiz() {
    setState(() {
      _titleCtrl.text = widget.quizData!.title;
      _descCtrl.text = widget.quizData!.description;
      for (var val in widget.quizData!.questions) {
        _questions.add(val);
      }
    });
  }

  Future<void> _addQuestion() async {
    final result = await Navigator.push<Question>(
      context,
      MaterialPageRoute(
          builder: (_) => const CreateQuestionPage(question: null)),
    );

    if (result != null) {
      setState(() => _questions.add(result));
    }
  }

  Future<void> _editQuestion(BuildContext context, int index) async {
    final result = await Navigator.push<Question>(
      context,
      MaterialPageRoute(
          builder: (_) => CreateQuestionPage(question: _questions[index])),
    );
    if (result != null) {
      setState(() => _questions[index] = result);
    }
  }

  Future<void> _deleteQuestion(BuildContext context, int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content:
            Text('Are you sure you want to delete "${_questions[index]}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _questions.removeAt(index));
    }
  }

  void _createQuiz() {
    final quiz = QuizData(
        id: widget.quizData == null ? 0 : widget.quizData!.id,
        title: _titleCtrl.text,
        description: _descCtrl.text,
        questions: _questions);

    if (widget.quizIndex >= 0) {
      ConstQuiz.quizzes[widget.quizIndex] = quiz; //Edit Existing
    } else {
      ConstQuiz.quizzes.add(quiz); //Add New
    }

    _saveQuiz();
    debugPrint("QUIZ CREATED: ${quiz.toJson()}");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(widget.quizData == null ? "Quiz Created!" : "Quiz Updated")),
    );

    Navigator.pop(
      context,
      quiz,
    );
  }

  Future<void> _saveQuiz() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("quiz_data", jsonEncode(ConstQuiz.quizzes));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quiz Saved Locally ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.quizData == null ? "Create Quiz" : "Update Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: "Quiz Title"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            const Text("Questions", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Expanded(
              child: _questions.isEmpty
                  ? const Center(child: Text("No questions yet"))
                  : ListView.builder(
                      itemCount: _questions.length,
                      itemBuilder: (context, i) {
                        final q = _questions[i];
                        return ListTile(
                          leading: CircleAvatar(child: Text("${i + 1}")),
                          title: Text(q.questionText),
                          subtitle: Text(q.questionType),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Edit',
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editQuestion(context, i),
                              ),
                              IconButton(
                                tooltip: 'Delete',
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteQuestion(context, i),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Question"),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _createQuiz,
                  icon: const Icon(Icons.check),
                  label: Text(
                      widget.quizData == null ? "Create Quiz" : "Update Quiz"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
