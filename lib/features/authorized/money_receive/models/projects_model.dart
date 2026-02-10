// To parse this JSON data, do
//
//     final projectsModel = projectsModelFromJson(jsonString);

import 'dart:convert';

List<ProjectsModel> projectsModelFromJson(String str) =>
    List<ProjectsModel>.from(
      json.decode(str).map((x) => ProjectsModel.fromJson(x)),
    );

String projectsModelToJson(List<ProjectsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectsModel {
  final int id;
  final String name;

  ProjectsModel({required this.id, required this.name});

  factory ProjectsModel.fromJson(Map<String, dynamic> json) =>
      ProjectsModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
