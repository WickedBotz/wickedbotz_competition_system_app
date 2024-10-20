import 'dart:convert';
import '../http/exceptions.dart';
import '../http/http_client.dart';
import '../models/login_model.dart';

abstract class ILoginRepository{
  Future <LoginModel> getLoginResponse();
}

class LoginRepository implements ILoginRepository{
  final IHttpClient client;

  LoginRepository({required this.client});
  @override
  Future<LoginModel> getLoginResponse() async{
    final response = await client.get(url: 'http://127.0.0.1:5000/login');
    if(response.statusCode == 200){
      final LoginModel token;

      final body = jsonDecode(response.body);
      token = body;
      print('body ${body}');
      print('token: ${token}');
      return token;
    }else if(response.statusCode == 404){
      throw NotFoundException('Erro ao interpretar resposta');
    }else{
      throw Exception('Erro ...');
    }
  }

}