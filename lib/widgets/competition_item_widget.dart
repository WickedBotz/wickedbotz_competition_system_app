import 'package:flutter/material.dart';
import '../data/models/competitions_model.dart';
import '../pages/competition_categories_page.dart';

Widget CompetitionItemWidget({
  required BuildContext context,
  required CompetitionsModel item,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompetitionCategoriesPage(
            competiotion_item: item,
          ),
        ),
      );
    },
    child: Center(
      child: FractionallySizedBox(
        widthFactor: 0.8, // Faz o container ocupar 80% da largura do elemento pai
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade600),
            color: const Color.fromARGB(255, 54, 54, 54),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mantemos a imagem dentro do ClipRRect
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
                  width: double.infinity, // Ocupa toda a largura disponível
                  height: 300, // Defina a altura que preferir
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8), // Espaçamento entre a imagem e o texto
              Padding(
                padding: const EdgeInsets.all(8.0), // Espaçamento interno para o texto
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.comp_name,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.comp_adress_id.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.comp_date,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
