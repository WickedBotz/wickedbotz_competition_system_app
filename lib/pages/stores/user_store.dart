import 'package:flutter/cupertino.dart';
import '../../data/http/exceptions.dart';
import '../../data/models/user_model.dart';
import '../../data/repository/user_repository.dart';

class UserStore {
  final IUserRepository repository;

  // variaveis reativas do estado da requisiçao
  final ValueNotifier<UserModel?> state = ValueNotifier<UserModel?>(null);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  UserStore({required this.repository});

  Future loginRequest({required String username, required String password}) async{

    print('Login request: ${username} : ${password}');

    try{
      final result = await repository.loginRequest(username: username, password: password);
      state.value = result;
    } on NotFoundException catch (e){
      print('Unexpected error result');
      error.value = e.message;
    }
    catch(e){
      error.value = e.toString();
      print('Dart default error result');
      print(e.toString());
    }
  }
}