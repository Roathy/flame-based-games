import 'dart:math';
import 'package:flutter/material.dart';

class ReadableColorFactory {
  final Random _random = Random();

  Color generate(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    final bool isDarkBackground = brightness == Brightness.dark;

    if (isDarkBackground) {
      // Generate a light, vibrant color
      return HSLColor.fromAHSL(
        1.0, // Alpha
        _random.nextDouble() * 360, // Hue (any color)
        _random.nextDouble() * 0.4 + 0.5, // Saturation (50% to 90%)
        _random.nextDouble() * 0.2 + 0.7, // Lightness (70% to 90%)
      ).toColor();
    } else {
      // Generate a dark, saturated color
      return HSLColor.fromAHSL(
        1.0, // Alpha
        _random.nextDouble() * 360, // Hue (any color)
        _random.nextDouble() * 0.5 + 0.5, // Saturation (50% to 100%)
        _random.nextDouble() * 0.4 + 0.1, // Lightness (10% to 50%)
      ).toColor();
    }
  }
}
