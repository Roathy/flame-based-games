import 'package:flutter/material.dart';

// Define a set of custom colors based on the visual specifications
class AppColors {
  static const Color cardDefaultBackground = Color(0xFFF5F5F5);
  static const Color cardFlipSideBackground = Color(0xFFE0E0E0);
  static const Color cardBorder = Color(0xFFBDBDBD);
  static const Color questionText = Color(0xFF212121);
  static const Color answerText = Color(0xFF424242);
  static const Color supplementaryText = Color(0xFF757575);
  static const Color swipeIndicator = Color(0xFF2196F3); // Blue
  static const Color correctFeedback = Color(0xFF4CAF50); // Green
  static const Color incorrectFeedback = Color(0xFFF44336); // Red
  static const Color timerWarning = Color(0xFFD32F2F); // Darker Red for timer
}

// Define a set of custom text styles based on the visual specifications
class AppTextStyles {
  static const TextStyle questionTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto', // Assuming Roboto is available or default sans-serif
    color: AppColors.questionText,
  );

  static const TextStyle answerTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
    color: AppColors.answerText,
  );

  static const TextStyle supplementaryTextStyle = TextStyle(
    fontSize: 14,
    fontStyle: FontStyle.italic,
    fontFamily: 'Roboto',
    color: AppColors.supplementaryText,
  );

  // Add other common text styles if needed, e.g., for app bar titles, buttons
  static const TextStyle appBarTitleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
    color: AppColors.questionText, // Using a dark tone for app bar title
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: Colors.white, // Assuming white text on elevated buttons
  );
}

// Function to build the application's ThemeData
ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.swipeIndicator, // Use a primary blue
    scaffoldBackgroundColor: Colors.white, // Default background for scaffolds
    fontFamily: 'Roboto', // Set default font family

    // Define ColorScheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.swipeIndicator,
      onPrimary: Colors.white,
      secondary: AppColors.correctFeedback,
      onSecondary: Colors.white,
      error: AppColors.incorrectFeedback,
      onError: Colors.white,
      surface: AppColors.cardDefaultBackground, // Use the card default background for surface
      onSurface: AppColors.questionText, // Use question text color for onSurface
    ),

    // Define AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cardDefaultBackground, // Light neutral background
      foregroundColor: AppColors.questionText, // Dark text color
      elevation: 0, // No shadow for app bar
      titleTextStyle: AppTextStyles.appBarTitleTextStyle,
    ),

    // Define Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      margin: const EdgeInsets.all(0), // Margin will be handled by parent padding
      color: AppColors.cardDefaultBackground,
    ),

    // Define ElevatedButton Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.swipeIndicator, // Blue background
        foregroundColor: Colors.white, // White text
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Slightly rounded buttons
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: AppTextStyles.buttonTextStyle,
      ),
    ),

    // Define Text Theme
    textTheme: const TextTheme(
      headlineMedium: AppTextStyles.questionTextStyle, // For larger headings
      bodyLarge: AppTextStyles.answerTextStyle, // For general body text
      bodySmall: AppTextStyles.supplementaryTextStyle, // For smaller supplementary text
      // You can map other TextTheme properties as needed
    ),

    // Add other theme properties as needed, e.g., inputDecorationTheme, iconTheme
  );
}
