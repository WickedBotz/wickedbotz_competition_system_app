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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController timeTrialController = TextEditingController();
  bool isValidTimeTrial = false;
  List<Map<String, dynamic>> recordedTimes = [];

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
              recordedTimes.length == 3 ? buildSendButton() : Container(),
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

  Widget buildInfoContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Robô: ${widget.timeTrial.robot_name}',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Equipe: ${widget.timeTrial.team_name}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage(
                    'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.grey.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeTrialFields() {
    return recordedTimes.length < 3
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: timeTrialController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                  ],
                  cursorColor: Colors.grey,  // Cursor de escrita em cinza
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    icon: const Icon(Icons.timer_outlined, color: Colors.white70),
                    hintText: '00:00:00',
                    hintStyle: const TextStyle(fontSize: 16, color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && recordedTimes.length < 3) {
                    setState(() {
                      recordedTimes.add({
                        'time': timeTrialController.text,
                        'isValid': isValidTimeTrial,
                      });
                      timeTrialController.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          )
        : Container();
  }

  List<Widget> buildRecordedTimes() {
    return recordedTimes.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tempo: ${item['time']}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                  onPressed: () {
                    timeTrialController.text = item['time'];
                    setState(() {
                      recordedTimes.removeAt(index);
                    });
                  },
                ),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget buildSendButton() {
    return ElevatedButton(
      onPressed: () async {
        _showConfirmationDialog();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Deixa o botão menos arredondado
        ),
      ),
      child: const Text(
        'Enviar Tempos',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    bool confirmSend = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Confirmar envio dos tempos?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var entry in recordedTimes)
                  Column(
                    children: [
                      Text('Tempo: ${entry['time']}'),
                      const SizedBox(height: 10),
                    ],
                  ),
                Row(
                  children: [
                    Checkbox(
                      value: confirmSend,
                      activeColor: Colors.green,
                      onChanged: (value) => setState(() => confirmSend = value!),
                    ),
                    const Text('Confirmar'),
                  ],
                ),
              ],
            ),
            actions: [
              BuildGradientButtonWidget(
                text: 'Enviar',
                onPressed: () {
                  if (confirmSend) {
                    sendAllTimes();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dados enviados com sucesso')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Confirme os valores')),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              BuildGradientButtonWidget(
                text: 'Cancelar',
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Envio cancelado')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> sendAllTimes() async {
    final token = user.token;
    final client = HttpClient();

    for (var entry in recordedTimes) {
      final body = jsonEncode({
        'date_time': DateTime.now().toIso8601String(),
        'competition_id': widget.Competiotion.comp_id,
        'category_id': widget.Category.category_id,
        'time': double.tryParse(entry['time']) ?? 0.0,
        'robot_id': widget.timeTrial.robot_id,
      });

      await client.post(
        url: 'http://localhost:5000/time_trials',
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: body,
      );
    }
  }
}
