import 'dart:convert';
import 'package:app_jurados/components/ConfirmDialog.dart';
import 'package:app_jurados/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../components/ButtonGradient.dart';
import '../components/CombatContainerLandscape.dart';
import '../components/CombatContainerPortrait.dart';
import '../data/env/env.dart';
import '../data/http/http_client.dart';
import '../data/models/category_match_model.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import '../widgets/sidebar_widget.dart';

class CombatMatchPage extends StatefulWidget {
  final CategoryMatchModel Match;
  final CompetitionsModel Competiotion;
  final CategoriesModel Category;

  const CombatMatchPage({
    super.key,
    required this.Match,
    required this.Competiotion,
    required this.Category,
  });

  @override
  State<CombatMatchPage> createState() => _CombatMatchPage();
}

class _CombatMatchPage extends State<CombatMatchPage> {
  late UserModel user;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final robot1Controller = TextEditingController(text: '0');
  final robot2Controller = TextEditingController(text: '0');
  int? winner;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user!;
    winner = widget.Match.robot_1_id;

    // Bloquear a orientação apenas para paisagem
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Restaurar a orientação padrão ao sair da página
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const CustomSidebar(),
      appBar: orientation == Orientation.portrait
          ? buildAppBar(context, _scaffoldKey)
          : null, // Oculta o AppBar no modo landscape
      body: orientation == Orientation.portrait
          ? viewModePortrait()
          : viewModeLandscape(),
    );
  }

  Widget viewModePortrait() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CombatContainerPortrait(
              robotName: widget.Match.robot_1_name,
              teamName: widget.Match.team_1_name,
              controller: robot1Controller,
              backgroundColor: AppTheme.cancelarFundo,
              borderColor: AppTheme.enviarBorda,
              onIncrement: () {
                setState(() {
                  int currentValue = int.tryParse(robot1Controller.text) ?? 0;
                  robot1Controller.text = (currentValue + 1).toString();
                });
              },
              onDecrement: () {
                setState(() {
                  int currentValue = int.tryParse(robot1Controller.text) ?? 0;
                  if (currentValue > 0) {
                    robot1Controller.text = (currentValue - 1).toString();
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            CombatContainerPortrait(
              robotName: widget.Match.robot_2_name,
              teamName: widget.Match.team_2_name,
              controller: robot2Controller,
              borderColor: AppTheme.cancelarBorda,
              onIncrement: () {
                setState(() {
                  int currentValue = int.tryParse(robot2Controller.text) ?? 0;
                  robot2Controller.text = (currentValue + 1).toString();
                });
              },
              onDecrement: () {
                setState(() {
                  int currentValue = int.tryParse(robot2Controller.text) ?? 0;
                  if (currentValue > 0) {
                    robot2Controller.text = (currentValue - 1).toString();
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment
                  .bottomCenter, // Posiciona o botão no centro inferior
              child: Container(
                width: 280, // Define a largura do botão
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ButtonGradient(
                  text: 'Enviar',
                  width: MediaQuery.of(context).size.width * 0.8,
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      _showConfirmationDialog();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Formulário Inválido')),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget viewModeLandscape() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CombatContainerLandscape(
                  robotName: widget.Match.robot_1_name,
                  teamName: widget.Match.team_1_name,
                  controller: robot1Controller,
                  backgroundColor: AppTheme.cancelarFundo,
                  borderColor: AppTheme.enviarBorda,
                  onIncrement: () {
                    setState(() {
                      int currentValue =
                          int.tryParse(robot1Controller.text) ?? 0;
                      robot1Controller.text = (currentValue + 1).toString();
                    });
                  },
                  onDecrement: () {
                    setState(() {
                      int currentValue =
                          int.tryParse(robot1Controller.text) ?? 0;
                      if (currentValue > 0) {
                        robot1Controller.text = (currentValue - 1).toString();
                      }
                    });
                  },
                ),
                CombatContainerLandscape(
                  robotName: widget.Match.robot_2_name,
                  teamName: widget.Match.team_2_name,
                  controller: robot2Controller,
                  borderColor: AppTheme.cancelarBorda,
                  onIncrement: () {
                    setState(() {
                      int currentValue =
                          int.tryParse(robot2Controller.text) ?? 0;
                      robot2Controller.text = (currentValue + 1).toString();
                    });
                  },
                  onDecrement: () {
                    setState(() {
                      int currentValue =
                          int.tryParse(robot2Controller.text) ?? 0;
                      if (currentValue > 0) {
                        robot2Controller.text = (currentValue - 1).toString();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return AppBar(
      elevation: 10,
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
      ],
    );
  }

  Future<void> _showConfirmationDialog() async {
    // Determina o vencedor com base nos pontos
    final int robot1Points = int.parse(robot1Controller.text);
    final int robot2Points = int.parse(robot2Controller.text);

    if (robot1Points > robot2Points) {
      winner = widget.Match.robot_1_id;
    } else if (robot2Points > robot1Points) {
      winner = widget.Match.robot_2_id;
    } else {
      winner = null; // Caso de empate
    }

    final winnerName = winner == widget.Match.robot_1_id
        ? widget.Match.robot_1_name
        : widget.Match.robot_2_name;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Confirma os pontos e o vencedor?',
          recordedTimes: [
            {'time': '${widget.Match.robot_1_name}: $robot1Points pontos'},
            {'time': '${widget.Match.robot_2_name}: $robot2Points pontos'},
            {
              'time': winner != null
                  ? 'Vencedor: $winnerName'
                  : 'Empate! Nenhum vencedor determinado'
            },
          ],
          onConfirm: () async {
            if (winner != null) {
              final sent = await sendFormValues();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    sent
                        ? 'Dados Enviados com Sucesso'
                        : 'Erro ao enviar os dados',
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Resolva o empate antes de confirmar.')),
              );
            }
          },
          onCancel: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Envio Cancelado')),
            );
          },
        );
      },
    );
  }

  Future<bool> sendFormValues() async {
    // Validação extra para garantir que os pontos e o vencedor sejam enviados corretamente
    if (winner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum vencedor foi definido')),
      );
      return false;
    }

    final token = user.token;
    final client = HttpClient();
    final body = jsonEncode({
      'date': DateTime.now().toIso8601String(),
      'winner': winner,
      'robot_1': widget.Match.robot_1_id,
      'robot_2': widget.Match.robot_2_id,
      'category_id': widget.Category.category_id,
      'sequence': widget.Match.sequence,
      'current': widget.Match.current,
      'judge_id': user.id,
      'robot_1_points': int.parse(robot1Controller.text),
      'robot_2_points': int.parse(robot2Controller.text),
    });

    try {
      final response = await client.put(
        url: '${Env.API_URL}/matches/${widget.Match.match_id}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: body,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        debugPrint('Erro ao salvar pontos: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Erro de rede: $e');
      return false;
    }
  }
}
