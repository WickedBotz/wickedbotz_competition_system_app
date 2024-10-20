import 'dart:convert';
import 'package:app_jurados/pages/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/http/http_client.dart';
import '../data/repository/user_repository.dart';
import '../themes/app_theme.dart';
import '../widgets/gradient_button_widget.dart';
import 'package:http/http.dart' as http;

import 'competitions_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _focusNodeUser = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  final form_key = GlobalKey<FormState>();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff000000), Color(0xff06060e), Color(0xff000428)],
            stops: [0.1, 0.8, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagem dentro de um círculo
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bem-Vindo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Form(
                  key: form_key,
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: _focusNodeUser, // Corrigido para o campo de email
                        obscureText: false,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          prefixIcon: const Icon(Icons.person, color: Colors.white54),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        controller: email_controller,
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        focusNode: _focusNodePassword,
                        obscureText: true,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        controller: password_controller,
                        keyboardType: TextInputType.text,
                        validator: (senha) {
                          if (senha == null || senha.isEmpty) {
                            return 'Senha inválida';
                          } else if (senha.length < 3) {
                            return 'Senha inválida';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Botão com gradiente
                BuildGradientButtonWidget(
                  text: 'Entrar',
                  onPressed: () async {
                    print("Botão pressionado");
                    if (form_key.currentState!.validate()) {

                      bool loginSuccess = await loginSuccessfully();
                      if (loginSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CompetitionsPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao fazer login'),
                          ),
                        );
                      }
                    }else{
                      print("Formulário inválido");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> loginSuccessfully() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    HttpClient client = HttpClient();

    final UserStore store = UserStore(repository: UserRepository(client: client));
    await store.loginRequest(username: email_controller.text, password: password_controller.text);

    if (store.error.value.isNotEmpty || store.state.value == null) {
      print('Login Error ${store.error.value}');
      return false;
    }
    else {
      return true;
    }



    // var url = Uri.parse('http://10.0.2.2:5000/login');
    //
    // var response = await http.post(
    //   url,
    //   headers: {
    //     'Content-Type': 'application/json',  // Define o cabeçalho como JSON
    //   },
    //   body: jsonEncode({
    //     'username': email_controller.text,
    //     'password': password_controller.text
    //   }),
    // );
    //
    // if (response.statusCode == 200) {
    //   try {
    //     var jsonResponse = jsonDecode(response.body);
    //
    //     String token = jsonResponse['token'];
    //     await sharedPreferences.setString('auth_token', token);
    //
    //     return true;
    //   } catch (e) {
    //     print('Erro ao decodificar JSON: $e');
    //     return false;
    //   }
    // } else {
    //   print('Erro: ${response.statusCode}');
    //   return false;
    // }
  }



  // Função para construir o campo de texto com borda gradiente
  Widget _buildGradientBorderTextField({
    required FocusNode focusNode,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return DecoratedBox(
      decoration: Theme.of(context)
          .extension<GradientContainerTheme>()!
          .gradientDecoration!,
      child: Padding(
        padding: const EdgeInsets.all(3.0), // Espaço entre a borda e o campo
        child: TextField(
          focusNode: focusNode,
          obscureText: obscureText,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.labelMedium,
            prefixIcon: Icon(prefixIcon, color: Colors.white54),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove a borda padrão
            ),
          ),
        ),
      ),
    );
  }
}
