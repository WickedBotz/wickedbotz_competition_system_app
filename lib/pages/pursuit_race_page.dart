import 'dart:convert';
import 'package:app_jurados/components/ButtonGradient.dart';
import 'package:app_jurados/components/ConfirmDialog.dart';
import 'package:app_jurados/components/TruncateText.dart';
import 'package:app_jurados/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/http/http_client.dart';
import '../data/models/category_match_model.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';

import '../widgets/sidebar_widget.dart';

class PursuitMatchPage extends StatefulWidget {
  final CategoryMatchModel Match;
  final CompetitionsModel Competiotion;
  final CategoriesModel Category;

  const PursuitMatchPage(
      {super.key,
      required this.Match,
      required this.Competiotion,
      required this.Category});

  @override
  State<PursuitMatchPage> createState() => _PursuitMatchPage();
}

class _PursuitMatchPage extends State<PursuitMatchPage> {
  late UserModel user;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      endDrawer: const CustomSidebar(),
      appBar: buildAppBar(context, _scaffoldKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildMatchInfoContainer(),
              const SizedBox(height: 20),
              buildWinnerField(),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: ButtonGradient(
                  text: 'Enviar',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _showConfirmationDialog();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Selecione um vencedor antes de enviar')),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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

  Widget buildMatchInfoContainer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildRobotInfoContainer(
              widget.Match.robot_1_name,
              'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
              winner == widget.Match.robot_1_id
                  ? Colors.blue
                  : Colors.grey.shade800,
            ),
            buildRobotInfoContainer(
              widget.Match.robot_2_name,
              'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
              winner == widget.Match.robot_2_id
                  ? Colors.red
                  : Colors.grey.shade800,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRobotInfoContainer(
      String robotName, String imageUrl, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      width: MediaQuery.of(context).size.width / 2.5,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TruncateText(
            text: robotName,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }

  Widget buildWinnerField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione o Vencedor:',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          buildWinnerButton(
              widget.Match.robot_1_name, widget.Match.robot_1_id, Colors.blue),
          const SizedBox(height: 10),
          buildWinnerButton(
              widget.Match.robot_2_name, widget.Match.robot_2_id, Colors.red),
        ],
      ),
    );
  }

  Widget buildWinnerButton(String robotName, int robotId, Color borderColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          winner = robotId;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: winner == robotId ? borderColor : Colors.transparent,
            width: 2,
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: Text(
            robotName,
            style: TextStyle(
              color: winner == robotId ? borderColor : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }


_showConfirmationDialog() {
  final winnerName = winner == widget.Match.robot_1_id
      ? widget.Match.robot_1_name
      : widget.Match.robot_2_name;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        message: 'Você confirma que o vencedor é: $winnerName?', // Mensagem personalizada
        onConfirm: () async {
          final success = await sendFormValues();
          Navigator.pop(context);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dados enviados com sucesso')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao enviar os dados')),
            );
          }
        },
        onCancel: () {
          Navigator.pop(context);
        },
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
    });

    final response = await client.put(
      url:
          'localhost/matches/${widget.Match.match_id}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: body,
    );

    return response.statusCode == 201;
  }
}
