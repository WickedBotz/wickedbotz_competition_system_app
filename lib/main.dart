import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/provider/user_provider.dart';
import 'pages/competitions_page.dart';
import 'pages/login_page.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configura o aplicativo para permanecer sempre em orientação vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Apenas vertical normal
    DeviceOrientation.portraitDown, // Permitir inverter vertical (opcional)
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnToken();
  }

  Future<void> _navigateBasedOnToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isValidToken = sharedPreferences.getString('token') != null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isValidToken) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompetitionsPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
