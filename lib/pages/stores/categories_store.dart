import 'package:flutter/cupertino.dart';
import '../../data/http/exceptions.dart';
import '../../data/models/categoties_model.dart';
import '../../data/repository/categories_repository.dart';

class CategoriesStore {
  final ICategoriesRepository repository;

  // variaveis reativas do estado da requisiçao
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<CategoriesModel>> state = ValueNotifier<List<CategoriesModel>>([]);
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  CategoriesStore({required this.repository});

  Future getCategories() async{
    isLoading.value = true;

    try{
      final result = await repository.getCategories();
      state.value = result;
    } on NotFoundException catch (e){
      print('Unexpected error result');
      erro.value = e.message;
    }
    catch(e){
      erro.value = e.toString();
      print('Dart default error result');
      print(e.toString());
    }
    isLoading.value = false;
  }
}