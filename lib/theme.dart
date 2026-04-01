import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

class SoftlockColors {
  static const background = Color(0xFF0D1117);
  static const primary = Color(0xFF8B5CF6);
  static const card = Color(0xFF1F2937);
  static const textPrimary = Color(0xFFF9FAFB);
  static const textSecondary = Color(0xFF9CA3AF);
  static const border = Color(0xFF374151);
  static const danger = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
}

class SoftlockBrandColors {
  static const instagram = Colors.purple;
  static const tiktok = Colors.black;
  static const youtube = Colors.red;
  static const facebook = Colors.blue;
  static const twitterX = Colors.black;
  static const snapchat = Colors.yellow;
  static const whatsapp = Colors.green;
  static const linkedin = Colors.blue;
}

@immutable
class SoftlockStatusColors extends ThemeExtension<SoftlockStatusColors> {
  const SoftlockStatusColors({required this.success, required this.warning});
  final Color success;
  final Color warning;

  @override
  SoftlockStatusColors copyWith({Color? success, Color? warning}) =>
      SoftlockStatusColors(
          success: success ?? this.success, warning: warning ?? this.warning);

  @override
  SoftlockStatusColors lerp(
      ThemeExtension<SoftlockStatusColors>? other, double t) {
    if (other is! SoftlockStatusColors) return this;
    return SoftlockStatusColors(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
    );
  }
}

extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

ThemeData get softlockTheme {
  const scheme = ColorScheme.dark(
    primary: SoftlockColors.primary,
    onPrimary: SoftlockColors.textPrimary,
    secondary: SoftlockColors.card,
    onSecondary: SoftlockColors.textPrimary,
    error: SoftlockColors.danger,
    onError: SoftlockColors.textPrimary,
    surface: SoftlockColors.card,
    onSurface: SoftlockColors.textPrimary,
    outline: SoftlockColors.border,
  );

  final textTheme = _buildTextTheme();

  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.sm),
    borderSide: const BorderSide(color: SoftlockColors.border, width: 1),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: SoftlockColors.background,
    cardColor: SoftlockColors.card,
    canvasColor: SoftlockColors.background,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    extensions: const [
      SoftlockStatusColors(
          success: SoftlockColors.success, warning: SoftlockColors.warning)
    ],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: SoftlockColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    iconTheme: const IconThemeData(color: SoftlockColors.textPrimary),
    cardTheme: CardThemeData(
      color: SoftlockColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: SoftlockColors.border, width: 1),
      ),
    ),
    dividerTheme: DividerThemeData(
        color: SoftlockColors.border.withValues(alpha: 0.35), thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: SoftlockColors.card,
      contentTextStyle: textTheme.bodyMedium
          ?.copyWith(color: SoftlockColors.textPrimary),
      actionTextColor: SoftlockColors.primary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
      behavior: SnackBarBehavior.floating,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SoftlockColors.card,
      hintStyle: textTheme.bodyMedium
          ?.copyWith(color: SoftlockColors.textSecondary),
      labelStyle: textTheme.bodyMedium
          ?.copyWith(color: SoftlockColors.textSecondary),
      floatingLabelStyle: textTheme.bodyMedium
          ?.copyWith(color: SoftlockColors.textPrimary),
      border: inputBorder,
      enabledBorder: inputBorder,
      disabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide:
            const BorderSide(color: SoftlockColors.primary, width: 1.5),
      ),
      errorBorder: inputBorder.copyWith(
        borderSide:
            const BorderSide(color: SoftlockColors.danger, width: 1.5),
      ),
      focusedErrorBorder: inputBorder.copyWith(
        borderSide:
            const BorderSide(color: SoftlockColors.danger, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor:
            const WidgetStatePropertyAll(SoftlockColors.primary),
        foregroundColor:
            const WidgetStatePropertyAll(SoftlockColors.textPrimary),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm)),
        ),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? SoftlockColors.textPrimary.withValues(alpha: 0.08)
              : null,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            const WidgetStatePropertyAll(SoftlockColors.textPrimary),
        side: const WidgetStatePropertyAll(
            BorderSide(color: SoftlockColors.border, width: 1)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm)),
        ),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? SoftlockColors.textPrimary.withValues(alpha: 0.06)
              : null,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            const WidgetStatePropertyAll(SoftlockColors.textPrimary),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm)),
        ),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? SoftlockColors.textPrimary.withValues(alpha: 0.06)
              : null,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: SoftlockColors.primary,
      foregroundColor: SoftlockColors.textPrimary,
      elevation: 0,
    ),
  );
}

TextTheme _buildTextTheme() {
  // Using Flutter's built-in font instead of google_fonts
  // The app will use the system default font (Roboto on Android)
  // which looks clean and professional
  const String fontFamily = 'Roboto';

  const base = TextTheme(
    displayLarge: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    displayMedium: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    displaySmall: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    headlineLarge: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    headlineMedium: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    headlineSmall: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    titleLarge: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    titleMedium: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    titleSmall: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    labelLarge: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    labelMedium: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    labelSmall: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    bodyLarge: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    bodyMedium: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textPrimary),
    bodySmall: TextStyle(fontFamily: fontFamily, color: SoftlockColors.textSecondary),
  );

  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontSize: FontSizes.displayLarge, fontWeight: FontWeight.w400, letterSpacing: -0.25),
    displayMedium: base.displayMedium?.copyWith(fontSize: FontSizes.displayMedium, fontWeight: FontWeight.w400),
    displaySmall: base.displaySmall?.copyWith(fontSize: FontSizes.displaySmall, fontWeight: FontWeight.w400),
    headlineLarge: base.headlineLarge?.copyWith(fontSize: FontSizes.headlineLarge, fontWeight: FontWeight.w600, letterSpacing: -0.5),
    headlineMedium: base.headlineMedium?.copyWith(fontSize: FontSizes.headlineMedium, fontWeight: FontWeight.w600),
    headlineSmall: base.headlineSmall?.copyWith(fontSize: FontSizes.headlineSmall, fontWeight: FontWeight.w600),
    titleLarge: base.titleLarge?.copyWith(fontSize: FontSizes.titleLarge, fontWeight: FontWeight.w600),
    titleMedium: base.titleMedium?.copyWith(fontSize: FontSizes.titleMedium, fontWeight: FontWeight.w500),
    titleSmall: base.titleSmall?.copyWith(fontSize: FontSizes.titleSmall, fontWeight: FontWeight.w500),
    labelLarge: base.labelLarge?.copyWith(fontSize: FontSizes.labelLarge, fontWeight: FontWeight.w600, letterSpacing: 0.1),
    labelMedium: base.labelMedium?.copyWith(fontSize: FontSizes.labelMedium, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    labelSmall: base.labelSmall?.copyWith(fontSize: FontSizes.labelSmall, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: FontSizes.bodyLarge, fontWeight: FontWeight.w400, letterSpacing: 0.15, height: 1.5),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: FontSizes.bodyMedium, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1.5),
    bodySmall: base.bodySmall?.copyWith(fontSize: FontSizes.bodySmall, fontWeight: FontWeight.w400, letterSpacing: 0.4, height: 1.5, color: SoftlockColors.textSecondary),
  );
}
