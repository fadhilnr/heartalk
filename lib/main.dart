import 'package:flutter/material.dart';
import 'config/router.dart';
import 'config/theme.dart';

void main() {
  runApp(const HeartalkApp());
}

class HeartalkApp extends StatelessWidget {
  const HeartalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Heartalk',
      theme: AppTheme.theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}