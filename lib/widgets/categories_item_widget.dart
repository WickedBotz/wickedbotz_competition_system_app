import 'package:flutter/material.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../pages/matchs_page.dart';
import '../pages/time_trials_page.dart';

/// Widget that displays the list of categories in a compact format with a title.
class CategoryListWidget extends StatelessWidget {
  final List<CategoriesModel> categories;
  final CompetitionsModel competition;

  const CategoryListWidget({
    Key? key,
    required this.categories,
    required this.competition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title 'Categorias'
          Text(
            'Categorias',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0), // Reduced spacing between title and items
          // List of category items displayed as a compact list
          SingleChildScrollView(
            child: Column(
              children: categories.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced padding between items
                  child: CategoryItemWidget(
                    context: context,
                    item: item,
                    competition: competition,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual category item widget.
Widget CategoryItemWidget({
  required BuildContext context,
  required CategoriesModel item,
  required CompetitionsModel competition,
}) {
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
      color: Colors.grey.shade800, // Grey background color
      child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            item.category_name,
            style: const TextStyle(
            fontSize: 18,
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
        ElevatedButton(
          onPressed: () {
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
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          ),
          child: GradientText(
          'Visualizar',
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          ),
        ),
        ],
      ),
      ),
    ),
  );
}

/// Custom widget for gradient text.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    Key? key,
    required this.gradient,
    required this.style,
  }) : super(key: key);

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
          color: Colors.white, // This color is ignored because of ShaderMask
        ),
      ),
    );
  }
}
