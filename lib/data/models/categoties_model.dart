import 'package:intl/intl.dart';

class CategoriesModel {
  final int category_id;
  final int category_type;
  final String category_name;
  final String category_description;
  final String category_rules;


  CategoriesModel(
      {required this.category_id,
        required this.category_type,
        required this.category_name,
        required this.category_description,
        required this.category_rules,
      });

  factory CategoriesModel.fromMap(Map<String, dynamic> map) {


    return CategoriesModel(
      category_id: map['id'],
      category_type: map['type'],
      category_name: map['name'],
      category_description: map['description'],
      category_rules: map['ruleslocation'],
    );
  }
}
