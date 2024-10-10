import 'package:flutter/material.dart';
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
              )),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Imagem dentro de um círculo
                  Container(
                    width: 150, // Define a largura do círculo
                    height: 150, // Define a altura do círculo
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      //child: Image.network('https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
                      //fit: BoxFit.cover,),
                      child: Image.network(
                        'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
                        fit: BoxFit.cover, // Faz a imagem se ajustar ao círculo
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Texto Bem-Vindo
                  Text(
                    'Bem-Vindo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),

                  // Campo de usuário com gradiente nas bordas
                  _buildGradientBorderTextField(
                    focusNode: _focusNodeUser,
                    hintText: 'Usuário',
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: 20),

                  // Campo de senha com gradiente nas bordas
                  _buildGradientBorderTextField(
                    focusNode: _focusNodePassword,
                    hintText: 'Senha',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: 20),

                  // Botão com gradiente
                  BuildGradientButtonWidget(
                    text: 'Entrar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CompetitionsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // Função para construir o campo de texto com borda gradiente
  Widget _buildGradientBorderTextField({
    required FocusNode focusNode,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return DecoratedBox(
      decoration: Theme.of(context).extension<GradientContainerTheme>()!.gradientDecoration!,
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
