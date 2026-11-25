import 'package:flutter/material.dart';

/// Theme global aplikasi (Material 3) agar tampilan konsisten.
ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1769aa)),
  scaffoldBackgroundColor: const Color(0xfff4f8fb),
  appBarTheme: const AppBarTheme(centerTitle: true),
  // Typography: hierarki ukuran/ketebalan yang jelas dan mudah dibaca.
  textTheme: const TextTheme(
    displaySmall: TextStyle(fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(height: 1.4),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);
