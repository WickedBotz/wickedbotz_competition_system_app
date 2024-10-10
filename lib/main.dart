import 'package:app_jurados/pages/login_page.dart';
import 'package:app_jurados/themes/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.mainTheme,
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}