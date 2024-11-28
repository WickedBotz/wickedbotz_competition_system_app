class UserModel {
  final int id;
  final String name;
  final String email;
  final String token;


  UserModel(
      {
        required this.id,
        required this.name,
        required this.email,
        required this.token,
      });

  factory UserModel.fromMap(Map<String, dynamic> map) {

    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['e-mail'],
      token: map['token'],
    );
  }
}
