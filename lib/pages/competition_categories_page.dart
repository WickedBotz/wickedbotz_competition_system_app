import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/pages/stores/competition_categories_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/competitions_model.dart';
import '../data/provider/user_provider.dart';
import '../data/repository/categories_repository.dart';
import '../themes/app_theme.dart';
import '../widgets/categories_item_widget.dart';
import '../widgets/sidebar_widget.dart'; 

class CompetitionCategoriesPage extends StatefulWidget {
  final CompetitionsModel competiotion_item;
  const CompetitionCategoriesPage({super.key, required this.competiotion_item});

  @override
  State<CompetitionCategoriesPage> createState() => _CompetitionPage();
}

class _CompetitionPage extends State<CompetitionCategoriesPage> {
  late CompetiotionCategoriesStore store;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        client: HttpClient(),
        token: user!.token,
      ),
    );

    store.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomSidebar(),
      appBar: AppBar(
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
            onPressed: () => {
              _scaffoldKey.currentState!.openEndDrawer()
            },
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: Theme.of(context)
              .extension<GradientContainerTheme>()!
              .gradientDecoration!,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff245C6B), Color(0xff0CFFFD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height /
                          4.7, // Aumentar a altura do fundo cinza
                      padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 80,
                          bottom: 16), // Ajustar espaçamento interno
                      color: Colors.grey[850],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 7),
                          Text(
                            widget.competiotion_item.comp_name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  5), // Aumentar espaço entre título e informações
                          Text(
                            'Data: ${widget.competiotion_item.comp_date}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Local: ${widget.competiotion_item.comp_adress_id.toString()}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height *
                        0.03, // Ajuste para mover a imagem mais acima
                    left: MediaQuery.of(context).size.width * 0.03,
                    child: Container(
                      width: MediaQuery.of(context).size.width /
                          2.5, // Diminuir o tamanho da imagem
                      height: MediaQuery.of(context).size.height /
                          5.5, // Diminuir a altura da imagem
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: Listenable.merge(
                    [store.isLoading, store.erro, store.state]),
                builder: (context, child) {
                  if (store.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (store.erro.value.isNotEmpty) {
                    return Center(child: Text(store.erro.value));
                  }
                  if (store.state.value.isEmpty) {
                    return const Center(child: Text('Nenhum dado encontrado'));
                  } else {
                    // Envolvendo a lista com um Container para aplicar o estilo
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                      color: Colors.grey[850], // Aplicando uma cor de fundo
                      borderRadius: BorderRadius.circular(
                        10.0), // Aplicando bordas arredondadas
                      ),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                        'Categorias',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                        children:
                          List.generate(store.state.value.length, (index) {
                          final item = store.state.value[index];
                          return Column(
                          children: [
                            CategoryItemWidget(
                              item: item,
                              competition: widget.competiotion_item),
                            const SizedBox(height: 24),
                          ],
                          );
                        }),
                        ),
                      ],
                      ),
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
}
