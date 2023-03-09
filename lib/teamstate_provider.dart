// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:readyfc_app/player_model.dart';
// import 'package:readyfc_app/teamdata.dart';

// final teamStateProvider = ChangeNotifierProvider((ref) => TeamStateProvider());

// class TeamStateProvider extends ChangeNotifier {
//   Map<String, List<Map<String, dynamic>>> dataLocal = dataTeam;
//   List<Team> _teams = [];
//   List<Team> get teams => _teams;
//   List<Player> _players = [];
//   List<Player> get players => _players;
//   void addTeam(Team team) {
//     _teams.add(team);
//     notifyListeners();
//   }

//   void changeStatusPlay(int index, String vitri) {
//     dataLocal[vitri]?[index]['isPlay'].value =
//         !dataLocal[vitri]?[index]['isPlay'].value;
//     notifyListeners();
//   }

//   void removeTeam(Team team) {
//     _teams.remove(team);
//     notifyListeners();
//   }

//   void addPlayer(Player player) {
//     _players.add(player);
//     notifyListeners();
//   }

//   void randomTeam(int teamCount) {
//     _teams = [];
//     for (int i = 0; i < teamCount; i++) {
//       _teams.add(Team(name: 'Team ${i + 1}', players: [], totalPoint: 0));
//     }
//     print('random team=========================$_teams');
//     notifyListeners();
//   }
// }
