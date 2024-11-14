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
import '../widgets/sidebar_widget.dart';

class TrackingTimeTrialPage extends StatefulWidget {
  final CategoryTimeTrialModel timeTrial;
  final CompetitionsModel Competiotion;
  final CategoriesModel Category;

  const TrackingTimeTrialPage(
      {super.key,
      required this.timeTrial,
      required this.Competiotion,
      required this.Category});

  @override
  State<TrackingTimeTrialPage> createState() => _TrackingTimeTrialPage();
}

class _TrackingTimeTrialPage extends State<TrackingTimeTrialPage> {
  late UserModel user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<TimeTrialData> timeTrialDataList = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user!;
    print('CategoryTimeTrialModel: ${widget.timeTrial}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomSidebar(),
      appBar: buildAppBar(context, _scaffoldKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            buildInfoContainer(),
            const SizedBox(height: 20),
            buildTimeTrialList(),
            const SizedBox(height: 20),
            BuildGradientButtonWidget(
              text: 'Adicionar Volta',
              onPressed: () => _showAddTimeTrialDialog(),
            ),
            const SizedBox(height: 20),
            if (timeTrialDataList.length >= 3)
              BuildGradientButtonWidget(
                text: 'Enviar',
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _showConfirmationDialog();
                },
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

  Widget buildInfoContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Robô: ${widget.timeTrial.robot_name}',
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Equipe: ${widget.timeTrial.team_name}',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            height: 120.0,
            width: 120.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeTrialList() {
    return Column(
      children: List.generate(timeTrialDataList.length, (index) {
        final data = timeTrialDataList[index];
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volta ${index + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Tempo: ${data.time.toStringAsFixed(2)} segundos',
                  style: const TextStyle(color: Colors.white)),
              Text('Pontos: ${data.points}',
                  style: const TextStyle(color: Colors.white)),
              Text('Válida: ${data.isValid ? 'Sim' : 'Não'}',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _showAddTimeTrialDialog() async {
    final timeController = TextEditingController();
    final pointsController = TextEditingController();
    bool isValid = false;

    final result = await showDialog<TimeTrialData>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Volta'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: timeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                      ],
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: 'ex: 15.04',
                        labelText: 'Tempo (segundos)',
                        filled: true,
                        fillColor: Colors.grey[850],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: pointsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: 'ex: 8',
                        labelText: 'Pontos',
                        filled: true,
                        fillColor: Colors.grey[850],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isValid,
                          activeColor: Colors.green,
                          onChanged: (value) =>
                              setState(() => isValid = value!),
                        ),
                        const Text('Volta Válida?'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: BuildGradientButtonWidget(
                        text: 'Adicionar',
                        onPressed: () {
                          if (timeController.text.isNotEmpty &&
                              pointsController.text.isNotEmpty) {
                            final time =
                                double.tryParse(timeController.text) ?? 0.0;
                            final points =
                                int.tryParse(pointsController.text) ?? 0;

                            // Retorna a nova volta para a página principal
                            Navigator.of(context).pop(TimeTrialData(
                                time: time, points: points, isValid: isValid));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Preencha todos os campos')),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BuildGradientButtonWidget(
                        text: 'Cancelar',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    // Após o diálogo fechar, atualiza o estado na página principal
    if (result != null) {
      setState(() {
        timeTrialDataList.add(result);
      });
    }
  }

  Future<void> _showConfirmationDialog() async {
    bool sendValues = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirmar Envio'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...timeTrialDataList.map((data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Tempo: ${data.time.toStringAsFixed(2)} segundos',
                              style: const TextStyle(color: Colors.white)),
                          Text('Pontos: ${data.points}',
                              style: const TextStyle(color: Colors.white)),
                          Text('Válida: ${data.isValid ? 'Sim' : 'Não'}',
                              style: const TextStyle(color: Colors.white)),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                    Row(
                      children: [
                        Checkbox(
                          value: sendValues,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() => sendValues = value!);
                          },
                        ),
                        const Text('Confirmar'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: BuildGradientButtonWidget(
                        text: 'Enviar',
                        onPressed: () async {
                          if (sendValues) {
                            final sent = await sendFormValues();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(sent
                                      ? 'Dados Enviados com Sucesso'
                                      : 'Erro ao enviar os dados')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Confirme os valores')),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BuildGradientButtonWidget(
                        text: 'Cancelar',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> sendFormValues() async {
    final token = user.token;
    final client = HttpClient();

    final dataToSend = timeTrialDataList.map((data) {
      return {
        'time': data.time,
        'points': data.points,
        'is_valid': data.isValid,
      };
    }).toList();

    final body = jsonEncode({
      'date_time': DateTime.now().toIso8601String(),
      'competition_id': widget.Competiotion.comp_id,
      'category_id': widget.Category.category_id,
      'robot_id': widget.timeTrial.robot_id,
      'time_trials': dataToSend,
    });

    final response = await client.post(
      url: 'http://localhost:5000/time_trials',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: body,
    );

    return response.statusCode == 201;
  }
}

class TimeTrialData {
  final double time;
  final int points;
  final bool isValid;

  TimeTrialData(
      {required this.time, required this.points, required this.isValid});
}
