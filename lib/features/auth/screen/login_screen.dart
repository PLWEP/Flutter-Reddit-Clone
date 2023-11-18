import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/constant/constant.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constant.logoPath),
      ),
    );
  }
}
