import 'package:app_jurados/data/models/competitions_model.dart';
import 'package:app_jurados/data/repository/competitions_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../data/http/exceptions.dart';

class CompetitionsStore {
  final ICompetitionsRepository repository;

  // variaveis reativas do estado da requisiçao
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<CompetitionsModel>> state = ValueNotifier<List<CompetitionsModel>>([]);
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  CompetitionsStore({required this.repository});

  Future getCompetitions() async{
    isLoading.value = true;

    try{
      final result = await repository.getCompetitions();
      state.value = result;
    } on NotFoundException catch (e){
      erro.value = e.message;
    }
    catch(e){
      erro.value = e.toString();
      print('dart default error  on result');
      print(e.toString());
    }
    isLoading.value = false;
  }
}