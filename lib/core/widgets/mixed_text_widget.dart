import 'package:flutter/material.dart';
import 'dart:math' as math;

class MixedTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? arabicStyle;
  final TextStyle? englishStyle;
  final TextStyle? codeStyle;

  const MixedTextWidget({
    super.key,
    required this.text,
    this.arabicStyle,
    this.englishStyle,
    this.codeStyle,
  });

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    final RegExp codeRegex = RegExp(r'`([^`]+)`'); // Matches text within single backticks
    final RegExp englishRegex = RegExp(r'[a-zA-Z0-9_\-\.]+'); // Matches English words, numbers, and some symbols

    int currentIndex = 0;

    while (currentIndex < text.length) {
      bool matched = false;

      // Try to match code blocks first
      final codeMatch = codeRegex.firstMatch(text.substring(currentIndex));
      if (codeMatch != null && codeMatch.start == 0) {
        // Add preceding Arabic text if any
        if (codeMatch.start > 0) {
          textSpans.add(TextSpan(
            text: text.substring(currentIndex, currentIndex + codeMatch.start),
            style: arabicStyle ?? Theme.of(context).textTheme.bodyLarge,
          ));
        }
        textSpans.add(TextSpan(
          text: codeMatch.group(1), // The content inside the backticks
          style: codeStyle ?? Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontFamily: 'monospace',
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
          ),
        ));
        currentIndex += codeMatch.end;
        matched = true;
      }

      if (!matched) {
        // Try to match English text
        final englishMatch = englishRegex.firstMatch(text.substring(currentIndex));
        if (englishMatch != null && englishMatch.start == 0) {
          textSpans.add(TextSpan(
            text: englishMatch.group(0),
            style: englishStyle ?? Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ));
          currentIndex += englishMatch.end;
          matched = true;
        }
      }

      if (!matched) {
        // Default to Arabic text for the next character
        int nextSpecialCharIndex = text.length;
        final nextCodeMatch = codeRegex.firstMatch(text.substring(currentIndex));
        if (nextCodeMatch != null) {
          nextSpecialCharIndex = math.min(nextSpecialCharIndex, currentIndex + nextCodeMatch.start);
        }
        final nextEnglishMatch = englishRegex.firstMatch(text.substring(currentIndex));
        if (nextEnglishMatch != null) {
          nextSpecialCharIndex = math.min(nextSpecialCharIndex, currentIndex + nextEnglishMatch.start);
        }

        if (nextSpecialCharIndex == currentIndex) {
          // No special characters found, just add the current character as Arabic
          textSpans.add(TextSpan(
            text: text[currentIndex],
            style: arabicStyle ?? Theme.of(context).textTheme.bodyLarge,
          ));
          currentIndex++;
        } else {
          // Add the Arabic segment until the next special character
          textSpans.add(TextSpan(
            text: text.substring(currentIndex, nextSpecialCharIndex),
            style: arabicStyle ?? Theme.of(context).textTheme.bodyLarge,
          ));
          currentIndex = nextSpecialCharIndex;
        }
      }
    }

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(children: textSpans),
    );
  }
}
