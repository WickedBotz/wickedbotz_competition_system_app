import 'dart:convert';
import '../http/exceptions.dart';
import '../http/http_client.dart';
import '../models/robots_by_category_model.dart';

abstract class IRobotByCategoryRepository{
  Future<List<RobotsByCategoryModel>> getRobotsByCategory({required int category_id});
}

class RobotsByCategoryRepository implements IRobotByCategoryRepository{
  final IHttpClient client;
  final String token;

  RobotsByCategoryRepository({required this.client, required this.token});

  @override
  Future<List<RobotsByCategoryModel>> getRobotsByCategory({required int category_id}) async{
    print('Categori ID: $category_id');
    final response = await client.get(
        url: 'http://192.168.0.37:5000/robots/$category_id',
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    );


    if(response.statusCode == 200){
      final List<RobotsByCategoryModel> lineFollowers = [];

      final body = jsonDecode(response.body);
      body['robots'].map((item) {
        final RobotsByCategoryModel lf = RobotsByCategoryModel.fromMap(item);
        lineFollowers.add(lf);
      }).toList();

      return lineFollowers;
    }else if(response.statusCode == 404){
      throw NotFoundException('Erro ao interpretar resposta');
    }else{
      throw Exception('Erro ...');
    }
  }
}