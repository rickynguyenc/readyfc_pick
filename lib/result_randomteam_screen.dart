import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:readyfc_app/player_model.dart';

class ResultRandomTeam extends StatefulWidget {
  const ResultRandomTeam({super.key});

  @override
  State<ResultRandomTeam> createState() => _ResultRandomTeamState();
}

class _ResultRandomTeamState extends State<ResultRandomTeam> {
  final TextEditingController _txtCoutTeamController =
      TextEditingController(text: '0');
  List<Team> _teams = [];
  List<Team> _teamsCache = [];

  // get data from parameter
  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> dataReceive =
        ModalRoute.of(context)?.settings.arguments
            as Map<String, List<Map<String, dynamic>>>;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Chia đội'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Số đội: '),
                Expanded(
                  child: TextField(
                    controller: _txtCoutTeamController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nhập số đội',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // result button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    randomTeam(dataReceive);
                  },
                  child: Text('Thực hiện'),
                ),
              ),
            ],
          ),

          Row(
            children: [
              ..._teams.map((e) {
                return Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(e.name ?? ''),
                      Text(e.totalPoint.toString()),
                      ...e.players?.map((e) {
                            return Container(
                              child: Text(e.name ?? ''),
                            );
                          }).toList() ??
                          [],
                    ],
                  ),
                );
              }).toList()
            ],
          )
        ],
      ),
    );
  }

  randomTeam(Map<String, List<Map<String, dynamic>>> dataAllVitri) {
    _teamsCache = [];
    _teams = [];
    for (int i = 0; i < int.parse(_txtCoutTeamController.text); i++) {
      _teamsCache.add(Team(name: 'Team ${i + 1}', players: [], totalPoint: 0));
    }
    // Lấy hậu vệ
    getRandom(dataAllVitri['hauve'] ?? []);
    print('hau ve=========================${_teamsCache[0]}');
    getRandom(dataAllVitri['tienve'] ?? []);
    getRandom(dataAllVitri['tiendao'] ?? []);
    getRandom(dataAllVitri['thumon'] ?? []);
    setState(() {
      _teams = _teamsCache;
    });
    // Lấy tiền vệ
    // Lấy tiền đạo
    // Lấy thủ môn
  }

  // genarate function return 2 number random in range 0 to dataAllVitri['hauve'].length
  getRandom(List<Map<String, dynamic>> dataAllVitri) {
    for (var e in _teamsCache) {
      if (dataAllVitri.length < 2) {
        for (var element in dataAllVitri) {
          e.players?.add(Player(
              name: element['name'], stat: element['stat'], isPlay: true));
        }
      } else {
        int random1 = 0;
        int random2 = 0;
        while (random1 == random2) {
          Random randomo = new Random();
          random1 = randomo.nextInt(dataAllVitri.length);
          Random randomt = new Random();
          random2 = randomt.nextInt(dataAllVitri.length);
        }
        var twoPlayer = [
          Player(
              name: dataAllVitri[random1]['name'],
              stat: dataAllVitri[random1]['stat'],
              isPlay: true),
          Player(
              name: dataAllVitri[random2]['name'],
              stat: dataAllVitri[random2]['stat'],
              isPlay: true)
        ];
        e.totalPoint = twoPlayer[0].stat! + twoPlayer[1].stat!;
        print('total point: ${e.totalPoint}');
        dataAllVitri.removeAt(random1);
        if (0 < random2) {
          dataAllVitri.removeAt(random2 - 1);
        } else {
          dataAllVitri.removeAt(random2);
        }
        e.players?.addAll(twoPlayer);
      }
    }
  }
}
