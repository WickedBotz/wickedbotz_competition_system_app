import 'package:app_jurados/data/models/category_match_model.dart';
import 'package:app_jurados/data/repository/category_match_repository.dart';
import 'package:flutter/cupertino.dart';
import '../../data/http/exceptions.dart';

class CategoryMatchStore {
  final ICategoryMatchRepository repository;

  // variaveis reativas do estado da requisiçao
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<CategoryMatchModel>> state = ValueNotifier<List<CategoryMatchModel>>([]);
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  CategoryMatchStore({required this.repository});

  Future getRobotsMatch({required int category_id}) async{
    isLoading.value = true;

    try{
      final result = await repository.getRobotsMatch(category_id: category_id);
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