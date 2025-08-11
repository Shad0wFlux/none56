import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the Snake Game application.
/// Implements Contemporary Retro Minimalism with High-Contrast Arcade color scheme.
class AppTheme {
  AppTheme._();

  // High-Contrast Arcade Color Specifications
  static const Color primaryGameBackground =
      Color(0xFF000000); // Pure black background optimizing OLED efficiency
  static const Color snakeBodyColor = Color(
      0xFF00FF00); // Classic bright green ensuring visibility across all displays
  static const Color foodElementColor = Color(
      0xFFFF0000); // High-saturation red creating immediate visual target recognition
  static const Color uiPrimaryColor = Color(
      0xFFFFFFFF); // Clean white for essential text and interface elements
  static const Color successStateColor = Color(
      0xFF00CC00); // Slightly muted green for score increases and positive feedback
  static const Color warningStateColor =
      Color(0xFFFFAA00); // Amber for pause states and non-critical alerts
  static const Color errorStateColor = Color(
      0xFFCC0000); // Deeper red for game over states distinguishing from food elements
  static const Color gridLinesColor = Color(
      0xFF333333); // Subtle dark gray providing spatial reference without interference
  static const Color inactiveUIColor = Color(
      0xFF666666); // Mid-gray for disabled states and secondary information
  static const Color accentHighlightColor =
      Color(0xFF00FFFF); // Cyan for rare special elements and achievements

  // Additional theme colors for comprehensive theming
  static const Color surfaceLight = Color(0xFF111111);
  static const Color surfaceDark = Color(0xFF000000);
  static const Color cardLight = Color(0xFF1A1A1A);
  static const Color cardDark = Color(0xFF0A0A0A);
  static const Color dialogLight = Color(0xFF1E1E1E);
  static const Color dialogDark = Color(0xFF0F0F0F);

  // Shadow colors (minimal as per design specifications)
  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowDark = Color(0x0F000000);

  // Divider colors
  static const Color dividerLight = gridLinesColor;
  static const Color dividerDark = gridLinesColor;

  // Text colors with proper emphasis levels
  static const Color textHighEmphasisLight =
      uiPrimaryColor; // 100% white for maximum contrast
  static const Color textMediumEmphasisLight =
      Color(0xB3FFFFFF); // 70% opacity white
  static const Color textDisabledLight =
      inactiveUIColor; // Mid-gray for disabled states

  static const Color textHighEmphasisDark =
      uiPrimaryColor; // 100% white for maximum contrast
  static const Color textMediumEmphasisDark =
      Color(0xB3FFFFFF); // 70% opacity white
  static const Color textDisabledDark =
      inactiveUIColor; // Mid-gray for disabled states

