import 'package:app_jurados/data/http/http_client.dart';
import 'package:app_jurados/data/repository/line_followers_repository.dart';
import 'package:app_jurados/pages/stores/line_followers_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineFollowersPage extends StatefulWidget{
  const LineFollowersPage({super.key});

  @override
  State<LineFollowersPage> createState() => _LineFollowersPage();
}

class _LineFollowersPage extends State<LineFollowersPage>{

  final LineFollowersStore store = LineFollowersStore(repository: LineFollowerRepository(client: HttpClient(),),);

  @override
  void initState(){
    super.initState();
    store.getLineFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          title: Text(item.lf_name),
                          subtitle: Text(item.lf_team_id.toString()),
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