import 'dart:convert';
import '../http/exceptions.dart';
import '../http/http_client.dart';
import '../models/line_followers_model.dart';

abstract class ILineFollowerRepository{
  Future<List<LineFollowersModel>> getLineFollowers();
}

class LineFollowerRepository implements ILineFollowerRepository{
  final IHttpClient client;

  LineFollowerRepository({required this.client});
  @override
  Future<List<LineFollowersModel>> getLineFollowers() async{
    final response = await client.get(url: 'http://127.0.0.1:5000/robots/1');
    if(response.statusCode == 200){
      final List<LineFollowersModel> lineFollowers = [];

      final body = jsonDecode(response.body);
      body['robots'].map((item) {
        final LineFollowersModel lf = LineFollowersModel.fromMap(item);
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