// To parse this JSON data, do
//
//     final leaveCategory = leaveCategoryFromJson(jsonString);

import 'dart:convert';

List<LeaveCategory> leaveCategoryFromJson(String str) =>
    List<LeaveCategory>.from(
      json.decode(str).map((x) => LeaveCategory.fromJson(x)),
    );

String leaveCategoryToJson(List<LeaveCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveCategory {
  final int id;
  final String name;
  final int isActive;

  LeaveCategory({required this.id, required this.name, required this.isActive});

  factory LeaveCategory.fromJson(Map<String, dynamic> json) => LeaveCategory(
    id: json["id"],
    name: json["name"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "is_active": isActive,
  };
}
