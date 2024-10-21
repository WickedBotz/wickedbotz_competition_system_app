import 'package:app_jurados/data/http/exceptions.dart';
import 'package:app_jurados/data/models/robots_by_category_model.dart';
import 'package:app_jurados/data/repository/robots_by_category_repository.dart';
import 'package:flutter/cupertino.dart';

class RobotsByCategoryStore {
  final IRobotByCategoryRepository repository;

  // variaveis reativas do estado da requisiçao
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<RobotsByCategoryModel>> state = ValueNotifier<List<RobotsByCategoryModel>>([]);
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  RobotsByCategoryStore({required this.repository});

  Future getRobotsByCategory({required int category_id}) async{
    isLoading.value = true;

    try{
      final result = await repository.getRobotsByCategory(category_id: category_id);
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