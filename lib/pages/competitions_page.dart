import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/data/repository/competitions_repository.dart';
import 'package:app_jurados/pages/stores/competitions_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/sidebar_widget.dart'; // Make sure this import is correct

import '../data/provider/user_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/competition_item_widget.dart';

class CompetitionsPage extends StatefulWidget {
  const CompetitionsPage({super.key});

  @override
  State<CompetitionsPage> createState() => _CompetitionsPage();
}

class _CompetitionsPage extends State<CompetitionsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late CompetitionsStore store;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context, listen: false).user;

    store = CompetitionsStore(
      repository: CompetitionsRepository(
        client: HttpClient(),
        token: user!.token,
      ),
    );

    store.getCompetitions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const CustomSidebar(),
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey.shade900),
            image: const DecorationImage(
              image: AssetImage('image-removebg-preview.png'),
              scale: 2.5,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          'Meus Eventos',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            store.isLoading,
            store.erro,
            store.state,
          ]),
          builder: (context, child) {
            if (store.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (store.erro.value.isNotEmpty) {
              print('Erro ${store.erro.value}');
              return Center(
                child: Text(store.erro.value),
              );
            }
            if (store.state.value.isEmpty) {
              return const Center(
                child: Text('Nenhum dado encontrado'),
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
                  return CompetitionItemWidget(context: context, item: item);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
