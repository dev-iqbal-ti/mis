import 'dart:convert';

TravelAllowanceStats travelAllowanceStatsFromJson(String str) =>
    TravelAllowanceStats.fromJson(json.decode(str));

String travelAllowanceStatsToJson(TravelAllowanceStats data) =>
    json.encode(data.toJson());

class TravelAllowanceStats {
  final int userId;
  final int pendingCount;
  final int approvedCount;
  final int rejectedCount;
  final String pendingAmount;
  final String approvedAmount;
  final String rejectedAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  TravelAllowanceStats({
    required this.userId,
    required this.pendingCount,
    required this.approvedCount,
    required this.rejectedCount,
    required this.pendingAmount,
    required this.approvedAmount,
    required this.rejectedAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TravelAllowanceStats.fromJson(Map<String, dynamic> json) =>
      TravelAllowanceStats(
        userId: json["user_id"],
        pendingCount: json["pending_count"],
        approvedCount: json["approved_count"],
        rejectedCount: json["rejected_count"],
        pendingAmount: json["pending_amount"],
        approvedAmount: json["approved_amount"],
        rejectedAmount: json["rejected_amount"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "pending_count": pendingCount,
    "approved_count": approvedCount,
    "rejected_count": rejectedCount,
    "pending_amount": pendingAmount,
    "approved_amount": approvedAmount,
    "rejected_amount": rejectedAmount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
