import 'package:flutter/material.dart';
import '../themes/app_theme.dart'; // Certifique-se de importar o AppTheme

class CancelButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const CancelButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a cor do fundo e da borda com base no estado (habilitado ou desabilitado)
    final Color backgroundColor = isEnabled ? AppTheme.cancelarFundo : Colors.grey[700]!;
    final Color borderColor = isEnabled ? AppTheme.cancelarBorda : Colors.grey[600]!;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isEnabled ? Colors.white : Colors.grey[500],
                ),
          ),
        ),
      ),
    );
  }
}
