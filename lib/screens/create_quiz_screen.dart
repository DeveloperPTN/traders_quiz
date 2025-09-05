import 'package:flutter/material.dart';
import 'package:traders_quiz/api_service.dart';
import 'package:traders_quiz/constants.dart';
import 'package:traders_quiz/models/quiz_model.dart';
import 'package:traders_quiz/screens/create_question_screen.dart';
import 'package:traders_quiz/models/question_model.dart';

class CreateQuizPage extends StatefulWidget {
  final int quizIndex;
  final QuizData? quizData;
  const CreateQuizPage({super.key, required this.quizIndex, this.quizData});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _codeCtrl = TextEditingController();
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
      _codeCtrl.text = widget.quizData!.code;
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

  Future<void> _createQuiz() async {
    final quiz = QuizData(
        id: 0,
        code: _codeCtrl.text,
        title: _titleCtrl.text,
        description: _descCtrl.text,
        questions: _questions);

    final result = await ApiService.createQuiz(quiz);

    if (result['message'] == 'Success') {
      ConstQuiz.quizzes = await ApiService.getQuizzes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Quiz Created")),
      );
      Navigator.pop(
        context,
        ConstQuiz.quizzes,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'])),
      );
    }
  }

  Future<void> _updateQuiz() async {
    final quiz = QuizData(
        id: widget.quizData!.id,
        code: _codeCtrl.text,
        title: _titleCtrl.text,
        description: _descCtrl.text,
        questions: _questions);

    final result = await ApiService.updateQuiz(quiz);

    if (result['message'] == 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Quiz Updated")),
      );
      Navigator.pop(
        context,
        ConstQuiz.quizzes,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'])),
      );
    }
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
              controller: _codeCtrl,
              decoration: const InputDecoration(labelText: "Quiz Code"),
            ),
            const SizedBox(height: 8),
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
                          leading: CircleAvatar(
                            child: Text("${i + 1}"),
                            backgroundColor: Colors.blueGrey,
                          ),
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
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        ElevatedButton.icon(
          onPressed: _addQuestion,
          icon: const Icon(Icons.add),
          label: const Text("Add Question"),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: widget.quizData == null ? _createQuiz : _updateQuiz,
          icon: const Icon(Icons.check),
          label: Text(widget.quizData == null ? "Create Quiz" : "Update Quiz"),
        ),
      ],
    );
  }
}
