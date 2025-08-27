import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traders_quiz/constants.dart';
import 'package:traders_quiz/models/quiz_model.dart';
import 'package:traders_quiz/screens/create_quiz_screen.dart';
import 'package:traders_quiz/screens/play_quiz_screen.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage({super.key});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  Future<void> _loadQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    final data = prefs.getString("quiz_data");

    if (data != null) {
      List<dynamic> rawData = jsonDecode(data);
      ConstQuiz.quizzes = rawData
          .map((item) => QuizData.fromJson(item as Map<String, dynamic>))
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
      ),
      body: ListView.separated(
        itemCount: ConstQuiz.quizzes.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(ConstQuiz.quizzes[index].title),
            subtitle: Text(ConstQuiz.quizzes[index].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editQuiz(context, index),
                ),
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteQuiz(context, index),
                ),
              ],
            ),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PlayQuizPage(quizData: ConstQuiz.quizzes[index])))
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addQuiz,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  Future<void> _saveQuiz() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("quiz_data", jsonEncode(ConstQuiz.quizzes));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quiz Saved Locally ✅")),
    );
  }

  Future<void> _addQuiz() async {
    final result = await Navigator.push<QuizData>(
      context,
      MaterialPageRoute(
          builder: (_) => const CreateQuizPage(quizIndex: -1, quizData: null)),
    );

    if (result != null) {
      setState(() => ConstQuiz.quizzes.add(result));
    }
  }

  Future<void> _editQuiz(BuildContext context, int index) async {
    final result = await Navigator.push<QuizData>(
      context,
      MaterialPageRoute(
          builder: (_) => CreateQuizPage(
              quizIndex: index, quizData: ConstQuiz.quizzes[index])),
    );
    if (result != null) {
      setState(() => ConstQuiz.quizzes[index] = result);
    }
  }

  Future<void> _deleteQuiz(BuildContext context, int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: Text(
            'Are you sure you want to delete "${ConstQuiz.quizzes[index]}"?'),
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
      setState(() => ConstQuiz.quizzes.removeAt(index));
      _saveQuiz();
    }
  }

  Future<String?> _showTextInputDialog(
    BuildContext context, {
    required String title,
    String? initialValue,
  }) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (val) => Navigator.pop(context, val),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
