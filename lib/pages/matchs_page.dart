import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/data/repository/category_match_repository.dart';
import 'package:app_jurados/pages/pursuit_race_page.dart';
import 'package:app_jurados/pages/stores/category_match_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import 'combat_page.dart';

class MatchsPage extends StatefulWidget {
  final CategoriesModel Category;
  final CompetitionsModel Competiotion;
  const MatchsPage({super.key, required this.Category, required this.Competiotion});

  @override
  State<MatchsPage> createState() => _MatchsPage();
}

class _MatchsPage extends State<MatchsPage> {
  late CategoryMatchStore store;
  late UserModel user;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    print('category_id: ${widget.Category.category_id}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    user = Provider.of<UserProvider>(context, listen: false).user!;

    store = CategoryMatchStore(
      repository: CategoryMatchRepository(
        client: HttpClient(), category_id: widget.Category.category_id, token: user.token,
      ),
    );

    store.getRobotsMatch(category_id: widget.Category.category_id);
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
    });
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
            image: const DecorationImage(
              image: NetworkImage('https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Text('Categoria: ${widget.Category.category_name}',
            style: TextStyle(fontSize: 25),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Nome do robô ou equipe',
                hintStyle: TextStyle(fontSize: 16),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (text) => _onSearchChanged(),
            ),
          ),
          Expanded(
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
                  return Center(
                    child: Text(store.erro.value),
                  );
                }

                // Filtragem dos itens de acordo com o texto da busca
                final filteredItems = store.state.value.where((item) {
                  final robotNames = '${item.robot_1_name} ${item.robot_2_name}'.toLowerCase();
                  final teamNames = '${item.team_1_name} ${item.team_2_name}'.toLowerCase();
                  return robotNames.contains(searchQuery) || teamNames.contains(searchQuery);
                }).toList();

                if (filteredItems.isEmpty) {
                  return const Center(
                    child: Text('Nenhum dado encontrado'),
                  );
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 32,
                    ),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (_, index) {
                      final item = filteredItems[index];
                      return GestureDetector(
                        onTap: () {
                          if (widget.Category.category_id == 2 || widget.Category.category_id == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PursuitMatchPage(
                                  Match: item,
                                  Competiotion: widget.Competiotion,
                                  Category: widget.Category,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CombatMatchPage(
                                  Match: item,
                                  Competiotion: widget.Competiotion,
                                  Category: widget.Category,
                                ),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill',
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Robots: ${item.robot_1_name} X ${item.robot_2_name}'),
                              subtitle: Text('Teams: ${item.team_1_name} / ${item.team_2_name}'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}