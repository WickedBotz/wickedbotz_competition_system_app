import 'dart:convert';

import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/data/models/competitions_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http/exceptions.dart';

abstract class ICompetitionsRepository{
  Future<List<CompetitionsModel>> getCompetitions();
}

class CompetitionsRepository implements ICompetitionsRepository {
  final IHttpClient client;
  final String token;

  CompetitionsRepository({required this.client, required this.token});

  @override
  Future<List<CompetitionsModel>> getCompetitions() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // String? token = sharedPreferences.getString('auth_token');

    final response = await client.get(
      url: 'http://10.0.2.2:5000/competitions',
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    );

    if (response.statusCode == 200) {
      final List<CompetitionsModel> competitions = [];
      final body = jsonDecode(response.body);

      body['competitions'].forEach((item) {
        final CompetitionsModel competition = CompetitionsModel.fromMap(item);
        competitions.add(competition);
      });

      return competitions;
    } else if (response.statusCode == 404) {
      final body = jsonDecode(response.body);
      throw NotFoundException('Erro ao interpretar resposta');
    } else {
      throw Exception('Erro ...');
    }
  }
}