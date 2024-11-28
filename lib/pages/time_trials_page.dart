import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/pages/stores/category_time_trial_store.dart';
import 'package:app_jurados/pages/tracking_time_trial_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/categoties_model.dart';
import '../data/models/competitions_model.dart';
import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import '../data/repository/category_time_trial_repository.dart';
import 'line_follower_time_trial_page.dart';
import '../widgets/sidebar_widget.dart';

class TimeTrialsPage extends StatefulWidget {
  final CategoriesModel Category;
  final CompetitionsModel Competiotion;
  const TimeTrialsPage({super.key, required this.Category, required this.Competiotion});

  @override
  State<TimeTrialsPage> createState() => _TimeTrialsPage();
}

class _TimeTrialsPage extends State<TimeTrialsPage> {
  late CategoryTimeTrialStore store;
  late UserModel user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

    store = CategoryTimeTrialStore(
      repository: CategoryTimeTrialRepository(
        client: HttpClient(), category_id: widget.Category.category_id, token: user.token,
      ),
    );

    store.getRobotsTimeTrial(category_id: widget.Category.category_id);
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
            style: const TextStyle(fontSize: 25, color: Colors.white70),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Nome do robô ou equipe',
                hintStyle: const TextStyle(fontSize: 16, color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) => _onSearchChanged(),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: Listenable.merge([store.isLoading, store.erro, store.state]),
              builder: (context, child) {
                if (store.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (store.erro.value.isNotEmpty) {
                  return Center(
                    child: Text(store.erro.value),
                  );
                }
                if (store.state.value.isEmpty) {
                  return const Center(
                    child: Text('Nenhum dado encontrado'),
                  );
                }

                // Filtragem dos itens de acordo com o texto da busca
                final filteredItems = store.state.value.where((item) {
                  final robotNames = item.robot_name.toLowerCase();
                  final teamNames = item.team_name.toLowerCase();
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
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.white54,
                        height: 1,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (_, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                          title: Text(
                            item.robot_name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white54,
                          ),
                          onTap: () {
                            if (widget.Category.category_id == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LineFollowerTimeTrialPage(
                                    timeTrial: item,
                                    Competiotion: widget.Competiotion,
                                    Category: widget.Category,
                                  ),
                                ),
                              );
                            }
                            if (widget.Category.category_id == 4) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackingTimeTrialPage(
                                    timeTrial: item,
                                    Competiotion: widget.Competiotion,
                                    Category: widget.Category,
                                  ),
                                ),
                              );
                            }
                          },
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
