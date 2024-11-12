import 'dart:ui';
import 'package:app_jurados/pages/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/http/http_client.dart';
import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import '../data/repository/user_repository.dart';
import '../themes/app_theme.dart';
import '../widgets/gradient_button_widget.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff000000), Color(0xff245C6B), Color(0xff0CFFFD)],
                stops: [0.75, 1, 0.5],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Ajuste os valores de sigma conforme necessário
            child: Container(
              color: Colors.black.withOpacity(0.7), // Necessário para o BackdropFilter funcionar
            ),
          ),
          // Conteúdo do login
          _buildLoginContent(context),
        ],
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  'image-removebg-preview.png',
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
                  _buildGradientBorderTextField(
                    focusNode: _focusNodeUser,
                    obscureText: false,
                    hintText: 'E-mail',
                    prefixIcon: Icons.person,
                    controller: email_controller,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (email == null || email.isEmpty) return 'E-mail inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildGradientBorderTextField(
                    focusNode: _focusNodePassword,
                    obscureText: true,
                    hintText: 'Senha',
                    prefixIcon: Icons.lock,
                    controller: password_controller,
                    keyboardType: TextInputType.text,
                    validator: (senha) {
                      if (senha == null || senha.isEmpty) return 'Senha inválida';
                      if (senha.length < 3) return 'Senha inválida';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.57,
              child: BuildGradientButtonWidget(
                text: 'Entrar',
                onPressed: () async {
                  if (form_key.currentState!.validate()) {
                    bool loginSuccess = await loginSuccessfully();
                    if (loginSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CompetitionsPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao fazer login')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> loginSuccessfully() async {
    HttpClient client = HttpClient();
    final UserStore store = UserStore(repository: UserRepository(client: client));
    await store.loginRequest(
      username: email_controller.text,
      password: password_controller.text,
    );

    if (store.error.value.isNotEmpty || store.state.value == null) {
      return false;
    } else {
      final UserModel user = store.state.value!;
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      return true;
    }
  }

  Widget _buildGradientBorderTextField({
    required FocusNode focusNode,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return FractionallySizedBox(
      widthFactor: 0.57,
      child: DecoratedBox(
        decoration: Theme.of(context).extension<GradientContainerTheme>()!.gradientDecoration!,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextFormField(
            focusNode: focusNode,
            obscureText: obscureText,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.labelMedium,
              prefixIcon: Icon(prefixIcon, color: const Color.fromARGB(136, 153, 151, 151)),
              filled: true,
              fillColor: const Color.fromARGB(255, 14, 14, 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            cursorColor: Colors.grey,
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
          ),
        ),
      ),
    );
  }
}
