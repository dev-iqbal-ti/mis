import 'dart:convert';

List<TravelAllowance> travelAllowanceFromJson(String str) =>
    List<TravelAllowance>.from(
      json.decode(str).map((x) => TravelAllowance.fromJson(x)),
    );

String travelAllowanceToJson(List<TravelAllowance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TravelAllowance {
  final int id;
  final int userId;
  final String taNo;
  final DateTime? transationDate;
  final String? amount;
  final String purpose;
  final String taType;
  final String tourType;
  final dynamic otherSpecify;
  final String status;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String contact;
  final int? advanceId;
  final String? fromLocation;
  final String? toLocation;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final bool accommodationRequired;
  final bool advanceRequired;
  final String? totalEstimatedExpense;
  final String? advanceAmount;

  TravelAllowance({
    required this.id,
    required this.userId,
    required this.taNo,
    required this.transationDate,
    required this.amount,
    required this.purpose,
    required this.taType,
    required this.tourType,
    required this.otherSpecify,
    required this.status,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.contact,
    required this.advanceId,
    required this.fromLocation,
    required this.toLocation,
    required this.departureDate,
    required this.returnDate,
    required this.accommodationRequired,
    required this.advanceRequired,
    required this.totalEstimatedExpense,
    required this.advanceAmount,
  });

  factory TravelAllowance.fromJson(Map<String, dynamic> json) =>
      TravelAllowance(
        id: json["id"],
        userId: json["user_id"],
        taNo: json["ta_no"],
        transationDate: json["transation_date"] == null
            ? null
            : DateTime.parse(json["transation_date"]),
        amount: json["amount"],
        purpose: json["purpose"],
        taType: json["ta_type"],
        tourType: json["tour_type"],
        otherSpecify: json["other_specify"],
        status: json["status"],
        imageUrl: json["image_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        contact: json["contact"],
        advanceId: json["advance_id"],
        fromLocation: json["from_location"],
        toLocation: json["to_location"],
        departureDate: json["departure_date"] == null
            ? null
            : DateTime.parse(json["departure_date"]),
        returnDate: json["return_date"] == null
            ? null
            : DateTime.parse(json["return_date"]),
        accommodationRequired: json["accommodation_required"],
        advanceRequired: json["advance_required"],
        totalEstimatedExpense: json["total_estimated_expense"],
        advanceAmount: json["advance_amount"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "ta_no": taNo,
    "transation_date": transationDate?.toIso8601String(),
    "amount": amount,
    "purpose": purpose,
    "ta_type": taType,
    "tour_type": tourType,
    "other_specify": otherSpecify,
    "status": status,
    "image_url": imageUrl,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "name": name,
    "contact": contact,
    "advance_id": advanceId,
    "from_location": fromLocation,
    "to_location": toLocation,
    "departure_date": departureDate?.toIso8601String(),
    "return_date": returnDate?.toIso8601String(),
    "accommodation_required": accommodationRequired,
    "advance_required": advanceRequired,
    "total_estimated_expense": totalEstimatedExpense,
    "advance_amount": advanceAmount,
  };
}
