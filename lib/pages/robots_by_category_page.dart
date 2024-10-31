import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/data/repository/robots_by_category_repository.dart';
import 'package:app_jurados/pages/stores/robots_by_category_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        client: HttpClient(), token: user!.token,
      ),
    );

    store.getRobotsByCategory(category_id: widget.category_id);
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
          'Logged in as: ${user?.name}',
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          //child: Image.network(item.lf_photo),
                          child: Image.network('https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
                        ),
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