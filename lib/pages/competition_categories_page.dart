import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/pages/stores/competition_categories_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/competitions_model.dart';
import '../data/provider/user_provider.dart';
import '../data/repository/categories_repository.dart';
import '../themes/app_theme.dart';
import '../widgets/categories_item_widget.dart';

class CompetitionCategoriesPage extends StatefulWidget {
  final CompetitionsModel competiotion_item;
  const CompetitionCategoriesPage({super.key, required this.competiotion_item});

  @override
  State<CompetitionCategoriesPage> createState() => _CompetitionPage();
}

class _CompetitionPage extends State<CompetitionCategoriesPage> {
  late CompetiotionCategoriesStore store;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context, listen: false).user;

    store = CompetiotionCategoriesStore(
      repository: CategoriesRepository(
        client: HttpClient(), token: user!.token,
      ),
    );

    store.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.grey[800],
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey.shade900),
            image: const DecorationImage(
              image: NetworkImage('https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          'Logged in as: ${user?.name}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: Theme.of(context).extension<GradientContainerTheme>()!.gradientDecoration!,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(30),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                      child:Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Container(
                                width: MediaQuery.of(context).size.width /2,
                                height: MediaQuery.of(context).size.height / 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: const DecorationImage(
                                    image: NetworkImage('https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(widget.competiotion_item.comp_name),
                              Text('Data: ${widget.competiotion_item.comp_date}'),
                              Text('Local: ${widget.competiotion_item.comp_adress_id.toString()}'),
                            ]
                        ),
                      ),
                  ),
                  Column( // Botão para voltar
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
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // O conteúdo da lista gerada agora está diretamente abaixo do Stack
              SizedBox(height: 20),
              AnimatedBuilder(
                animation: Listenable.merge([store.isLoading, store.erro, store.state]),
                builder: (context, child) {
                  if (store.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (store.erro.value.isNotEmpty) {
                    print('Erro ${store.erro.value}');
                    return Center(child: Text(store.erro.value));
                  }
                  if (store.state.value.isEmpty) {
                    return const Center(child: Text('Nenhum dado encontrado'));
                  } else {
                    // Usando List.generate para criar os itens
                    return Column(
                      children: List.generate(store.state.value.length, (index) {
                        final item = store.state.value[index];
                        return Column(
                          children: [
                            CategoryItemWidget(item: item, context: context),
                            const SizedBox(height: 32), // Espaço entre os itens
                          ],
                        );
                      }),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),

    );
  }

}