  /// Light theme (actually dark for gaming optimization)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark, // Using dark brightness for OLED optimization
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: snakeBodyColor,
      onPrimary: primaryGameBackground,
      primaryContainer: successStateColor,
      onPrimaryContainer: primaryGameBackground,
      secondary: accentHighlightColor,
      onSecondary: primaryGameBackground,
      secondaryContainer: warningStateColor,
      onSecondaryContainer: primaryGameBackground,
      tertiary: foodElementColor,
      onTertiary: uiPrimaryColor,
      tertiaryContainer: errorStateColor,
      onTertiaryContainer: uiPrimaryColor,
      error: errorStateColor,
      onError: uiPrimaryColor,
      surface: surfaceLight,
      onSurface: textHighEmphasisLight,
      onSurfaceVariant: textMediumEmphasisLight,
      outline: gridLinesColor,
      outlineVariant: inactiveUIColor,
      shadow: shadowLight,
      scrim: primaryGameBackground,
      inverseSurface: uiPrimaryColor,
      onInverseSurface: primaryGameBackground,
      inversePrimary: primaryGameBackground,
    ),
    scaffoldBackgroundColor: primaryGameBackground,
    cardColor: cardLight,
    dividerColor: dividerLight,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGameBackground,
      foregroundColor: uiPrimaryColor,
      elevation: 0.0, // Minimal elevation as per design
      titleTextStyle: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: uiPrimaryColor,
      ),
      iconTheme: const IconThemeData(
        color: uiPrimaryColor,
        size: 24,
      ),
    ),
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 2.0, // Minimal elevation for floating elements only
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(0.0), // Sharp corners for pixel-art aesthetic
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryGameBackground,
      selectedItemColor: snakeBodyColor,
      unselectedItemColor: inactiveUIColor,
      elevation: 0.0, // No elevation for clean aesthetic
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: foodElementColor,
      foregroundColor: uiPrimaryColor,
      elevation: 2.0, // Minimal elevation as specified
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryGameBackground,
        backgroundColor: snakeBodyColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0.0, // No elevation for clean pixel-art aesthetic
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0), // Sharp corners
        ),
        textStyle: GoogleFonts.orbitron(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: uiPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: uiPrimaryColor, width: 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0), // Sharp corners
        ),
        textStyle: GoogleFonts.orbitron(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentHighlightColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0), // Sharp corners
        ),
        textStyle: GoogleFonts.orbitron(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: true),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      border: const OutlineInputBorder(
        borderRadius:
            BorderRadius.zero, // Sharp corners for pixel-art aesthetic
        borderSide: BorderSide(color: gridLinesColor, width: 1.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: gridLinesColor, width: 1.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: snakeBodyColor, width: 2.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: errorStateColor, width: 1.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: errorStateColor, width: 2.0),
      ),
      labelStyle: GoogleFonts.roboto(color: textMediumEmphasisLight),
      hintStyle: GoogleFonts.roboto(color: textDisabledLight),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return snakeBodyColor;
        }
        return inactiveUIColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return snakeBodyColor.withValues(alpha: 0.3);
        }
        return gridLinesColor;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return snakeBodyColor;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(primaryGameBackground),
      side: const BorderSide(color: gridLinesColor, width: 1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0), // Sharp corners
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return snakeBodyColor;
        }
        return gridLinesColor;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: snakeBodyColor,
      linearTrackColor: gridLinesColor,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: snakeBodyColor,
      thumbColor: snakeBodyColor,
      overlayColor: snakeBodyColor.withValues(alpha: 0.2),
      inactiveTrackColor: gridLinesColor,
      trackHeight: 2.0,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: uiPrimaryColor,
      unselectedLabelColor: inactiveUIColor,
      indicatorColor: snakeBodyColor,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: surfaceLight,
        borderRadius: BorderRadius.circular(0.0), // Sharp corners
        border: Border.all(color: gridLinesColor, width: 1.0),
      ),
      textStyle: GoogleFonts.roboto(
        color: uiPrimaryColor,
        fontSize: 12,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceLight,
      contentTextStyle: GoogleFonts.roboto(
        color: uiPrimaryColor,
        fontSize: 14,
      ),
      actionTextColor: accentHighlightColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0), // Sharp corners
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: dialogLight),
  );

  /// Dark theme (identical to light for consistent gaming experience)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: snakeBodyColor,
      onPrimary: primaryGameBackground,
      primaryContainer: successStateColor,
      onPrimaryContainer: primaryGameBackground,
      secondary: accentHighlightColor,
      onSecondary: primaryGameBackground,
      secondaryContainer: warningStateColor,
      onSecondaryContainer: primaryGameBackground,
      tertiary: foodElementColor,
      onTertiary: uiPrimaryColor,
      tertiaryContainer: errorStateColor,
      onTertiaryContainer: uiPrimaryColor,
      error: errorStateColor,
      onError: uiPrimaryColor,
      surface: surfaceDark,
      onSurface: textHighEmphasisDark,
      onSurfaceVariant: textMediumEmphasisDark,
      outline: gridLinesColor,
      outlineVariant: inactiveUIColor,
      shadow: shadowDark,
      scrim: primaryGameBackground,
      inverseSurface: uiPrimaryColor,
      onInverseSurface: primaryGameBackground,
      inversePrimary: primaryGameBackground,
    ),
    scaffoldBackgroundColor: primaryGameBackground,
    cardColor: cardDark,
    dividerColor: dividerDark,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGameBackground,
      foregroundColor: uiPrimaryColor,
      elevation: 0.0,
      titleTextStyle: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: uiPrimaryColor,
      ),
      iconTheme: const IconThemeData(
        color: uiPrimaryColor,
        size: 24,
      ),
    ),
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryGameBackground,
      selectedItemColor: snakeBodyColor,
      unselectedItemColor: inactiveUIColor,
      elevation: 0.0,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: foodElementColor,
      foregroundColor: uiPrimaryColor,
      elevation: 2.0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryGameBackground,
        backgroundColor: snakeBodyColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        textStyle: GoogleFonts.orbitron(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: uiPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: uiPrimaryColor, width: 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        textStyle: GoogleFonts.orbitron(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentHighlightColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        textStyle: GoogleFonts.orbitron(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: gridLinesColor, width: 1.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: gridLinesColor, width: 1.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: snakeBodyColor, width: 2.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: errorStateColor, width: 1.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: errorStateColor, width: 2.0),
      ),
      labelStyle: GoogleFonts.roboto(color: textMediumEmphasisDark),
      hintStyle: GoogleFonts.roboto(color: textDisabledDark),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return snakeBodyColor;
        }
        return inactiveUIColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return snakeBodyColor.withValues(alpha: 0.3);
        }
        return gridLinesColor;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return snakeBodyColor;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(primaryGameBackground),
      side: const BorderSide(color: gridLinesColor, width: 1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return snakeBodyColor;
        }
        return gridLinesColor;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: snakeBodyColor,
      linearTrackColor: gridLinesColor,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: snakeBodyColor,
      thumbColor: snakeBodyColor,
      overlayColor: snakeBodyColor.withValues(alpha: 0.2),
      inactiveTrackColor: gridLinesColor,
      trackHeight: 2.0,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: uiPrimaryColor,
      unselectedLabelColor: inactiveUIColor,
      indicatorColor: snakeBodyColor,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(color: gridLinesColor, width: 1.0),
      ),
      textStyle: GoogleFonts.roboto(
        color: uiPrimaryColor,
        fontSize: 12,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceDark,
      contentTextStyle: GoogleFonts.roboto(
        color: uiPrimaryColor,
        fontSize: 14,
      ),
      actionTextColor: accentHighlightColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: dialogDark),
  );

  /// Helper method to build text theme based on brightness
  /// Implements typography standards: Orbitron for headings, Roboto for body,
  /// Roboto Mono for captions, JetBrains Mono for data
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles using Orbitron for futuristic aesthetic
      displayLarge: GoogleFonts.orbitron(
        fontSize: 96,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 60,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.orbitron(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
      ),

      // Headline styles using Orbitron for game titles and headers
      headlineLarge: GoogleFonts.orbitron(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      headlineMedium: GoogleFonts.orbitron(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
      ),
      headlineSmall: GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
      ),

      // Title styles using Orbitron for section headers
      titleLarge: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.orbitron(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),

      // Body styles using Roboto for optimal mobile reading
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),

      // Label styles using Roboto Mono for captions and UI labels
      labelLarge: GoogleFonts.robotoMono(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 1.25,
      ),
      labelMedium: GoogleFonts.robotoMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),
      labelSmall: GoogleFonts.robotoMono(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: textDisabled,
        letterSpacing: 1.5,
      ),
    );
  }

  /// Helper method to get JetBrains Mono text style for data display
  /// Used for high scores and statistics with superior number legibility
  static TextStyle getDataTextStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    bool isLight = true,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? (isLight ? textHighEmphasisLight : textHighEmphasisDark),
      letterSpacing: 0.0,
    );
  }
}
