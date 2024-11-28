import 'dart:convert';
import 'package:app_jurados/data/http/http_client.dart';
import '../http/exceptions.dart';
import '../models/categoties_model.dart';

abstract class ICompetitionCategoriesRepository{
  Future<List<CategoriesModel>> getCategories();
}

class CategoriesRepository implements ICompetitionCategoriesRepository {
  final IHttpClient client;
  final String token;

  CategoriesRepository({required this.client, required this.token});

  @override
  Future<List<CategoriesModel>> getCategories() async {
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //String? token = sharedPreferences.getString('auth_token');

    print('Token: $token');
    final response = await client.get(
      url: 'http://192.168.0.37:5000/categories',
      headers: token != null ? {'Authorization': 'Bearer $token'} : null, // Adiciona o token se não for nulo
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final List<CategoriesModel> categories = [];
      final body = jsonDecode(response.body);

      body['categories'].forEach((item) {
        final CategoriesModel competition = CategoriesModel.fromMap(item);
        categories.add(competition);
      });
      print(categories);

      return categories;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Erro ao interpretar resposta');
    } else {
      throw Exception('Erro ...');
    }
  }
}