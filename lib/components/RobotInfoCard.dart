import 'package:flutter/material.dart';
import 'package:app_jurados/components/TruncateText.dart';

class RobotInfoCard extends StatelessWidget {
  final String robotName;
  final String imageUrl;
  final double width;
  final double height;

  const RobotInfoCard({
    Key? key,
    required this.robotName,
    required this.imageUrl,
    this.width = 270,
    this.height = 170,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Largura do card
      height: height, // Altura do card
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nome do robô com reticências
          TruncateText(
            text: 'Robô: $robotName',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 10), // Espaço entre texto e imagem
          // Imagem circular
          Container(
            height: 80.0, // Tamanho fixo para a imagem
            width: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
