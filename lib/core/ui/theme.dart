import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  // Colores Base
  static const Color primaryColor = Color(0xFF673AB7); // Morado Profundo (Deep Purple)
  static const Color accentColor = Color(0xFF03A9F4);  // Celeste Vívido (Light Blue)
  static const Color lightBackground = Color(0xFFF5F5F5); // Gris Claro para fondo
  static const Color darkBackground = Color(0xFF121212);  // Gris Muy Oscuro para fondo

  // ==========================================================
  // 1. Tema Claro (Light Theme)
  // ==========================================================
static ThemeData get lightTheme => ThemeData(
        // 1. Especificar el brillo del tema
        brightness: Brightness.light, 
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          // 2. ¡CRUCIAL! Pasar el brillo al ColorScheme.fromSeed
          seedColor: primaryColor,
          brightness: Brightness.light, // <-- CORRECCIÓN APLICADA
          primary: primaryColor,
          secondary: accentColor,
          background: lightBackground,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black87,
        ),
        // ... (resto del tema se mantiene)
        scaffoldBackgroundColor: lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      );

  // ==========================================================
  // 2. Tema Oscuro (Dark Theme)
  // ==========================================================

  static ThemeData get darkTheme => ThemeData(
        // 1. Especificar el brillo del tema
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          // 2. ¡CRUCIAL! Pasar el brillo al ColorScheme.fromSeed
          seedColor: primaryColor,
          brightness: Brightness.dark, // <-- CORRECCIÓN APLICADA
          primary: primaryColor,
          secondary: accentColor,
          background: darkBackground,
          surface: const Color(0xFF1E1E1E), 
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.white70,
          onSurface: Colors.white,
        ),
        // ... (resto del tema se mantiene)
        scaffoldBackgroundColor: darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      );
}