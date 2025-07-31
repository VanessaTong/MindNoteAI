import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(TherapyApp());
}

class TherapyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Therapy Notes',
      theme: ThemeData(
        primaryColor: Color(0xFF2F80ED),
        appBarTheme:
            AppBarTheme(backgroundColor: Color(0xFF2F80ED), elevation: 0),
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5FA8D3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
