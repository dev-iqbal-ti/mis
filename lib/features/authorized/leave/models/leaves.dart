import 'dart:convert';

List<Leaves> leavesFromJson(String str) =>
    List<Leaves>.from(json.decode(str).map((x) => Leaves.fromJson(x)));

String leavesToJson(List<Leaves> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Leaves {
  final String empId;
  final String empName;
  final String reportingManagerName;
  final String type;
  final int id;
  final int userId;
  final int leaveTypeId;
  final DateTime fromDate;
  final DateTime toDate;
  final double duration;
  final String status;
  final String reason;
  final DateTime appliedOn;
  final int isHalfDay;
  final dynamic leaveShift;
  final DateTime createdAt;
  final dynamic updatedAt;
  final String leaveDurationType;

  Leaves({
    required this.empId,
    required this.empName,
    required this.reportingManagerName,
    required this.type,
    required this.id,
    required this.userId,
    required this.leaveTypeId,
    required this.fromDate,
    required this.toDate,
    required this.duration,
    required this.status,
    required this.reason,
    required this.appliedOn,
    required this.isHalfDay,
    required this.leaveShift,
    required this.createdAt,
    required this.updatedAt,
    required this.leaveDurationType,
  });

  factory Leaves.fromJson(Map<String, dynamic> json) => Leaves(
    empId: json["emp_id"],
    empName: json["emp_name"],
    reportingManagerName: json["reporting_manager_name"],
    type: json["type"],
    id: json["id"],
    userId: json["user_id"],
    leaveTypeId: json["leave_type_id"],
    fromDate: DateTime.parse(json["from_date"]),
    toDate: DateTime.parse(json["to_date"]),
    duration: json["duration"]?.toDouble(),
    status: json["status"],
    reason: json["reason"],
    appliedOn: DateTime.parse(json["applied_on"]),
    isHalfDay: json["is_half_day"],
    leaveShift: json["leave_shift"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    leaveDurationType: json["leave_duration_type"],
  );

  Map<String, dynamic> toJson() => {
    "emp_id": empId,
    "emp_name": empName,
    "reporting_manager_name": reportingManagerName,
    "type": type,
    "id": id,
    "user_id": userId,
    "leave_type_id": leaveTypeId,
    "from_date": fromDate.toIso8601String(),
    "to_date": toDate.toIso8601String(),
    "duration": duration,
    "status": status,
    "reason": reason,
    "applied_on": appliedOn.toIso8601String(),
    "is_half_day": isHalfDay,
    "leave_shift": leaveShift,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "leave_duration_type": leaveDurationType,
  };
}
