import 'package:flutter/material.dart';

class GameBannerTheme extends ThemeExtension<GameBannerTheme> {
  final Color bannerBackground;
  final Color timerTextPrimary;
  final Color timerTextSecondary;

  const GameBannerTheme({
    required this.bannerBackground,
    required this.timerTextPrimary,
    required this.timerTextSecondary,
  });

  @override
  GameBannerTheme copyWith({
    Color? bannerBackground,
    Color? timerTextPrimary,
    Color? timerTextSecondary,
  }) {
    return GameBannerTheme(
      bannerBackground: bannerBackground ?? this.bannerBackground,
      timerTextPrimary: timerTextPrimary ?? this.timerTextPrimary,
      timerTextSecondary: timerTextSecondary ?? this.timerTextSecondary,
    );
  }

  @override
  GameBannerTheme lerp(ThemeExtension<GameBannerTheme>? other, double t) {
    if (other is! GameBannerTheme) {
      return this;
    }
    return GameBannerTheme(
      bannerBackground: Color.lerp(bannerBackground, other.bannerBackground, t)!,
      timerTextPrimary: Color.lerp(timerTextPrimary, other.timerTextPrimary, t)!,
      timerTextSecondary: Color.lerp(timerTextSecondary, other.timerTextSecondary, t)!,
    );
  }
}
