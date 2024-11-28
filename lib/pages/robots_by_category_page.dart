import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/data/repository/robots_by_category_repository.dart';
import 'package:app_jurados/pages/stores/robots_by_category_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/sidebar_widget.dart'; 

import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';

class RobotsByCategoryPage extends StatefulWidget{
  final int category_id;
  const RobotsByCategoryPage({super.key, required this.category_id});

  @override
  State<RobotsByCategoryPage> createState() => _RobotsByCategoryPage();
}

class _RobotsByCategoryPage extends State<RobotsByCategoryPage>{

  late RobotsByCategoryStore store;
  late UserModel user;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    print('category_id: ${widget.category_id}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    user = Provider.of<UserProvider>(context, listen: false).user!;

    store = RobotsByCategoryStore(
      repository: RobotsByCategoryRepository(
        client: HttpClient(), token: user.token,
      ),
    );

    store.getRobotsByCategory(category_id: widget.category_id);
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
            onPressed: () => {
              _scaffoldKey.currentState!.openEndDrawer()
            },
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: AnimatedBuilder(
          animation: Listenable.merge([
            store.isLoading,
            store.erro,
            store.state,
          ]),
          builder: (context, child) {
            if(store.isLoading.value){
              return const CircularProgressIndicator();
            }
            if(store.erro.value.isNotEmpty){
              print('Erro');
              return Center(
                child: Text(store.erro.value),
              );
            }
            if(store.state.value.isEmpty){
              return const Center(
                child: Text('Nemhum dado encontrado'),
              );
            }else{
              print('Loaded');
              return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 32,
                  ),
                  padding: const EdgeInsets.all(16),
                  itemCount: store.state.value.length,
                  itemBuilder: (_, index){
                    final item = store.state.value[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.robot_name),
                          subtitle: Text('Team id: ${item.robot_team_id.toString()}'),
                        ),

                      ],
                    );
                  },
              );
            }
          }),
    );
  }
  
}