import 'package:flutter/material.dart';
import 'package:traders_quiz/models/quiz_model.dart';

class ConstQuiz {
  static List<QuizData> quizzes = [];
}

enum UserRole { Guest, Member, Admin }

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF131A25),
    scaffoldBackgroundColor: const Color(0xFF131A25),
    useMaterial3: true, // modern Material You look

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF131A25),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

// Cursor & text selection theme
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.blueAccent, // cursor color
      selectionColor:
          Color(0x553498DB), // highlight color (semi-transparent blue)
      selectionHandleColor: Colors.blueAccent, // handles color
    ),

    // Text
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      bodySmall: TextStyle(fontSize: 12, color: Colors.white60),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: Colors.white70),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: const Color(0xFF1E2735),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(8),
    ),

// ListTile
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.blueAccent, // leading/trailing icon color
      textColor: Colors.white, // title/subtitle text
      //tileColor: Color(0xFF1E2735), // background for tiles
      leadingAndTrailingTextStyle:
          TextStyle(backgroundColor: Colors.white54, color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E2735),
        hintStyle: const TextStyle(color: Colors.white54),
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white38, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      textStyle: const TextStyle(color: Colors.white),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Color(0xFF1E2735)),
      ),
    ),

    // TextFields & Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E2735),
      hintStyle: const TextStyle(color: Colors.white54),
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white38, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blueAccent),
        foregroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blueAccent,
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E2735),
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
    ),

    // Dialogs
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF1E2735),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      contentTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
    ),

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1E2735),
      disabledColor: Colors.grey[700],
      selectedColor: Colors.blueAccent,
      secondarySelectedColor: Colors.blueGrey,
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    // Checkboxes, Radio, Switch
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(Colors.blueAccent),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(Colors.blueAccent),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.blueAccent),
      trackColor: WidgetStateProperty.all(Colors.blueAccent.withOpacity(0.4)),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: Colors.white24,
      thickness: 1,
    ),

    // SnackBar
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF1E2735),
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
