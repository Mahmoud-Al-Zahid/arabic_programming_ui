import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash/enhanced_splash_screen.dart';
import 'core/theme/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeType _currentTheme = AppThemeType.ocean; // Default theme

  void _handleThemeChange(AppThemeType newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabic Programming App',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.getTheme(_currentTheme).copyWith(
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const EnhancedSplashScreen(),
    );
  }
}
