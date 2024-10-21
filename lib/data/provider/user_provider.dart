import 'package:flutter/material.dart';
import '../models/user_model.dart';

// Criar variaveis do tipo 'Global' xD
class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners(); // Notifica os listeners quando o estado muda
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
