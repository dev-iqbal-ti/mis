import 'dart:convert';

LeaveEntitlement leaveEntitlementFromJson(String str) =>
    LeaveEntitlement.fromJson(json.decode(str));

String leaveEntitlementToJson(LeaveEntitlement data) =>
    json.encode(data.toJson());

class LeaveEntitlement {
  final int id;
  final int userId;
  final double entitlement;
  final double used;
  final String leaveTypeName;
  final double remaining;

  LeaveEntitlement({
    required this.id,
    required this.userId,
    required this.entitlement,
    required this.used,
    required this.leaveTypeName,
    required this.remaining,
  });

  factory LeaveEntitlement.fromJson(Map<String, dynamic> json) =>
      LeaveEntitlement(
        id: json["id"],
        userId: json["user_id"],
        entitlement: json["entitlement"]?.toDouble(),
        used: json["used"]?.toDouble(),
        leaveTypeName: json["leave_type_name"],
        remaining: json["remaining"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "entitlement": entitlement,
    "used": used,
    "leave_type_name": leaveTypeName,
    "remaining": remaining,
  };
}
