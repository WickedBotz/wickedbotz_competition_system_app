import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/data/repository/category_match_repository.dart';
import '../components/SearchField.dart';
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
import '../widgets/sidebar_widget.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  final FocusNode focusNode = FocusNode();

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
      key: _scaffoldKey,
      endDrawer: const CustomSidebar(),
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
            onPressed: () => {_scaffoldKey.currentState!.openEndDrawer()},
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Categoria: ${widget.Category.category_name}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: SearchField(
              controller: searchController,
              focusNode: focusNode,
              onChanged: _onSearchChanged,
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
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListView.builder(
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
                              ).then((_) {
                                store.getRobotsMatch(category_id: widget.Category.category_id);
                              });
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
                              ).then((_) {
                                store.getRobotsMatch(category_id: widget.Category.category_id);
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.robot_1_name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      const Divider(color: Colors.white54, height: 1),
                                      const SizedBox(height: 3),
                                      Text(
                                        item.robot_2_name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
