import 'dart:convert';
import 'package:app_jurados/components/ConfirmDialog.dart';
import 'package:app_jurados/components/RobotInfoCard.dart';
import 'package:app_jurados/components/LapInputCard.dart';

import '../components/ButtonGradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/http/http_client.dart';
import '../data/models/category_time_trial_model.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
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
  final List<TextEditingController> timeControllers = List.generate(
      3, (_) => TextEditingController()); // Para 3 voltas
  final List<TextEditingController> pointsControllers = List.generate(
      3, (_) => TextEditingController()); // Para 3 voltas

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user!;
    print('CategoryTimeTrialModel: ${widget.timeTrial}');
  }

  @override
  void dispose() {
    for (var controller in timeControllers) {
      controller.dispose();
    }
    for (var controller in pointsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const CustomSidebar(),
      appBar: buildAppBar(context, _scaffoldKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            buildInfoContainer(),
            const SizedBox(height: 20),
            buildLapInputCards(),
            const SizedBox(height: 20),
            ButtonGradient(
              text: 'Enviar',
              onPressed: () async {
                FocusScope.of(context).unfocus();
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
    return RobotInfoCard(
      robotName: widget.timeTrial.robot_name,
      imageUrl:
          'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
    );
  }

  Widget buildLapInputCards() {
    return Column(
      children: List.generate(3, (index) {
        return LapInputCard(
          title: 'Volta ${index + 1}',
          timeController: timeControllers[index],
          pointsController: pointsControllers[index],
        );
      }),
    );
  }

  Future<void> _showConfirmationDialog() async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Volta ${index + 1}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Tempo: ${timeControllers[index].text}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Pontos: ${pointsControllers[index].text}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Divider(),
              ],
            );
          }),
        ),
        onConfirm: () async {
          final sent = await sendFormValues();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(sent
                    ? 'Dados Enviados com Sucesso'
                    : 'Erro ao enviar os dados')),
          );
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

    final dataToSend = List.generate(3, (index) {
      return {
        'time': double.tryParse(timeControllers[index].text) ?? 0.0,
        'points': int.tryParse(pointsControllers[index].text) ?? 0,
        'is_valid': true,
      };
    });

    final body = jsonEncode({
      'date_time': DateTime.now().toIso8601String(),
      'competition_id': widget.Competiotion.comp_id,
      'category_id': widget.Category.category_id,
      'robot_id': widget.timeTrial.robot_id,
      'time_trials': dataToSend,
    });

    final response = await client.post(
      url:
          'localhost/time_trials',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: body,
    );

    return response.statusCode == 201;
  }
}
