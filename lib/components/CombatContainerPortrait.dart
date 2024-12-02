import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CombatContainerPortrait extends StatelessWidget {
  final String robotName;
  final String teamName;
  final TextEditingController controller;
  final Color? borderColor; // Torna a borda opcional
  final VoidCallback onIncrement; // Callback para incremento
  final VoidCallback onDecrement; // Callback para decremento
  final Color? backgroundColor; // Cor de fundo sólida
  final Gradient? backgroundGradient; // Gradiente opcional

  const CombatContainerPortrait({
    Key? key,
    required this.robotName,
    required this.teamName,
    required this.controller,
    this.borderColor,
    required this.onIncrement,
    required this.onDecrement,
    this.backgroundColor,
    this.backgroundGradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Largura da tela

    return Container(
      width: screenWidth * 0.8, // Define largura proporcional à tela
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade800, // Fundo sólido
        gradient: backgroundGradient, // Gradiente opcional
        borderRadius: BorderRadius.circular(12),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: 2,
              )
            : null, // Define a borda apenas se fornecida
      ),
      child: Column(
        children: [
          Text(
            'Robô: $robotName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Equipe: $teamName',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: onDecrement,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Botão quadrado
                  ),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.red,
                ),
                child: const Icon(Icons.remove, color: Colors.white, size: 28),
              ),
              SizedBox(
                width: 80, // Largura do campo
                height: 70, // Altura do campo
                child: Center(
                  child: TextFormField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                      filled: true,
                      fillColor: Colors.grey[850],
                      focusColor: Colors.grey,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onIncrement,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Botão quadrado
                  ),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.green,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
