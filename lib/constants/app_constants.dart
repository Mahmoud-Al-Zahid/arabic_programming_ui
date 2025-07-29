import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'تعلم البرمجة بالعربية';
  static const String appVersion = '1.0.0';

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 3);
  static const Curve animationCurve = Curves.easeInOut;

  // Spacing
  static const double defaultPadding = 20.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Border Radius
  static const double defaultBorderRadius = 16.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 24.0;

  // Elevation
  static const double cardElevation = 8.0;
  static const double buttonElevation = 2.0;

  // Mock User Data
  static const String mockUserName = 'أحمد محمد';
  static const int mockUserLevel = 5;
  static const int mockUserXP = 1250;
  static const int mockUserCoins = 850;
  static const int mockCompletedLessons = 23;
  static const int mockAnsweredQuestions = 156;
  static const double mockStudyHours = 12.5;
  static const int mockActiveTracks = 3;
}
