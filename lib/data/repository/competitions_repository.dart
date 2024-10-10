import 'dart:convert';

import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/data/models/competitions_model.dart';

import '../http/exceptions.dart';

abstract class ICompetitionsRepository{
  Future<List<CompetitionsModel>> getCompetitions();
}

class CompetitionsRepository implements ICompetitionsRepository{
  final IHttpClient client;

  CompetitionsRepository({required this.client});

  @override
  Future<List<CompetitionsModel>> getCompetitions() async {
    final response = await client.get(url: 'http://127.0.0.1:5000/competitions');
    if(response.statusCode == 200){
      final List<CompetitionsModel> competitions = [];

      final body = jsonDecode(response.body);
      body['competitions'].map((item) {
        final CompetitionsModel lf = CompetitionsModel.fromMap(item);
        competitions.add(lf);
      }).toList();

      return competitions;
    }else if(response.statusCode == 404){
      throw NotFoundException('Erro ao interpretar resposta');
    }else{
      throw Exception('Erro ...');
    }
  }


}