import 'package:app_jurados/data/http/exceptions.dart';
import 'package:app_jurados/data/models/line_followers_model.dart';
import 'package:app_jurados/data/repository/line_followers_repository.dart';
import 'package:flutter/cupertino.dart';

class LineFollowersStore {
  final ILineFollowerRepository repository;

  // variaveis reativas do estado da requisiçao
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<LineFollowersModel>> state = ValueNotifier<List<LineFollowersModel>>([]);
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  LineFollowersStore({required this.repository});

  Future getLineFollowers() async{
    isLoading.value = true;

    try{
      final result = await repository.getLineFollowers();
      state.value = result;
    } on NotFoundException catch (e){
      erro.value = e.message;
    }
    catch(e){
      erro.value = e.toString();
      print('dart default error  on result');
    }
    isLoading.value = false;
  }
}