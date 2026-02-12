import 'dart:convert';

List<Employees> employeesFromJson(String str) =>
    List<Employees>.from(json.decode(str).map((x) => Employees.fromJson(x)));

String employeesToJson(List<Employees> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employees {
  final int id;
  final String name;

  Employees({required this.id, required this.name});

  factory Employees.fromJson(Map<String, dynamic> json) =>
      Employees(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
