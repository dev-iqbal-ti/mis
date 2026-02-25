// To parse this JSON data, do
//
//     final vehicle = vehicleFromJson(jsonString);

import 'dart:convert';

List<Vehicle> vehicleFromJson(String str) =>
    List<Vehicle>.from(json.decode(str).map((x) => Vehicle.fromJson(x)));

String vehicleToJson(List<Vehicle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vehicle {
  final int id;
  final String vehicleNumber;
  final String vehicleType;
  final String brand;
  final String model;
  final DateTime registrationDate;
  final DateTime insuranceExpiry;
  final DateTime pollutionExpiry;
  final String fuelType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.registrationDate,
    required this.insuranceExpiry,
    required this.pollutionExpiry,
    required this.fuelType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["id"],
    vehicleNumber: json["vehicle_number"],
    vehicleType: json["vehicle_type"],
    brand: json["brand"],
    model: json["model"],
    registrationDate: DateTime.parse(json["registration_date"]),
    insuranceExpiry: DateTime.parse(json["insurance_expiry"]),
    pollutionExpiry: DateTime.parse(json["pollution_expiry"]),
    fuelType: json["fuel_type"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_number": vehicleNumber,
    "vehicle_type": vehicleType,
    "brand": brand,
    "model": model,
    "registration_date": registrationDate.toIso8601String(),
    "insurance_expiry": insuranceExpiry.toIso8601String(),
    "pollution_expiry": pollutionExpiry.toIso8601String(),
    "fuel_type": fuelType,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
