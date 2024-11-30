import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PointsInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled; // Define se o campo está habilitado ou não
  final IconData icon; // Ícone a ser exibido

  const PointsInputField({
    Key? key,
    required this.controller,
    this.isEnabled = true,
    this.icon = Icons.star_outline, // Ícone padrão que remete a pontos
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Apenas números
            ],
            cursorColor: Theme.of(context).colorScheme.secondary,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              icon: Icon(icon, color: Theme.of(context).iconTheme.color), // Ícone do lado esquerdo
              labelText: 'Pontos',
              labelStyle: Theme.of(context).textTheme.labelMedium,
              filled: true,
              fillColor: Colors.grey[800], // Fundo cinza
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20.0, // Ajusta a altura do campo
                horizontal: 12.0, // Ajusta o espaçamento horizontal
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            enabled: isEnabled, // Ativa ou desativa o campo
          ),
        ),
      ],
    );
  }
}
