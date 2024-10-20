import 'package:app_jurados/pages/competitions_page.dart';
import 'package:app_jurados/pages/login_page.dart';
import 'package:app_jurados/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.mainTheme,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Em caso de erro, exibe uma mensagem
          return Center(child: Text("Erro ao verificar token"));
        } else {
          // Se o snapshot tem dados, realiza a navegação com base no resultado
          bool isValidToken = snapshot.data ?? false;
          if (isValidToken) {
            // Redireciona para CompetitionsPage se o token for válido
            Future.microtask(() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CompetitionsPage()));
            });
          } else {
            // Redireciona para LoginPage se o token for inválido
            Future.microtask(() {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoginPage()));
            });
          }
          // Retorna um widget vazio enquanto a navegação ocorre
          return Container();
        }
      },
    );
  }
}
