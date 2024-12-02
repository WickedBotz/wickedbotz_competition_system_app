import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onAddTime; // Callback opcional para adicionar o tempo
  final bool isEnabled; // Define se o campo está habilitado ou não
  final bool showTimerIcon; // Define se o ícone de cronômetro deve ser exibido
  final bool showAddIcon; // Define se o ícone de adicionar deve ser exibido

  const TimeInputField({
    Key? key,
    required this.controller,
    this.onAddTime,
    this.isEnabled = true,
    this.showTimerIcon = true, // Por padrão, exibe o ícone de cronômetro
    this.showAddIcon = false, // Por padrão, não exibe o ícone de adicionar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializa o valor padrão no construtor, caso esteja vazio
    //controller.text = controller.text.isEmpty ? '00:00' : controller.text;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Campo de input
        Expanded(
          child: TextFormField(
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9:]*$')), // Aceita apenas números e ":"
            ],
            cursorColor: Theme.of(context).colorScheme.secondary,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              icon: showTimerIcon ? const Icon(Icons.timer_outlined) : null, // Exibe o ícone de cronômetro, se ativado
              filled: true,
              fillColor: Colors.grey[800], // Define o fundo cinza para o campo
              hintText: '000:000 (sec:millis)',
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14, // Tamanho da fonte menor para o placeholder
                    color: Theme.of(context).hintColor,
                  ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20.0, // Ajusta a altura do campo
                horizontal: 12.0, // Margem horizontal interna
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onTap: () {
              // Move o cursor para o final do texto ao focar no campo
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              if (!RegExp(r'\d{3}.\d{3}$').hasMatch(value)) {
                return 'Formato inválido (SS:MS)';
              }
              return null;
            },
          ),
        ),
        // Ícone de adicionar tempo (opcional)
        if (showAddIcon)
          IconButton(
            onPressed: isEnabled && onAddTime != null ? onAddTime : null,
            icon: Icon(
              Icons.add,
              color: isEnabled
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).disabledColor,
            ),
          ),
      ],
    );
  }
}
