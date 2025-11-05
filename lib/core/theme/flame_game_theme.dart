
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
  FlameGameTheme lerp(covariant ThemeExtension<FlameGameTheme>? other, double t) {
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

  factory FlameGameTheme.dark() {
    return const FlameGameTheme(
      backgroundColor: Color(0xFF1A1A2E), // Azul oscuro suave
      wordTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      uiTextStyle: TextStyle(
        color: Color(0xFFE0E0E0), // Light grey for UI text
        fontSize: 24.0,
      ),
      correctColor: Color(0xFF50FA7B),
      incorrectColor: Color(0xFFFF5555),
      neutralColor: Color(0xFF8BE9FD),
    );
  }

  factory FlameGameTheme.ocean() {
    return const FlameGameTheme(
      backgroundColor: Color(0xFF16213E), // Azul marino profundo
      wordTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      uiTextStyle: TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 24.0,
      ),
      correctColor: Color(0xFF00FFC6),
      incorrectColor: Color(0xFFF93822),
      neutralColor: Color(0xFFE94560),
    );
  }

  factory FlameGameTheme.light() {
    return FlameGameTheme(
      backgroundColor: Colors.grey[50]!, // Gris muy claro
      wordTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      uiTextStyle: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 24.0,
      ),
      correctColor: const Color(0xFF2E7D32),
      incorrectColor: const Color(0xFFC62828),
      neutralColor: const Color(0xFF1565C0),
    );
  }
}
