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
  List<Map<String, dynamic>> _dataAllPlayerLeft = [];

  // get data from parameter
  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> dataReceive =
        ModalRoute.of(context)?.settings.arguments
            as Map<String, List<Map<String, dynamic>>>;
    // get method of _dataReceive
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
                    var dataClone = dataReceive;
                    randomTeam(dataClone);
                  },
                  child: Text('Thực hiện'),
                ),
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._teams.map((e) {
                return Expanded(
                  child: Container(
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
    getRandom(dataAllVitri['hauve'] ?? [], 2);
    _dataAllPlayerLeft.addAll(dataAllVitri['hauve'] ?? []);
    getRandom(dataAllVitri['tienve'] ?? [], 2);
    _dataAllPlayerLeft.addAll(dataAllVitri['tienve'] ?? []);

    getRandom(dataAllVitri['tiendao'] ?? [], 2);
    _dataAllPlayerLeft.addAll(dataAllVitri['tiendao'] ?? []);

    getRandom(dataAllVitri['thumon'] ?? [], 1);
    setState(() {
      _teams = _teamsCache;
    });
    // Lấy tiền vệ
    // Lấy tiền đạo
    // Lấy thủ môn
  }

  // genarate function return 2 number random in range 0 to dataAllVitri['hauve'].length
  getRandom(List<Map<String, dynamic>> dataAllVitri, int numberGet) {
    List<int> scores = [];
    // Lấy ds điểm của các đội
    for (var element in _teamsCache) {
      scores.add(element.totalPoint ?? 0);
    }
    // Add player vào các đội
    for (var e in _teamsCache) {
      if (dataAllVitri.length < numberGet) {
        for (var element in dataAllVitri) {
          e.players?.add(Player(
              name: element['name'], stat: element['stat'], isPlay: true));
          e.totalPoint = (e.totalPoint! + element['stat']) as int?;
        }
        dataAllVitri = [];
      } else {
        if (numberGet == 1) {
          while (e.players!.length < 6 && _dataAllPlayerLeft.isNotEmpty) {
            Random randomo = new Random();
            int random1 = randomo.nextInt(_dataAllPlayerLeft.length);
            e.players?.add(Player(
                name: _dataAllPlayerLeft[random1]['name'],
                stat: _dataAllPlayerLeft[random1]['stat'],
                isPlay: true));
            e.totalPoint =
                (e.totalPoint! + _dataAllPlayerLeft[random1]['stat']) as int?;
            _dataAllPlayerLeft.removeAt(random1);
          }
          Random randomo = new Random();
          int random1 = randomo.nextInt(dataAllVitri.length);
          e.players?.add(Player(
              name: dataAllVitri[random1]['name'],
              stat: dataAllVitri[random1]['stat'],
              isPlay: true));
          e.totalPoint =
              (e.totalPoint! + dataAllVitri[random1]['stat']) as int?;
          dataAllVitri.removeAt(random1);
          continue;
        }
        // var _playerAI = getPlayerBonus(scores, e.totalPoint ?? 0, dataAllVitri);
        // if (_playerAI != null) {
        //   // TODO: add player to team
        //   continue;
        // }

        // Bằng null thì random
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
        e.totalPoint = e.totalPoint! + twoPlayer[0].stat! + twoPlayer[1].stat!;

        dataAllVitri.removeAt(random1);
        if (0 < random2 && random2 > random1) {
          dataAllVitri.removeAt(random2 - 1);
        } else {
          dataAllVitri.removeAt(random2);
        }
        e.players?.addAll(twoPlayer);
      }
    }
  }

  getPlayerBonus(
      List<int> scores, int thisScore, List<Map<String, dynamic>> dataPlayers) {
    // get int max in scores
    var avgScore = getAvgScores(scores);
    var deltaPoint = thisScore - avgScore;
    var avgPlayer = getAvgStatdataPlayers(dataPlayers);
    var _playerResult = dataPlayers[0];
    var deltaPlayer = (_playerResult['stat'] - avgPlayer).abs();
    if (deltaPoint == 0) return null;
    // get absolute value
    if (deltaPoint > 0) {
      for (var e in dataPlayers) {
        if ((e['stat'] < _playerResult['stat']) &&
            (e['stat'] < avgPlayer) &&
            (e['stat'] - avgPlayer).abs() < deltaPlayer) {
          _playerResult = e;
          deltaPlayer = (e['stat'] - avgPlayer).abs();
        }
      }
    } else {
      for (var e in dataPlayers) {
        if ((e['stat'] > _playerResult['stat']) &&
            (e['stat'] > avgPlayer) &&
            (e['stat'] - avgPlayer).abs() < deltaPlayer) {
          _playerResult = e;
          deltaPlayer = (e['stat'] - avgPlayer).abs();
        }
      }
    }

    return _playerResult;
  }

  getAvgStatdataPlayers(List<Map<String, dynamic>> dataPlayers) {
    int sum = 0;
    for (var e in dataPlayers) {
      sum += e['stat'] as int;
    }
    return sum / dataPlayers.length;
  }

  getAvgScores(List<int> scores) {
    int sum = 0;
    for (var e in scores) {
      sum += e;
    }
    return sum / scores.length;
  }
}
