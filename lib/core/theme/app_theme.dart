import 'package:flame_based_games/core/theme/game_banner_theme.dart';
import 'package:flutter/material.dart';
import 'package:flame_based_games/core/theme/flame_game_theme.dart';

// Define a set of custom colors based on the design system manual
class AppColors {
  // Primary Colors
  static const Color trustBlue = Color(0xFF1976D2);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);

  // Secondary Colors
  static const Color premiumPurple = Color(0xFF9C27B0);

  // Neutral Gray Palette
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textPrimary = Color(0xFF424242);
  static const Color textHighEmphasis = Color(0xFF212121);
}

// Define a set of custom text styles based on the design system manual
class AppTextStyles {
  // Mobile-Optimized Sizes
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500, // Medium
    fontFamily: 'Roboto',
    color: AppColors.textHighEmphasis,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500, // Medium
    fontFamily: 'Roboto',
    color: AppColors.textHighEmphasis,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    fontFamily: 'Roboto',
    color: AppColors.textHighEmphasis,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular
    fontFamily: 'Roboto',
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    fontFamily: 'Roboto',
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    fontFamily: 'Roboto',
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    fontFamily: 'Roboto',
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500, // Medium
    fontFamily: 'Roboto',
    color: AppColors.textSecondary,
  );

  // Button Text Style
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    fontFamily: 'Roboto',
    color: Colors.white,
  );
}

// Function to build the application's ThemeData
ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.trustBlue,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Roboto',

    // Define ColorScheme
    colorScheme: ColorScheme.light(
      primary: AppColors.trustBlue,
      onPrimary: Colors.white,
      secondary: AppColors.successGreen,
      onSecondary: Colors.white,
      error: AppColors.errorRed,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textHighEmphasis,
    ),

    // Define AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textHighEmphasis,
      elevation: 0,
      titleTextStyle: AppTextStyles.headlineMedium.copyWith(color: AppColors.textHighEmphasis),
    ),

    // Define Card Theme
    cardTheme: CardThemeData(
      elevation: 2, // 2dp shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(0),
      color: AppColors.surface, // #F5F5F5
    ),

    // Define ElevatedButton Theme (Primary Buttons)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.trustBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: AppTextStyles.buttonTextStyle,
        elevation: 2, // Subtle drop shadow
        shadowColor: Colors.black.withAlpha((255 * 0.1).round()), // 10% opacity shadow
      ),
    ),

    // Define Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headlineLarge,
      displayMedium: AppTextStyles.headlineMedium,
      displaySmall: AppTextStyles.headlineSmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.buttonTextStyle, // Buttons use labelLarge by default
      labelMedium: AppTextStyles.label,
      labelSmall: AppTextStyles.caption,
      titleLarge: AppTextStyles.headlineSmall, // For AppBar title
      titleMedium: AppTextStyles.bodyLarge,
      titleSmall: AppTextStyles.bodyMedium,
    ),

    // Add other theme properties as needed, e.g., inputDecorationTheme, iconTheme
  ).copyWith(extensions: <ThemeExtension<dynamic>>[
    FlameGameTheme.dark(),
    const GameBannerTheme(
      bannerBackground: Color.fromARGB(204, 25, 25, 25),
      timerTextPrimary: Color(0xFFF5F5F5),
      timerTextSecondary: Color(0xFFE8E8E8),
    ),
  ]);
}