// To parse this JSON data, do
//
//     final compOff = compOffFromJson(jsonString);

import 'dart:convert';

List<CompOff> compOffFromJson(String str) =>
    List<CompOff>.from(json.decode(str).map((x) => CompOff.fromJson(x)));

String compOffToJson(List<CompOff> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompOff {
  final int userId;
  final DateTime date;

  CompOff({required this.userId, required this.date});

  factory CompOff.fromJson(Map<String, dynamic> json) =>
      CompOff(userId: json["user_id"], date: DateTime.parse(json["date"]));

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "date": date.toIso8601String(),
  };
}
