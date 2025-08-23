import 'package:flutter/material.dart';
import 'package:traders_quiz/models/quiz_model.dart';
import 'package:traders_quiz/screens/create_question_screen.dart';
import 'package:traders_quiz/models/question_model.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final List<Question> _questions = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _addQuestion() async {
    final result = await Navigator.push<Question>(
      context,
      MaterialPageRoute(builder: (_) => const CreateQuestionPage()),
    );

    if (result != null) {
      setState(() => _questions.add(result));
    }
  }

  void _createQuiz() {
    final quiz = QuizData(
        id: 0,
        title: _titleCtrl.text,
        description: _descCtrl.text,
        questions: _questions);

    debugPrint("QUIZ CREATED: ${quiz.toJson()}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quiz Created!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Quiz")),
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
                          subtitle: Text("Type: ${q.questionType}"),
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
                  label: const Text("Create Quiz"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
