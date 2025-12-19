import 'package:flutter/material.dart';

class AppColors {
  static const crimsonDepth = Color(0xFF710014);
  static const warmSand = Color(0xFFD9BF6F);
  static const softPearl = Color(0xFFF2F1ED);
  static const obsidianBlack = Color(0xFF161616);
  
  static const primary = crimsonDepth;
  static const secondary = warmSand;
  static const background = softPearl;
  static const text = obsidianBlack;
}

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'SF Pro Display',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.text,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.text,
      ),
    ),
  );
}