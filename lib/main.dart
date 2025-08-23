import 'package:flutter/material.dart';
import 'package:traders_quiz/screens/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Traders Quiz',
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
