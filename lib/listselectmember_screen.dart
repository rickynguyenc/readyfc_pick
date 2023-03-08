import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:readyfc_app/player_model.dart';
import 'package:readyfc_app/teamdata.dart';
import 'package:readyfc_app/teamstate_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ListMemberScreen extends StatefulWidget {
  const ListMemberScreen({super.key});

  @override
  State<ListMemberScreen> createState() => _ListMemberScreenState();
}

class _ListMemberScreenState extends State<ListMemberScreen> {
  @override
  Widget build(BuildContext context) {
    final dataWatch =
        ref.watch(teamStateProvider.select((value) => value.dataLocal));
    int idex = 0;
    List<Widget> chooseMember(String type) {
      return dataWatch[type]?.map(
            (e) {
              idex++;
              return Container(
                child: ListTile(
                  title: Text(e['name'].toString()),
                  subtitle: Text(e['stat'].toString()),
                  leading: Icon(Icons.person),
                  trailing: Checkbox(
                    value: e['isPlay'],
                    onChanged: (value) {
                      teamNotifier.changeStatusPlay(idex, type);
                      // add player by addPlayer function in teamstate_provider.dart
                      teamNotifier.addPlayer(Player(
                          name: e['name'], stat: e['stat'], isPlay: value));
                    },
                  ),
                ),
              );
            },
          ).toList() ??
          [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sach cau thu'),
      ),
      body: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text('Hau ve'),
                    ),
                    ...chooseMember('hauve'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text('Tien dao'),
                    ),
                    ...chooseMember('tiendao'),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text('Tien ve'),
                    ),
                    ...chooseMember('tienve'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text('Thu mon'),
                    ),
                    ...chooseMember('thumon'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          teamNotifier.randomTeam(2);
        },
        child: Container(
          width: 200,
          child: Text('Chia đội'),
        ),
      ),
    );
  }
}
