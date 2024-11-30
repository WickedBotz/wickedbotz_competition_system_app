import 'package:flutter/material.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../pages/matchs_page.dart';
import '../pages/time_trials_page.dart';

/// Widget que exibe a lista de categorias em um formato compacto com um título.
class CategoryListWidget extends StatelessWidget {
  final List<CategoriesModel> categories;
  final CompetitionsModel competition;

  const CategoryListWidget({
    super.key,
    required this.categories,
    required this.competition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
              'Categorias',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 17.0),
            ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: categories.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade600,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final item = categories[index];
              return CategoryItemWidget(
                item: item,
                competition: competition,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Widget individual de item de categoria.
class CategoryItemWidget extends StatelessWidget {
  final CategoriesModel item;
  final CompetitionsModel competition;

  const CategoryItemWidget({
    super.key,
    required this.item,
    required this.competition,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.category_id == 1 || item.category_id == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimeTrialsPage(
                Competiotion: competition,
                Category: item,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchsPage(
                Category: item,
                Competiotion: competition,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category_name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  item.category_rules,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const GradientText(
              'Visualizar',
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget personalizado para texto com gradiente.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style.copyWith(
          color: Colors.white, // A cor é ignorada por causa do ShaderMask
        ),
      ),
    );
  }
}
