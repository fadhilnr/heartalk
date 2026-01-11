import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'providers/compatibility_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase init untuk Android (tanpa firebase_options.dart)
  await Firebase.initializeApp();
  
  runApp(const HeartalkApp());
}

class HeartalkApp extends StatelessWidget {
  const HeartalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CompatibilityProvider()..loadResults(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Heartalk',
        theme: AppTheme.theme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}