import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the Instagram authentication application.
/// Implements Contemporary Security Minimalism design with Professional Trust Palette.
class AppTheme {
  AppTheme._();

  // Professional Trust Palette - Color specifications
  static const Color primaryLight = Color(
      0xFF2563EB); // Instagram-inspired blue for trust and primary actions
  static const Color secondaryLight = Color(
      0xFF64748B); // Professional slate for secondary actions and supporting text
  static const Color successLight =
      Color(0xFF059669); // Clean emerald for successful authentication states
  static const Color warningLight =
      Color(0xFFD97706); // Amber for 2FA prompts and attention states
  static const Color errorLight = Color(
      0xFFDC2626); // Clear red for authentication failures and validation errors
  static const Color surfaceLight =
      Color(0xFFFFFFFF); // Pure white for content areas and form backgrounds
  static const Color backgroundLight =
      Color(0xFFF8FAFC); // Subtle off-white for app background
  static const Color borderLight =
      Color(0xFFE2E8F0); // Light gray for subtle element separation
  static const Color textPrimaryLight =
      Color(0xFF0F172A); // Near-black for primary content
  static const Color textSecondaryLight =
      Color(0xFF475569); // Medium gray for supporting text and labels

  // Dark theme variants maintaining the same color relationships
  static const Color primaryDark = Color(0xFF3B82F6);
  static const Color secondaryDark = Color(0xFF94A3B8);
  static const Color successDark = Color(0xFF10B981);
  static const Color warningDark = Color(0xFFF59E0B);
  static const Color errorDark = Color(0xFFEF4444);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color borderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Additional semantic colors
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF0F172A);
  static const Color onBackgroundLight = Color(0xFF0F172A);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFFFFFFFF);
  static const Color onSurfaceDark = Color(0xFFF1F5F9);
  static const Color onBackgroundDark = Color(0xFFF1F5F9);
  static const Color onErrorDark = Color(0xFFFFFFFF);

  // Shadow colors for subtle elevation system (2-4dp shadows with 0.05-0.1 opacity)
  static const Color shadowLight = Color(0x0D000000); // 0.05 opacity
  static const Color shadowMediumLight = Color(0x1A000000); // 0.1 opacity
  static const Color shadowDark = Color(0x0DFFFFFF);
  static const Color shadowMediumDark = Color(0x1AFFFFFF);

  /// Light theme implementing Contemporary Security Minimalism
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: onPrimaryLight,
      primaryContainer: primaryLight.withValues(alpha: 0.1),
      onPrimaryContainer: primaryLight,
      secondary: secondaryLight,
      onSecondary: onSecondaryLight,
      secondaryContainer: secondaryLight.withValues(alpha: 0.1),
      onSecondaryContainer: secondaryLight,
      tertiary: successLight,
      onTertiary: onPrimaryLight,
      tertiaryContainer: successLight.withValues(alpha: 0.1),
      onTertiaryContainer: successLight,
      error: errorLight,
      onError: onErrorLight,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      onSurfaceVariant: textSecondaryLight,
      outline: borderLight,
      outlineVariant: borderLight.withValues(alpha: 0.5),
      shadow: shadowLight,
      scrim: shadowMediumLight,
      inverseSurface: surfaceDark,
      onInverseSurface: onSurfaceDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: borderLight,

    // AppBar theme for clean, professional security aesthetics
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: -0.02,
      ),
      iconTheme: IconThemeData(color: textPrimaryLight, size: 24),
      actionsIconTheme: IconThemeData(color: textPrimaryLight, size: 24),
    ),

    // Card theme with subtle elevation for content separation
    cardTheme: CardTheme(
      color: surfaceLight,
      elevation: 2,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom navigation optimized for mobile authentication flows
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textSecondaryLight,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating action button for primary authentication actions
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: onPrimaryLight,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes optimized for authentication flows
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimaryLight,
        backgroundColor: primaryLight,
        disabledForegroundColor: textSecondaryLight,
        disabledBackgroundColor: borderLight,
        elevation: 2,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(120, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        disabledForegroundColor: textSecondaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(120, 48),
        side: const BorderSide(color: borderLight, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        disabledForegroundColor: textSecondaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(64, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
      ),
    ),

    // Typography using Inter for excellent mobile legibility
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration optimized for authentication forms
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderLight, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorLight, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorLight, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: borderLight.withValues(alpha: 0.5), width: 1),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondaryLight.withValues(alpha: 0.7),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      helperStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch theme for settings and preferences
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return borderLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withValues(alpha: 0.3);
        }
        return borderLight.withValues(alpha: 0.5);
      }),
    ),

    // Checkbox theme for form elements
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryLight),
      side: const BorderSide(color: borderLight, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),

    // Radio theme for selection options
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return borderLight;
      }),
    ),

    // Progress indicators for loading states
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryLight,
      linearTrackColor: borderLight,
      circularTrackColor: borderLight,
    ),

    // Slider theme for settings
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryLight,
      thumbColor: primaryLight,
      overlayColor: primaryLight.withValues(alpha: 0.2),
      inactiveTrackColor: borderLight,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    ),

    // Tab bar theme for navigation
    tabBarTheme: TabBarTheme(
      labelColor: primaryLight,
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: primaryLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip theme for help text
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryLight.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Snackbar theme for notifications
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryLight,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
    ),

    // Dialog theme for modals and alerts
    dialogTheme: DialogTheme(
      backgroundColor: surfaceLight,
      elevation: 8,
      shadowColor: shadowMediumLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
      ),
    ),

    // Bottom sheet theme for contextual actions
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceLight,
      elevation: 8,
      shadowColor: shadowMediumLight,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    ),
  );

  /// Dark theme maintaining the same design principles
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: onPrimaryDark,
      primaryContainer: primaryDark.withValues(alpha: 0.2),
      onPrimaryContainer: primaryDark,
      secondary: secondaryDark,
      onSecondary: onSecondaryDark,
      secondaryContainer: secondaryDark.withValues(alpha: 0.2),
      onSecondaryContainer: secondaryDark,
      tertiary: successDark,
      onTertiary: onPrimaryDark,
      tertiaryContainer: successDark.withValues(alpha: 0.2),
      onTertiaryContainer: successDark,
      error: errorDark,
      onError: onErrorDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: borderDark.withValues(alpha: 0.5),
      shadow: shadowDark,
      scrim: shadowMediumDark,
      inverseSurface: surfaceLight,
      onInverseSurface: onSurfaceLight,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: surfaceDark,
    dividerColor: borderDark,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: -0.02,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark, size: 24),
      actionsIconTheme: IconThemeData(color: textPrimaryDark, size: 24),
    ),
    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 2,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textSecondaryDark,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: onPrimaryDark,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimaryDark,
        backgroundColor: primaryDark,
        disabledForegroundColor: textSecondaryDark,
        disabledBackgroundColor: borderDark,
        elevation: 2,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(120, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryDark,
        disabledForegroundColor: textSecondaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(120, 48),
        side: const BorderSide(color: borderDark, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        disabledForegroundColor: textSecondaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(64, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderDark, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderDark, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorDark, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorDark, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: borderDark.withValues(alpha: 0.5), width: 1),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondaryDark.withValues(alpha: 0.7),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      helperStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return borderDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withValues(alpha: 0.3);
        }
        return borderDark.withValues(alpha: 0.5);
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryDark),
      side: const BorderSide(color: borderDark, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return borderDark;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryDark,
      linearTrackColor: borderDark,
      circularTrackColor: borderDark,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryDark,
      thumbColor: primaryDark,
      overlayColor: primaryDark.withValues(alpha: 0.2),
      inactiveTrackColor: borderDark,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryDark,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: primaryDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryDark,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: surfaceDark,
      elevation: 8,
      shadowColor: shadowMediumDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceDark,
      elevation: 8,
      shadowColor: shadowMediumDark,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    ),
  );

  /// Helper method to build text theme using Inter font family
  /// Implements typography standards for headings, body text, captions, and data
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary =
        isLight ? textSecondaryLight : textSecondaryDark;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles for component headers
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles for UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Helper method to get monospace text style for technical data
  /// Uses JetBrains Mono for session IDs and technical information
  static TextStyle getMonospaceStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final Color textColor = isLight ? textPrimaryLight : textPrimaryDark;

    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0,
      height: 1.4,
    );
  }

  /// Helper method to get success text style
  static TextStyle getSuccessStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    final Color successColor = isLight ? successLight : successDark;

    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: successColor,
      letterSpacing: 0.1,
      height: 1.4,
    );
  }

  /// Helper method to get warning text style
  static TextStyle getWarningStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    final Color warningColor = isLight ? warningLight : warningDark;

    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: warningColor,
      letterSpacing: 0.1,
      height: 1.4,
    );
  }

  /// Helper method to get error text style
  static TextStyle getErrorStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    final Color errorColor = isLight ? errorLight : errorDark;

    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: errorColor,
      letterSpacing: 0.1,
      height: 1.4,
    );
  }
}
