import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traders_quiz/models/question_model.dart';

class CreateQuestionPage extends StatefulWidget {
  const CreateQuestionPage({super.key});

  @override
  State<CreateQuestionPage> createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _pointsController = TextEditingController();
  File? _imageFile;
  String _selectedType = "Single Select"; // default
  final List<Map<String, dynamic>> _answers = [];

  @override
  void initState() {
    super.initState();
    _addAnswerField(); // start with 1 answer row
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    const pickedFile = null;
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _addAnswerField() {
    setState(() {
      _answers.add({
        "answer": TextEditingController(),
        "points": TextEditingController(),
        "correct": false,
      });
    });
  }

  void _removeAnswerField(int index) {
    setState(() {
      _answers.removeAt(index);
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Collect data
      final question = _questionController.text;
      final points = int.tryParse(_pointsController.text) ?? 0;
      final List<Option> answers = [];
      int id = 1;
      for (var val in _answers) {
        answers.add(Option(
            optionId: id,
            optionText: val["answer"]!.text,
            optionPoints: int.tryParse(val["points"]!.text) ?? 0,
            optionCorrect: val["correct"] ?? false));
        id++;
      }

      final data = Question(
          questionId: 0,
          questionText: question,
          questionImagePath: _imageFile != null ? _imageFile!.path : "",
          questionType: _selectedType,
          points: points,
          options: answers);

      // TODO: Save or send this data
      debugPrint("Quiz Data: ${data.toJson()}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Question Created!")),
      );

      Navigator.pop(
        context,
        data,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Quiz Question")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Question Input
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: "Question"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter question" : null,
              ),
              const SizedBox(height: 12),

              // Points Input
              TextFormField(
                controller: _pointsController,
                decoration: const InputDecoration(labelText: "Points"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Image Upload
              Row(
                children: [
                  _imageFile != null
                      ? Image.file(_imageFile!, width: 80, height: 80)
                      : const Icon(Icons.image, size: 80),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Upload Image"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dropdown for Question Type
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: "Question Type"),
                items: const [
                  DropdownMenuItem(
                      value: "Single Select", child: Text("Single Select")),
                  DropdownMenuItem(
                      value: "Multiple Choice", child: Text("Multiple Choice")),
                  DropdownMenuItem(
                      value: "Paragraph", child: Text("Paragraph")),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedType = val!;
                    _answers.clear();
                    if (_selectedType != "Paragraph") {
                      _addAnswerField();
                    }
                  });
                },
              ),
              const SizedBox(height: 20),

              // Dynamic Answer List
              if (_selectedType == "Single Select" ||
                  _selectedType == "Multiple Choice") ...[
                ..._answers.asMap().entries.map(
                  (entry) {
                    int index = entry.key;
                    var map = entry.value;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: map["answer"],
                              decoration: const InputDecoration(
                                labelText: "Answer",
                              ),
                              validator: (val) => val == null || val.isEmpty
                                  ? "Enter answer"
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: map["points"],
                              decoration: const InputDecoration(
                                labelText: "Pts",
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 80,
                            child: Checkbox(
                              value: map["correct"],
                              onChanged: (val) {
                                setState(() {
                                  map["correct"] = val!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeAnswerField(index),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addAnswerField,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Answer"),
                  ),
                ),
              ],

              // Paragraph points input
              if (_selectedType == "Paragraph") ...[
                const SizedBox(height: 10),
                const Text("Points for paragraph answer:"),
                TextFormField(
                  controller: _pointsController,
                  decoration: const InputDecoration(
                    labelText: "Points",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text("Create Question"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
