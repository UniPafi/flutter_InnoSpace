import 'package:flutter/material.dart';
import 'dart:ui' show Color;

class AppTheme {
  static const Color primaryColor = Color(0xFF673AB7); 
  static const Color accentColor = Color(0xFF03A9F4);  
  static const Color lightBackground = Color(0xFFF5F5F5); 
  static const Color darkBackground = Color(0xFF121212);  

  // ==========================================================
  //  Tema Claro 
  // ==========================================================
static ThemeData get lightTheme => ThemeData(
      
        brightness: Brightness.light, 
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light, 
          primary: primaryColor,
          secondary: accentColor,
          surface: lightBackground,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black87,
        ),
        
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
  //  Tema Oscuro 
  // ==========================================================

  static ThemeData get darkTheme => ThemeData(
        
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          primary: primaryColor,
          secondary: accentColor,
          background: darkBackground,
          surface: const Color(0xFF1E1E1E), 
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.white70,
          onSurface: Colors.white70,
        ),
        
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