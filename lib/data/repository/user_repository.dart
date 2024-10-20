import 'dart:convert';
import '../http/exceptions.dart';
import '../http/http_client.dart';
import '../models/user_model.dart';

abstract class IUserRepository {
  Future<UserModel> loginRequest({required String username, required String password});
}

class UserRepository implements IUserRepository {
  final IHttpClient client;

  UserRepository({required this.client});

  @override
  Future<UserModel> loginRequest({required String username, required String password}) async {
    // Cria o corpo da requisição com os dados do login
    final body = jsonEncode({'username': username, 'password': password});

    // Faz a requisição POST com o corpo e cabeçalho adequado
    final response = await client.post(
      url: 'http://10.0.2.2:5000/login',
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Json body: ${jsonDecode(response.body)}');

    // Verifica o status da resposta
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final userMap = responseBody['user'];

      final UserModel user = UserModel.fromMap(userMap);

      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Erro ao interpretar resposta');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }
}
