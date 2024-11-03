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
  final robot1Controller = TextEditingController();
  final robot2Controller = TextEditingController();
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
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInfoContainer(),
              const SizedBox(height: 20),
              buildWinnerField(),
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

  AppBar buildAppBar() {
    return AppBar(
      elevation: 10,
      backgroundColor: Colors.grey[800],
      leading: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.grey.shade900),
          image: const DecorationImage(
            image: NetworkImage(
                'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        'Logged in as: ${user.name}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
      ],
    );
  }

  Widget buildInfoContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.blueGrey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      height: 80.0,
                      width: 80.0,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade900),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Robot: ${widget.Match.robot_1_name}', style: const TextStyle(color: Colors.white)),
                        Text('Team: ${widget.Match.team_1_name}', style: const TextStyle(color: Colors.white)),
                      ],
                    )
                  ],
                ),
                TextFormField(
                  controller: robot1Controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                  ],
                  decoration: InputDecoration(
                    icon: const Icon(Icons.timer_outlined),
                    hintText: 'ex: 15.04',
                    labelText: 'Pontos ${widget.Match.robot_1_name}',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.blueGrey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      height: 80.0,
                      width: 80.0,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade900),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Robot: ${widget.Match.robot_2_name}', style: const TextStyle(color: Colors.white)),
                        Text('Team: ${widget.Match.team_2_name}', style: const TextStyle(color: Colors.white)),
                      ],
                    )
                  ],
                ),
                TextFormField(
                  controller: robot2Controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                  ],
                  decoration: InputDecoration(
                    icon: const Icon(Icons.timer_outlined),
                    hintText: 'ex: 15.04',
                    labelText: 'Pontos ${widget.Match.robot_2_name}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWinnerField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text('Selecione o Vencedor:'),
          const SizedBox(height: 10),
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Radio<int>(
                  value: widget.Match.robot_1_id,
                  groupValue: winner,
                  activeColor: Colors.green,
                  onChanged: (value) => setState(() => winner = value!),
                ),
                Text(widget.Match.robot_1_name),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Radio<int>(
                  value: widget.Match.robot_2_id,
                  groupValue: winner,
                  activeColor: Colors.green,
                  onChanged: (value) => setState(() => winner = value!),
                ),
                Text(widget.Match.robot_2_name),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    bool sendValues = false;
    final _winner = winner == widget.Match.robot_1_id
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
                SizedBox(height: 10,),
                Text('Vencedor:'),
                Text(_winner),
                SizedBox(height: 20,),
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
              BuildGradientButtonWidget(
                text: 'Enviar',
                onPressed: () async {
                  if(sendValues){
                    final sent = await sendFormValues();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(sent ? 'Dados Enviados com Sucesso' : 'Erro ao enviar os dados')),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Confirme os valores')),
                    );
                  }
                },
              ),
              SizedBox(height: 20,),
              BuildGradientButtonWidget(
                text: 'Cancelar',
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Envio Cancelado')),
                  );
                },

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
      'sequence':widget.Match.sequence,
      'current': widget.Match.current,
      'judge_id': user.id
    });

    final response = await client.put(
      url: 'http://10.0.2.2:5000/matches/${widget.Match.match_id}',
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: body,
    );


    return response.statusCode == 201 ? true : false;
  }
}
