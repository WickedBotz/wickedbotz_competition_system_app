import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/http/http_client.dart';
import '../data/models/category_time_trial_model.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import '../widgets/gradient_button_widget.dart';

class LineFollowerTimeTrialPage extends StatefulWidget {
  final CategoryTimeTrialModel timeTrial;
  final CompetitionsModel Competiotion;
  final CategoriesModel Category;

  const LineFollowerTimeTrialPage({super.key, required this.timeTrial, required this.Competiotion, required this.Category});

  @override
  State<LineFollowerTimeTrialPage> createState() => _LineFollowerTimeTrialPage();
}

class _LineFollowerTimeTrialPage extends State<LineFollowerTimeTrialPage> {
  late UserModel user;
  final _formKey = GlobalKey<FormState>();
  final timeTrialControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final isValidTimeTrial = [false, false, false];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user!;
    print('CategoryTimeTrialModel: ${widget.timeTrial}');
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
              buildTimeTrialFields(),
              const SizedBox(height: 20),
              BuildGradientButtonWidget(
                text: 'Enviar',
                onPressed: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  if (_formKey.currentState!.validate()) {
                    _showConfirmationDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Formulario Invalido')),
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
      height: 200.0,
      width: 180.0,
      color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120.0,
            width: 120.0,
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
          Text('Robo: ${widget.timeTrial.robot_name}', style: const TextStyle(color: Colors.white)),
          Text('Time: ${widget.timeTrial.team_name}', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget buildTimeTrialFields() {
    return Column(
      children: List.generate(3, (index) {
        return Column(
          children: [
            TextFormField(
              controller: timeTrialControllers[index],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
              ],
              decoration: InputDecoration(
                icon: const Icon(Icons.timer_outlined),
                hintText: 'ex: 15.04',
                labelText: 'Time Trial ${index + 1}',
              ),
              validator: (value) => isValidTimeTrial[index] && (value == null || value.isEmpty)
                  ? 'Campo obrigatório'
                  : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isValidTimeTrial[index],
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() => isValidTimeTrial[index] = value!);
                  },
                ),
                const Text('Volta Válida? '),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }

  Future<void> _showConfirmationDialog() async {
    bool sendValues = false;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Confirmar?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 3; i++)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text('Time Trial ${i + 1}: '),
                          Text((double.tryParse(timeTrialControllers[i].text) ?? 0.0).toString()),
                      ],),
                      Text('Valido?  ${isValidTimeTrial[i] ? 'Sim': 'Não'}'),
                      const SizedBox(height: 20),
                    ],
                  ),
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
      'date_time': DateTime.now().toIso8601String(),
      'competition_id': widget.Competiotion.comp_id,
      'category_id': widget.Category.category_id,
      'time1': double.tryParse(timeTrialControllers[0].text) ?? 0.0,
      'time2': double.tryParse(timeTrialControllers[1].text) ?? 0.0,
      'time3': double.tryParse(timeTrialControllers[2].text) ?? 0.0,
      'robot_id': widget.timeTrial.robot_id,
    });

    final response = await client.post(
      url: 'http://localhost:5000/time_trials',
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: body,
    );


    return response.statusCode == 201 ? true : false;
  }
}
