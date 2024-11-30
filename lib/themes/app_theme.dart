import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData mainTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserrat(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.montserrat(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.montserrat(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      bodyLarge: GoogleFonts.montserrat(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
      bodyMedium: GoogleFonts.montserrat(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.montserrat(color: Colors.white54, fontSize: 15, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.montserrat(color: Colors.white70, fontSize: 25, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.montserrat(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w400),
      displayLarge: GoogleFonts.montserrat(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
      displayMedium: GoogleFonts.montserrat(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      displaySmall: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
    ),
    colorScheme: ColorScheme.dark(
      tertiary: Colors.grey[600]!,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      GradientContainerTheme(
        gradientDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff53dae3), Color(0xff297fff)], // Seu gradiente principal
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ],
  );

  // Gradiente para "enviar"
  static LinearGradient get enviarGradient {
    return const LinearGradient(
      colors: [Color(0xff53dae3), Color(0xff297fff)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Cor para "cancelar" - Vermelho
  static Color get cancelarBorda {
    return Colors.red; // Borda vermelha
  }

  // Cor para fundo cinza estranho
  static Color get cancelarFundo {
    return Colors.grey.shade800; // Fundo cinza
  }
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
