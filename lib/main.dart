import 'package:flutter/material.dart';
import 'package:traders_quiz/screens/signin_screen.dart';
import 'package:traders_quiz/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traders Quiz',
      home: const SignInPage(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
    );
  }
}
