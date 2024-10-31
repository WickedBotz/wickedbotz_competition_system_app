import 'dart:convert';
import '../http/exceptions.dart';
import '../http/http_client.dart';
import '../models/category_match_model.dart';

abstract class ICategoryMatchRepository{
  Future<List<CategoryMatchModel>> getRobotsMatch({required int category_id});
}

class CategoryMatchRepository implements ICategoryMatchRepository {
  final IHttpClient client;
  final String token;

  CategoryMatchRepository({required this.client, required int category_id, required this.token});

  @override
  Future<List<CategoryMatchModel>> getRobotsMatch({required int category_id}) async {

    final response = await client.get(
      url: 'http://10.0.2.2:5000/robots/category/${category_id}',
      headers: token != null ? {'Authorization': 'Bearer $token'} : null, // Adiciona o token se não for nulo
    );

    //print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final List<CategoryMatchModel> timeTrials = [];
      final body = jsonDecode(response.body);

      print('Body: ${body}');

      body['matches'].forEach((item) {
        final CategoryMatchModel robots = CategoryMatchModel.fromMap(item);
        timeTrials.add(robots);
      });

      return timeTrials;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Erro ao interpretar resposta');
    } else {
      throw Exception('Erro ...');
    }
  }
}