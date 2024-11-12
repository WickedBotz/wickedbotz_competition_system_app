import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData mainTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserrat(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.montserrat(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.montserrat(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
      bodyMedium: GoogleFonts.montserrat(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      labelMedium: GoogleFonts.montserrat(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w400),
    ),
    colorScheme: ColorScheme.dark(
      //primary: const Color(0xFF96d7eb),
     //secondary: const Color(0xFF96d7eb),
      tertiary: Colors.grey[600]!,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      GradientContainerTheme(
        gradientDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(0, 6, 6, 14), Color.fromARGB(0, 0, 4, 40)],
            stops: [0.1, 0.8, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ],
  );
}

class GradientContainerTheme extends ThemeExtension<GradientContainerTheme> {
  final BoxDecoration? gradientDecoration;

  const GradientContainerTheme({this.gradientDecoration});

  @override
  GradientContainerTheme copyWith({BoxDecoration? gradientDecoration}) {
    return GradientContainerTheme(
      gradientDecoration: gradientDecoration ?? this.gradientDecoration,
    );
  }

  @override
  GradientContainerTheme lerp(ThemeExtension<GradientContainerTheme>? other, double t) {
    if (other is! GradientContainerTheme) return this;
    return GradientContainerTheme(
      gradientDecoration: BoxDecoration.lerp(gradientDecoration, other.gradientDecoration, t),
    );
  }
}