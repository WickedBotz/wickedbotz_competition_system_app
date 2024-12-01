import 'dart:convert';


import '../http/exceptions.dart';
import '../http/http_client.dart';
import '../models/category_time_trial_model.dart';

abstract class ICategoryTimeTrialRepository{
  Future<List<CategoryTimeTrialModel>> getRobotsTimeTrial({required int category_id});
}

class CategoryTimeTrialRepository implements ICategoryTimeTrialRepository {
  final IHttpClient client;
  final String token;

  CategoryTimeTrialRepository({required this.client, required int category_id, required this.token});

  @override
  Future<List<CategoryTimeTrialModel>> getRobotsTimeTrial({required int category_id}) async {

    final response = await client.get(
      url: 'https://035f-2804-30c-1806-a800-91b0-26ab-5791-fc1b.ngrok-free.app/robots/category/$category_id',
      headers: token != null ? {'Authorization': 'Bearer $token'} : null, // Adiciona o token se não for nulo
    );

    //print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final List<CategoryTimeTrialModel> timeTrials = [];
      final body = jsonDecode(response.body);

      body['robots'].forEach((item) {
        final CategoryTimeTrialModel robots = CategoryTimeTrialModel.fromMap(item);
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