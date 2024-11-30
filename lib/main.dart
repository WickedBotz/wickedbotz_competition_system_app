import 'package:app_jurados/pages/competitions_page.dart';
import 'package:app_jurados/pages/login_page.dart';
import 'package:app_jurados/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/provider/user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(), // Cria uma instância do UserProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.mainTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> checkValidToken() async {
    print('checkValidToken');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('token') != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkValidToken(),
      builder: (context, snapshot) {
        // Enquanto o Future ainda está carregando, exibe o CircularProgressIndicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Em caso de erro, exibe uma mensagem
          return const Center(child: Text("Erro ao verificar token"));
        } else {
          // Se o snapshot tem dados, realiza a navegação com base no resultado
          bool isValidToken = snapshot.data ?? false;
          if (isValidToken) {
            // Redireciona para CompetitionsPage se o token for válido
            Future.microtask(() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const CompetitionsPage()));
            });
          } else {
            // Redireciona para LoginPage se o token for inválido
            Future.microtask(() {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const LoginPage()));
            });
          }
          // Retorna um widget vazio enquanto a navegação ocorre
          return Container();
        }
      },
    );
  }
}
