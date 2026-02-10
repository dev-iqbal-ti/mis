import 'dart:convert';

List<EquipmentModel> equipmentModelFromJson(String str) =>
    List<EquipmentModel>.from(
      json.decode(str).map((x) => EquipmentModel.fromJson(x)),
    );

String equipmentModelToJson(List<EquipmentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EquipmentModel {
  final int id;
  final String name;
  final int? assignedTo;
  final DateTime createdAt;
  final String? assignedName;

  EquipmentModel({
    required this.id,
    required this.name,
    required this.assignedTo,
    required this.createdAt,
    required this.assignedName,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) => EquipmentModel(
    id: json["id"],
    name: json["name"],
    assignedTo: json["assigned_to"],
    createdAt: DateTime.parse(json["created_at"]),
    assignedName: json["assigned_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "assigned_to": assignedTo,
    "created_at": createdAt.toIso8601String(),
    "assigned_name": assignedName,
  };
}
