import 'dart:convert';
import 'package:app_jurados/components/RobotInfoCard.dart';

import '../components/ButtonGradient.dart';
import '../components/ConfirmDialog.dart';
import '../components/RecordTimeItem.dart';
import '../components/TimeInputField.dart';
import 'package:app_jurados/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/env/env.dart';
import '../data/http/http_client.dart';
import '../data/models/category_time_trial_model.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import '../widgets/sidebar_widget.dart';

class LineFollowerTimeTrialPage extends StatefulWidget {
  final CategoryTimeTrialModel timeTrial;
  final CompetitionsModel Competiotion;
  final CategoriesModel Category;

  const LineFollowerTimeTrialPage(
      {super.key,
      required this.timeTrial,
      required this.Competiotion,
      required this.Category});

  @override
  State<LineFollowerTimeTrialPage> createState() =>
      _LineFollowerTimeTrialPage();
}

class _LineFollowerTimeTrialPage extends State<LineFollowerTimeTrialPage> {
  late UserModel user;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController timeTrialController = TextEditingController();
  bool isValidTimeTrial = true;
  List<Map<String, dynamic>> recordedTimes = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user!;
    print('CategoryTimeTrialModel Name: ${widget.Category.category_name}');
    print('CategoryTimeTrialModel ID: ${widget.timeTrial.id}');
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
              buildInfoContainer(),
              const SizedBox(height: 20),
              buildTimeTrialFields(),
              const SizedBox(height: 20),
              ...buildRecordedTimes(),
              const SizedBox(height: 20),
              buildSendButton(), // Sempre exibe o botão
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

  Widget buildInfoContainer() {
    return RobotInfoCard(
      robotName: widget.timeTrial.robot_name,
      imageUrl:
          'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
    );
  }

  Widget buildTimeTrialFields() {
    return recordedTimes.length < 3
        ? TimeInputField(
            controller: timeTrialController,
            isEnabled: recordedTimes.length < 3,
            showAddIcon: true,
            showTimerIcon: true,
            onAddTime: () {
              if (_formKey.currentState!.validate() &&
                  recordedTimes.length < 3) {
                setState(() {
                  recordedTimes.add({
                    'time': timeTrialController.text,
                    'isValid': isValidTimeTrial,
                  });
                  timeTrialController.clear(); // Limpa o campo após adicionar
                });
              }
            },
          )
        : Container();
  }

  List<Widget> buildRecordedTimes() {
    return recordedTimes.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return RecordedTimeItem(
        time: item['time'],
        isValid: item['isValid'],
        onEdit: () {
          timeTrialController.text = item['time'];
          setState(() {
            recordedTimes.removeAt(index);
          });
        },
      );
    }).toList();
  }

  Widget buildSendButton() {
    final bool isEnabled =
        recordedTimes.length == 3; // Botão habilitado quando há 3 itens

    return Align(
      alignment: Alignment.bottomCenter, // Posiciona o botão no centro inferior
      child: Container(
        width: 280, // Define a largura do botão
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ButtonGradient(
          text: 'Enviar Tempos',
          onPressed: isEnabled
              ? () {
                  _showConfirmationDialog();
                }
              : null,
          isEnabled: isEnabled,
          gradient: AppTheme.enviarGradient,
        ),
      ),
    );
  }

  _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          recordedTimes: recordedTimes, // Passa a lista de tempos
          onConfirm: () async {
            await sendAllTimes();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tempos enviados com sucesso')),
            );
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  double parseTime(String time) {
    // Verifica se o tempo está no formato esperado "ss:ms"
    if (time.contains(':')) {
      final parts = time.split(':'); // Divide em ["ss", "ms"]
      final seconds = int.tryParse(parts[0]) ?? 0;
      final milliseconds = int.tryParse(parts[1]) ?? 0;

      // Converte para float: segundos + (milissegundos / 1000)
      return seconds + (milliseconds / 1000.0);
    }
    return 0.0; // Retorna 0.0 se o formato for inválido
  }

  Future<void> sendAllTimes() async {
    final token = user.token;
    final client = HttpClient();

    // for (var entry in recordedTimes) {
    //   final body = jsonEncode({
    //     'date_time': DateTime.now().toIso8601String(),
    //     'competition_id': widget.Competiotion.comp_id,
    //     'category_id': widget.Category.category_id,
    //     'time': double.tryParse(entry['time']) ?? 0.0,
    //   });
    //
    //   await client.post(
    //     url:
    //         '${Env.API_URL}/time_trials/${widget.timeTrial.id}',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': 'Bearer $token'
    //     },
    //     body: body,
    //   );
    // }
    print('recordedTimes');
    print(recordedTimes.length);
    print(recordedTimes[0]['time'].toString());
    print(recordedTimes[1]['time'].toString());
    print(recordedTimes[2]['time'].toString());

    final body = jsonEncode({
      'date_time': DateTime.now().toIso8601String(),
      'time1': parseTime(recordedTimes[0]['time'].toString()),
      'time2': parseTime(recordedTimes[1]['time'].toString()),
      'time3': parseTime(recordedTimes[2]['time'].toString()),
    });

    print('${Env.API_URL}/time_trials/${widget.timeTrial.id}');
    await client.put(
      url: '${Env.API_URL}/time_trials/${widget.timeTrial.id}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: body,
    );
  }
}
