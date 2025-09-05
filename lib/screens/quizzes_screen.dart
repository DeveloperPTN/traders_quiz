import 'package:flutter/material.dart';
import 'package:traders_quiz/api_service.dart';
import 'package:traders_quiz/constants.dart';
import 'package:traders_quiz/models/quiz_model.dart';
import 'package:traders_quiz/screens/create_quiz_screen.dart';
import 'package:traders_quiz/screens/play_quiz_screen.dart';

class QuizzesPage extends StatefulWidget {
  final UserRole userRole;
  const QuizzesPage({super.key, required this.userRole});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
      ),
      body: ConstQuiz.quizzes.isEmpty
          ? const Center(child: Text("No quiz available"))
          : ListView.separated(
              itemCount: ConstQuiz.quizzes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                    backgroundColor: Colors.blueGrey,
                  ),
                  title: Text(ConstQuiz.quizzes[index].title),
                  subtitle: Text(ConstQuiz.quizzes[index].description),
                  trailing: widget.userRole == UserRole.Admin
                      ? Row(
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
                        )
                      : const SizedBox(
                          width: 10,
                        ),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlayQuizPage(
                                quizData: ConstQuiz.quizzes[index])))
                  },
                );
              },
            ),
      floatingActionButton: widget.userRole == UserRole.Admin
          ? FloatingActionButton.extended(
              onPressed: _addQuiz,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            )
          : const SizedBox(
              width: 10,
            ),
    );
  }

  Future<void> _addQuiz() async {
    final result = await Navigator.push<List<QuizData>>(
      context,
      MaterialPageRoute(
          builder: (_) => const CreateQuizPage(quizIndex: -1, quizData: null)),
    );

    if (result != null) {
      setState(() {});
    }
  }

  Future<void> _editQuiz(BuildContext context, int index) async {
    final result = await Navigator.push<List<QuizData>>(
      context,
      MaterialPageRoute(
          builder: (_) => CreateQuizPage(
              quizIndex: index, quizData: ConstQuiz.quizzes[index])),
    );
    if (result != null) {
      setState(() {});
    }
  }

  Future<void> _deleteQuiz(BuildContext context, int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: Text(
            'Are you sure you want to delete "${ConstQuiz.quizzes[index].title}"?'),
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
      final result = await ApiService.deleteQuiz(ConstQuiz.quizzes[index].id);
      if (result['message'] == 'Success') {
        ConstQuiz.quizzes = await ApiService.getQuizzes();
        setState(() {});
      }
    }
  }
}
