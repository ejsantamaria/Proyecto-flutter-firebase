import 'dart:convert';

ScoreModel userFromJson(String str) => ScoreModel.fromJson(json.decode(str));

String scoreToJson(ScoreModel data) => json.encode(data.toJson());

class ScoreModel {
  ScoreModel({
        this.date,
        this.game,
        this.score,
        this.time,
        this.username,
        this.abandoned
      });

  String? username;
  String? date;
  String? game;
  int? score;
  String? time;
  bool? abandoned;

  factory ScoreModel.fromJson(Map<String, dynamic> json) => ScoreModel(
        date: json["date"],
        game: json["game"],
        score: json["score"],
        time: json["time"],
        username: json["username"],
        abandoned: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "game": game,
        "score": score,
        "time": time,
        "username": username,
        "abandoned": abandoned
      };
}
