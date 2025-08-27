import 'package:flutter/material.dart';
import 'package:traders_quiz/screens/quizzes_screen.dart';

enum UserRole { Guest, Member, Admin }

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  UserRole? _selectedRole = UserRole.Guest;
  final TextEditingController _textController = TextEditingController();

  void _handleSubmit() {
    String input = _textController.text;

    if ((_selectedRole == UserRole.Admin || _selectedRole == UserRole.Member) &&
        input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please Enter Quiz Code')),
      );
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const QuizzesPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _selectedRole = newValue;
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
