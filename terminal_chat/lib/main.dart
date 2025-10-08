import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TerminalChatApp());
}

class TerminalChatApp extends StatelessWidget {
  const TerminalChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terminal Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
