import 'dart:convert';

List<PaymentReceivedModel> paymentReceivedModelFromJson(String str) =>
    List<PaymentReceivedModel>.from(
      json.decode(str).map((x) => PaymentReceivedModel.fromJson(x)),
    );

String paymentReceivedModelToJson(List<PaymentReceivedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentReceivedModel {
  final int id;
  final String amount;
  final String method;
  final String remark;
  final String? proof;
  final String status;
  final int projectId;
  final int userId;
  final int? approvedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String projectName;
  final String createdByName;
  final String? approvedByName;

  PaymentReceivedModel({
    required this.id,
    required this.amount,
    required this.method,
    required this.remark,
    required this.proof,
    required this.status,
    required this.projectId,
    required this.userId,
    required this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.projectName,
    required this.createdByName,
    required this.approvedByName,
  });

  factory PaymentReceivedModel.fromJson(Map<String, dynamic> json) =>
      PaymentReceivedModel(
        id: json["id"],
        amount: json["amount"],
        method: json["method"],
        remark: json["remark"],
        proof: json["proof"],
        status: json["status"],
        projectId: json["project_id"],
        userId: json["user_id"],
        approvedBy: json["approved_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        projectName: json["project_name"],
        createdByName: json["created_by_name"],
        approvedByName: json["approved_by_name"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "method": method,
    "remark": remark,
    "proof": proof,
    "status": status,
    "project_id": projectId,
    "user_id": userId,
    "approved_by": approvedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "project_name": projectName,
    "created_by_name": createdByName,
    "approved_by_name": approvedByName,
  };
}
