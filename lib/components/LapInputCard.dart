import 'package:app_jurados/components/PointsInputField.dart';
import 'package:flutter/material.dart';
import 'package:app_jurados/components/TimeInputField.dart';
import 'package:flutter/services.dart';

class LapInputCard extends StatelessWidget {
  final String title; // Título do Card (ex: "Volta 1")
  final TextEditingController timeController; // Controlador do tempo
  final TextEditingController pointsController; // Controlador dos pontos

  const LapInputCard({
    Key? key,
    required this.title,
    required this.timeController,
    required this.pointsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Campo para adicionar tempo usando TimeInputField
            TimeInputField(
            controller: timeController,
            isEnabled: true,
            showTimerIcon: true,
            showAddIcon: false,
            ),
            Divider(
            color: Colors.white,
            thickness: 1,
            ),
            const SizedBox(height: 10),
            // Campo para entrada dos pontos
            PointsInputField(
            controller: pointsController,
            icon: Icons.score,
            ),
        ],
      ),
    );
  }
}
