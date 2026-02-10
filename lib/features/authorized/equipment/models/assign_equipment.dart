import 'dart:convert';

List<AssignEquipment> assignEquipmentFromJson(String str) =>
    List<AssignEquipment>.from(
      json.decode(str).map((x) => AssignEquipment.fromJson(x)),
    );

String assignEquipmentToJson(List<AssignEquipment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AssignEquipment {
  final int assignmentId;
  final int equipmentId;
  final String equipmentName;
  final int userId;
  final String userName;
  final DateTime assignDate;
  final String assignRemark;
  final String assignPhoto;
  final String projectOrLocation;
  final String? submitRemark;
  final String? submitPhoto;
  final DateTime? submitDate;

  AssignEquipment({
    required this.assignmentId,
    required this.equipmentId,
    required this.equipmentName,
    required this.userId,
    required this.userName,
    required this.assignDate,
    required this.assignRemark,
    required this.assignPhoto,
    required this.projectOrLocation,
    required this.submitRemark,
    required this.submitPhoto,
    required this.submitDate,
  });

  factory AssignEquipment.fromJson(Map<String, dynamic> json) =>
      AssignEquipment(
        assignmentId: json["assignment_id"],
        equipmentId: json["equipment_id"],
        equipmentName: json["equipment_name"],
        userId: json["user_id"],
        userName: json["user_name"],
        assignDate: DateTime.parse(json["assign_date"]),
        assignRemark: json["assign_remark"],
        assignPhoto: json["assign_photo"],
        projectOrLocation: json["project_or_location"],
        submitRemark: json["submit_remark"],
        submitPhoto: json["submit_photo"],
        submitDate: json["submit_date"] == null
            ? null
            : DateTime.parse(json["submit_date"]),
      );

  Map<String, dynamic> toJson() => {
    "assignment_id": assignmentId,
    "equipment_id": equipmentId,
    "equipment_name": equipmentName,
    "user_id": userId,
    "user_name": userName,
    "assign_date": assignDate.toIso8601String(),
    "assign_remark": assignRemark,
    "assign_photo": assignPhoto,
    "project_or_location": projectOrLocation,
    "submit_remark": submitRemark,
    "submit_photo": submitPhoto,
    "submit_date": submitDate?.toIso8601String(),
  };
}
