import 'package:flutter/material.dart';

class TruncateText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const TruncateText({
    required this.text,
    this.style,
    Key? key,
  }) : super(key: key);

  @override
  State<TruncateText> createState() => _TruncateTextState();
}

class _TruncateTextState extends State<TruncateText> {
  bool showFullText = false; // Controla se o texto completo será mostrado

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Alterna entre truncado e completo
        setState(() {
          showFullText = !showFullText;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: showFullText
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.text,
                  style: widget.style ?? Theme.of(context).textTheme.bodyLarge,
                  key: const Key('fullText'), // Chave para o AnimatedSwitcher
                ),
              )
            : Text(
                widget.text,
                style: widget.style ?? Theme.of(context).textTheme.bodyLarge,
                maxLines: 1, // Limita a uma linha
                overflow: TextOverflow.ellipsis, // Adiciona reticências
                key: const Key('truncatedText'), // Chave para o AnimatedSwitcher
              ),
      ),
    );
  }
}
