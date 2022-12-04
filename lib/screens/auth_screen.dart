import 'package:cineme/widgets/auth_form.dart';
import 'package:cineme/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF22264C),
      body: SingleChildScrollView(
        child: Column(
          children: const [TopBar(), AuthForm()],
        ),
      ),
    );
  }
}
