import 'package:flutter/material.dart';
import 'package:app_jurados/components/CancelButton.dart';
import 'package:app_jurados/components/ButtonGradient.dart';
import 'package:app_jurados/themes/app_theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? message; // Mensagem personalizada
  final List<Map<String, dynamic>>? recordedTimes; // Lista opcional de tempos
  final Widget? content; // Conteúdo personalizado
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    Key? key,
    this.message,
    this.recordedTimes,
    this.content,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar'),
      titleTextStyle: Theme.of(context).textTheme.titleSmall,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Exibe uma mensagem personalizada, se fornecida
          if (message != null)
            Text(
              message!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 10),
          // Exibe o conteúdo personalizado, se fornecido
          if (content != null)
            content!
          else if (recordedTimes != null && recordedTimes!.isNotEmpty)
            ...recordedTimes!.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  '${entry['time']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botão "Cancelar"
            SizedBox(
              height: 42,
              width: 120,
              child: CancelButton(
                text: 'Cancelar',
                onPressed: onCancel,
              ),
            ),
            const SizedBox(width: 10),
            // Botão "Confirmar"
            SizedBox(
              height: 42,
              width: 120,
              child: ButtonGradient(
                text: 'Confirmar',
                onPressed: onConfirm,
                gradient: AppTheme.enviarGradient,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
