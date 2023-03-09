class Player {
  String? name;
  int? stat;
  bool? isPlay;

  Player({this.name, this.stat, this.isPlay});

  Player.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    stat = json['stat'];
    isPlay = json['isPlay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['stat'] = this.stat;
    data['isPlay'] = this.isPlay;
    return data;
  }
}

// genarate class TEam have properties: name, players, totalPoint
class Team {
  String? name;
  List<Player>? players;
  int? totalPoint;

  Team({this.name, this.players, this.totalPoint});

  Team.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['players'] != null) {
      players = <Player>[];
      json['players'].forEach((v) {
        players!.add(new Player.fromJson(v));
      });
    }
    totalPoint = json['totalPoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.players != null) {
      data['players'] = this.players!.map((v) => v.toJson()).toList();
    }
    data['totalPoint'] = this.totalPoint;
    return data;
  }
}
