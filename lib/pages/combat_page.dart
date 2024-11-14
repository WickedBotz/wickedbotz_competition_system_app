import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/http/http_client.dart';
import '../data/models/category_match_model.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import '../widgets/gradient_button_widget.dart';
import '../widgets/sidebar_widget.dart';

class CombatMatchPage extends StatefulWidget {
  final CategoryMatchModel Match;
  final CompetitionsModel Competiotion;
  final CategoriesModel Category;

  const CombatMatchPage({super.key, required this.Match, required this.Competiotion, required this.Category});

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomSidebar(),
      appBar: buildAppBar(context, _scaffoldKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildCombatContainer(
                  widget.Match.robot_1_name, widget.Match.team_1_name, robot1Controller, Colors.blue, widget.Match.robot_1_id),
              const SizedBox(height: 20),
              buildCombatContainer(
                  widget.Match.robot_2_name, widget.Match.team_2_name, robot2Controller, Colors.red, widget.Match.robot_2_id),
              const SizedBox(height: 20),
              BuildGradientButtonWidget(
                text: 'Enviar',
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return AppBar(
      elevation: 10,
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
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

  Widget buildCombatContainer(
      String robotName, String teamName, TextEditingController controller, Color borderColor, int robotId) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black12, // Fundo escuro
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 3, // Espessura da borda
        ),
      ),
      child: Column(
        children: [
          Text(
            'Robô: $robotName',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Equipe: $teamName',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: const NetworkImage(
                    'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 48, // Aumentar o tamanho do botão "-"
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () {
                  setState(() {
                    int currentValue = int.parse(controller.text);
                    if (currentValue > 0) {
                      currentValue--;
                      controller.text = currentValue.toString();
                    }
                  });
                },
              ),
              SizedBox(
                width: 90, // Aumentar a largura do campo de pontos
                height: 60, // Aumentar a altura do campo de pontos
                child: TextFormField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 32),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[850], // Fundo escuro do input
                    focusColor: Colors.grey, // Cor do cursor
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                iconSize: 48, // Aumentar o tamanho do botão "+"
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  setState(() {
                    int currentValue = int.parse(controller.text);
                    currentValue++;
                    controller.text = currentValue.toString();
                  });
                },
              ),
            ],
          ),
          RadioListTile<int>(
            value: robotId,
            groupValue: winner,
            activeColor: Colors.green,
            title: Text(
              'Selecionar $robotName',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onChanged: (value) {
              setState(() {
                winner = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    bool sendValues = false;
    final winnerName = winner == widget.Match.robot_1_id
        ? widget.Match.robot_1_name
        : widget.Match.robot_2_name;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Confirmar?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${widget.Match.robot_1_name} ${robot1Controller.text} Pontos'),
                Text('${widget.Match.robot_2_name} ${robot2Controller.text} Pontos'),
                const SizedBox(height: 10),
                const Text('Vencedor:'),
                Text(winnerName),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: sendValues,
                      activeColor: Colors.green,
                      onChanged: (value) => setState(() => sendValues = value!),
                    ),
                    const Text('Confirmar'),
                  ],
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: 100, // Reduzir tamanho do botão Enviar
                child: BuildGradientButtonWidget(
                  text: 'Enviar',
                  onPressed: () async {
                    if (sendValues) {
                      final sent = await sendFormValues();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(sent ? 'Dados Enviados com Sucesso' : 'Erro ao enviar os dados')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Confirme os valores')),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 100, // Reduzir tamanho do botão Cancelar
                child: BuildGradientButtonWidget(
                  text: 'Cancelar',
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Envio Cancelado')),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> sendFormValues() async {
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

    final response = await client.put(
      url: 'http://localhost:5000/matches/${widget.Match.match_id}',
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: body,
    );

    return response.statusCode == 201;
  }
}
