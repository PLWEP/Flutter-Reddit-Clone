import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/features/auth/screen/login_screen.dart';
import 'package:flutter_reddit_clone/theme/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit Clone',
      theme: Pallete.darkModeAppTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
