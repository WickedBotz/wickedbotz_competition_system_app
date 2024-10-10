import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/data/repository/competitions_repository.dart';
import 'package:app_jurados/pages/stores/competitions_store.dart';
import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import '../widgets/competition_item_widget.dart';

class CompetitionsPage extends StatefulWidget {
  const CompetitionsPage({super.key});

  @override
  State<CompetitionsPage> createState() => _CompetitionsPage();
}

class _CompetitionsPage extends State<CompetitionsPage> {
  final CompetitionsStore store = CompetitionsStore(
    repository: CompetitionsRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getCompetitions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.grey[800],
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey.shade900),
            //shape: BoxShape.circle,
            image: const DecorationImage(
              // improvisado, substiuir quando atualizar DB da API
              image: NetworkImage('https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text('WickedBotz',
          style: Theme.of(context).textTheme.titleMedium
          ,
        ),
        actions: [
          IconButton(onPressed: () => {}, icon:  const Icon(Icons.menu, color: Colors.white,))
        ],
      ),
      body: Container(
        // Aqui, você define o gradiente
        decoration: Theme.of(context).extension<GradientContainerTheme>()!.gradientDecoration!,
        child: AnimatedBuilder(
            animation: Listenable.merge([
              store.isLoading,
              store.erro,
              store.state,
            ]),
            builder: (context, child) {
              if (store.isLoading.value) {
                return const CircularProgressIndicator();
              }
              if (store.erro.value.isNotEmpty) {
                print('Erro');
                return Center(
                  child: Text(store.erro.value),
                );
              }
              if (store.state.value.isEmpty) {
                return const Center(
                  child: Text('Nemhum dado encontrado'),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 32,
                  ),
                  padding: const EdgeInsets.all(16),
                  itemCount: store.state.value.length,
                  itemBuilder: (_, index) {
                    final item = store.state.value[index];
                    return CompetitionItemWidget(item: item);
                  },
                );
              }
            }),
      ),
    );
  }
}
