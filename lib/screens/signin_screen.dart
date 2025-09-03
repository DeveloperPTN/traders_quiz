import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traders_quiz/models/quiz_model.dart';
import 'package:traders_quiz/screens/play_quiz_screen.dart';
import 'package:traders_quiz/screens/quizzes_screen.dart';
import 'package:traders_quiz/constants.dart';
import 'package:traders_quiz/api_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = true;

  Future<void> _loadQuiz() async {
    ConstQuiz.quizzes = await ApiService.getQuizzes();
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  UserRole _selectedRole = UserRole.Guest;
  final TextEditingController _textController = TextEditingController();

  Future<void> _handleSubmit() async {
    String input = _textController.text;

    if (_selectedRole == UserRole.Guest) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizzesPage(userRole: _selectedRole)));
    } else if (_selectedRole == UserRole.Member) {
      if (input.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Enter Quiz Code')),
        );
      } else {
        QuizData quizData;
        try {
          quizData = ConstQuiz.quizzes.lastWhere(
            (quiz) => quiz.code == input,
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayQuizPage(quizData: quizData)));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Quiz Code')),
          );
        }
      }
    } else if (_selectedRole == UserRole.Admin) {
      if (input.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Enter Password')),
        );
      } else {
        final result = await ApiService.login(input); // Login Request to server
        if (result['message'].toString() == 'Success') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizzesPage(userRole: _selectedRole)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'].toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRADERS QUIZ'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Radio Buttons Horizontally
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRadio(UserRole.Guest, 'Guest'),
                  _buildRadio(UserRole.Member, 'Member'),
                  _buildRadio(UserRole.Admin, 'Admin'),
                ],
              ),
              const SizedBox(height: 20),
              // Conditional TextField
              if (_selectedRole == UserRole.Admin ||
                  _selectedRole == UserRole.Member)
                TextField(
                  controller: _textController,
                  obscureText: _selectedRole == UserRole.Admin ? true : false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: _selectedRole == UserRole.Admin
                        ? 'Password'
                        : 'Quiz Code',
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Enter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(UserRole value, String label) {
    return Row(
      children: [
        Radio<UserRole>(
          value: value,
          groupValue: _selectedRole,
          onChanged: (UserRole? newValue) {
            setState(() {
              _selectedRole = newValue!;
              _textController.clear();
            });
          },
        ),
        Text(label),
        const SizedBox(width: 10),
      ],
    );
  }
}
