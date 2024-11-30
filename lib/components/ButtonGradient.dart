import 'package:app_jurados/themes/app_theme.dart';
import 'package:flutter/material.dart';

class ButtonGradient extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final bool isEnabled;

  const ButtonGradient({
    Key? key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Gradient enabledGradient = gradient ?? AppTheme.enviarGradient;

    final Gradient disabledGradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 24, 93, 98), 
        Color.fromARGB(255, 24, 73, 147)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final Gradient buttonGradient = isEnabled ? enabledGradient : disabledGradient;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: buttonGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
    );
  }
}
