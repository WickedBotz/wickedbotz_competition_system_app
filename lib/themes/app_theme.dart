import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData mainTheme = ThemeData(
    textTheme: const TextTheme(
      titleLarge:TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w600),
      titleMedium:TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      labelMedium: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w400),
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
            colors: [Color(0xff000000), Color(0xff06060e), Color(0xff000428)],
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