import 'package:flutter/cupertino.dart';
import '../../data/http/exceptions.dart';
import '../../data/models/category_time_trial_model.dart';
import '../../data/repository/category_time_trial_repository.dart';

class CategoryTimeTrialStore {
  final ICategoryTimeTrialRepository repository;

  // variaveis reativas do estado da requisiçao
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<CategoryTimeTrialModel>> state = ValueNotifier<List<CategoryTimeTrialModel>>([]);
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  CategoryTimeTrialStore({required this.repository});

  Future getRobotsTimeTrial({required int category_id}) async{
    isLoading.value = true;

    try{
      final result = await repository.getRobotsTimeTrial(category_id: category_id);
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