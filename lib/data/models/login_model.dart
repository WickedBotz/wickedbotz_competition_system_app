import 'package:intl/intl.dart';

class LoginModel {
  final String token;


  LoginModel(
      {
        required this.token,
      });

  factory LoginModel.fromMap(Map<String, dynamic> map) {

    return LoginModel(
      token: map['token'],
    );
  }
}
