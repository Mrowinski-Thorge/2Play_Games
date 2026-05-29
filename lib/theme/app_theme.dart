import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color darkBg = Color(0xFF0F0B1E);
  static const Color darkCard = Color(0xFF1B1437);
  static const Color lightBg = Color(0xFFF7F8FC);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF8A2387), // Violet
    Color(0xFFE94057), // Sunset Pink
    Color(0xFFF27121), // Amber
  ];

  static const List<Color> neonBlueGradient = [
    Color(0xFF00F2FE), // Cyan
    Color(0xFF4FACFE), // Blue
  ];

  static const List<Color> neonPurpleGradient = [
    Color(0xFFB92B27), // Dark red/purple
    Color(0xFF1565C0), // Deep blue
  ];

  static const List<Color> liquidGlassDarkGradient = [
    Color(0x33FFFFFF),
    Color(0x0AFFFFFF),
  ];

  static const List<Color> liquidGlassLightGradient = [
    Color(0x80FFFFFF),
    Color(0x1AFFFFFF),
  ];

  // Neon Accent Colors
  static const Color accentNeonCyan = Color(0xFF00E5FF);
  static const Color accentNeonPink = Color(0xFFFF007F);
  static const Color accentNeonGreen = Color(0xFF39FF14);
  static const Color accentNeonYellow = Color(0xFFFFEA00);

  // Box Shadows
  static List<BoxShadow> neonGlow(Color color) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: 16,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: color.withOpacity(0.2),
        blurRadius: 32,
        spreadRadius: 4,
      ),
    ];
  }

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  // Light Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF8A2387),
      scaffoldBackgroundColor: lightBg,
      cardColor: lightCard,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        titleLarge: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E1E2C),
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          color: const Color(0xFF4A4A68),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8A2387),
        secondary: Color(0xFF4FACFE),
        surface: lightCard,
        error: Color(0xFFD32F2F),
      ),
    );
  }

  // Dark Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF8A2387),
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        titleLarge: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          color: const Color(0xFFC5C2E7),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF8A2387),
        secondary: Color(0xFF00F2FE),
        surface: darkCard,
        error: Color(0xFFEF5350),
      ),
    );
  }
}

// Glassmorphic Container Decorator
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final Border? border;
  final List<Color>? gradientColors;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.borderRadius = 24.0,
    this.border,
    this.gradientColors,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultGradient = isDark 
        ? AppTheme.liquidGlassDarkGradient 
        : AppTheme.liquidGlassLightGradient;
    
    final finalBorder = border ?? Border.all(
      color: isDark 
          ? Colors.white.withOpacity(0.12) 
          : Colors.white.withOpacity(0.4),
      width: 1.5,
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isDark 
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            border: finalBorder,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors ?? defaultGradient,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
