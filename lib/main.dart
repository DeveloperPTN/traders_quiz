import 'package:flutter/material.dart';
import 'package:traders_quiz/quizzes.dart';

void main() {
  runApp(MyApp());
}

enum UserRole { Admin, Member, Guest }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Traders Quiz',
      home: RoleSelectionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  UserRole? _selectedRole = UserRole.Admin;
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
                  _buildRadio(UserRole.Admin, 'Admin'),
                  _buildRadio(UserRole.Member, 'Member'),
                  _buildRadio(UserRole.Guest, 'Guest'),
                ],
              ),
              const SizedBox(height: 20),
              // Conditional TextField
              if (_selectedRole == UserRole.Admin ||
                  _selectedRole == UserRole.Member)
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quiz Code',
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
