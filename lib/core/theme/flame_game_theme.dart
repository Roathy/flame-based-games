import 'package:flutter/material.dart';

class FlameGameTheme extends ThemeExtension<FlameGameTheme> {
  final Color backgroundColor;
  final TextStyle wordTextStyle;
  final TextStyle uiTextStyle;
  final Color correctColor;
  final Color incorrectColor;
  final Color neutralColor;

  const FlameGameTheme({
    required this.backgroundColor,
    required this.wordTextStyle,
    required this.uiTextStyle,
    required this.correctColor,
    required this.incorrectColor,
    required this.neutralColor,
  });

  @override
  FlameGameTheme copyWith({
    Color? backgroundColor,
    TextStyle? wordTextStyle,
    TextStyle? uiTextStyle,
    Color? correctColor,
    Color? incorrectColor,
    Color? neutralColor,
  }) {
    return FlameGameTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      wordTextStyle: wordTextStyle ?? this.wordTextStyle,
      uiTextStyle: uiTextStyle ?? this.uiTextStyle,
      correctColor: correctColor ?? this.correctColor,
      incorrectColor: incorrectColor ?? this.incorrectColor,
      neutralColor: neutralColor ?? this.neutralColor,
    );
  }

  @override
  FlameGameTheme lerp(
    covariant ThemeExtension<FlameGameTheme>? other,
    double t,
  ) {
    if (other is! FlameGameTheme) {
      return this;
    }
    return FlameGameTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      wordTextStyle: TextStyle.lerp(wordTextStyle, other.wordTextStyle, t)!,
      uiTextStyle: TextStyle.lerp(uiTextStyle, other.uiTextStyle, t)!,
      correctColor: Color.lerp(correctColor, other.correctColor, t)!,
      incorrectColor: Color.lerp(incorrectColor, other.incorrectColor, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
    );
  }

  factory FlameGameTheme.light() {
    return FlameGameTheme(
      backgroundColor: Colors.grey[50]!, // Base color (almost white)
      wordTextStyle: TextStyle(
        color: Colors.black, // Near-Black for maximum contrast
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      uiTextStyle: TextStyle(
        color:
            Colors.black, // UPDATED: Same as wordTextStyle for maximum contrast
        fontSize: 24.0,
      ),
      correctColor: Color(0xFF4CAF50), // Standard Green for correct states
      incorrectColor: Color(0xFFD32F2F), // Deep Red for error states
      neutralColor: Color(
        0xFF3F51B5,
      ), // Deep Indigo/Blue for strong, professional accent
    );
  }

  factory FlameGameTheme.ocean() {
    return FlameGameTheme(
      backgroundColor: Color(0xFF4A4A5E), // Warm taupe-gray (middle tone)
      wordTextStyle: TextStyle(
        color: Color(0xFFF5F0E8), // Warm cream (lighter than navy version)
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      uiTextStyle: TextStyle(
        color: Color(
          0xFFFFFFFF,
        ), // UPDATED: Pure white for maximum contrast (8.63:1)
        fontSize: 24.0,
      ),
      correctColor: Color(0xFF7FD87F), // Brighter lime green for visibility
      incorrectColor: Color(0xFFFF6B6B), // Brighter coral-red
      neutralColor: Color(
        0xFFFFA500,
      ), // Pure vibrant orange (complementary to taupe)
    );
  }

  factory FlameGameTheme.dark() {
    return FlameGameTheme(
      backgroundColor: Color(0xFF1A1A2E), // Base color
      wordTextStyle: TextStyle(
        color: Color(0xFFEAEAEA), // High-contrast, easy on the eyes
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      uiTextStyle: TextStyle(
        color: Color(
          0xFFFFFFFF,
        ), // UPDATED: Pure white for maximum contrast (17.06:1)
        fontSize: 24.0,
      ),
      correctColor: Color(0xFF00FFC0), // Bright Cyan/Mint for correct answers
      incorrectColor: Color(
        0xFFF9A825,
      ), // Bright Gold/Amber for warnings/errors
      neutralColor: Color(
        0xFFE94560,
      ), // Vibrant Pink-Red for CTAs/active states
    );
  }
}
