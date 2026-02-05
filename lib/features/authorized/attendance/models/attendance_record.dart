import 'dart:convert';

import 'package:dronees/utils/helpers/parser.dart';
import 'package:flutter/Material.dart';

List<AttendanceRecord> attendanceFromJson(List<dynamic> list) =>
    List<AttendanceRecord>.from(list.map((x) => AttendanceRecord.fromJson(x)));

String attendanceToJson(List<AttendanceRecord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceRecord {
  final int userId;
  final DateTime date;
  final DateTime inTime;
  DateTime? outTime;
  String? totalHours;
  final String mode;
  final String status;
  final String? note;
  final String address;
  final dynamic idleState;
  final String latitude;
  final String longitude;
  final String photoUrl;

  AttendanceRecord({
    required this.idleState,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.photoUrl,
    required this.inTime,
    this.outTime,
    required this.userId,

    required this.date,
    required this.totalHours,
    required this.mode,
    required this.status,
    this.note,
  });

  factory AttendanceRecord.fromJsonWithError(Map<String, dynamic> json) {
    try {
      return AttendanceRecord(
        userId: json["user_id"] as int,
        date: DateTime.parse(json["date"]),
        inTime: DateTime.parse(json["in_time"]).toLocal(),
        outTime: json["out_time"] != null && json["out_time"] != "-"
            ? DateTime.parse(json["out_time"]).toLocal()
            : null,
        totalHours: json["total_hours"] != "-" ? json["total_hours"] : null,
        mode: json["mode"] as String,
        status: json["status"] as String,
        note: json["note"],
        address: json["address"] as String,
        idleState: json["idle_state"] ?? false,
        latitude: json["latitude"] as String,
        longitude: json["longitude"] as String,
        photoUrl: json["photoUrl"] as String,
      );
    } catch (e, s) {
      debugPrint("❌ AttendanceRecord parse error");
      debugPrint("JSON => $json");
      debugPrint("ERROR => $e");
      debugPrint("STACK => $s");
      rethrow;
    }
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    // log(DateTime.parse(json["in_time"]).toLocal().toString());
    return AttendanceRecord(
      userId: requiredField<int>(json["user_id"], "User_id"),

      date: requiredField<DateTime>(
        DateTime.parse(json["date"]).toLocal(),
        "Date",
      ),
      inTime: requiredField<DateTime>(
        DateTime.parse(json["in_time"]).toLocal(),
        "In_time",
      ),
      outTime: json["out_time"] != "-"
          ? DateTime.parse(json["out_time"]).toLocal()
          : null,
      totalHours: json["total_hours"] != "-" ? json["total_hours"] : null,
      mode: json["mode"] ?? "",
      status: json["status"] ?? "",
      note: json["note"] ?? "",
      address: requiredField(json["address"], "address"),
      idleState: json["idle_state"] ?? false,
      latitude: requiredField(json["latitude"], "latitude"),
      longitude: requiredField(json["longitude"], "longitude"),
      photoUrl: requiredField(json["photoUrl"], "photoUrl"),
    );
  }

  Map<String, dynamic> toJson() => {
    "user_id": userId,

    "date": date.toIso8601String(),
    "in_time": inTime.toIso8601String(),
    "out_time": outTime,
    "total_hours": totalHours,
    "mode": mode,
    "status": status,
    "note": note,
    "address": address,
    "idle_state": idleState,
    "latitude": latitude,
    "longitude": longitude,
    "photoUrl": photoUrl,
  };

  Duration get workDuration {
    if (outTime == null) {
      final DateTime endTime =
          // check if same date then compare with current time else compare with 23:59:59
          inTime.year == DateTime.now().year &&
              inTime.month == DateTime.now().month &&
              inTime.day == DateTime.now().day
          ? DateTime.now()
          : DateTime(inTime.year, inTime.month, inTime.day, 23, 59, 59);

      return endTime.difference(inTime);
    }
    return outTime!.difference(inTime);
  }

  String get formattedDuration {
    final duration = workDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  bool get isActive => outTime == null;

  // Check if this is from today
  bool get isToday {
    final now = DateTime.now();
    return inTime.year == now.year &&
        inTime.month == now.month &&
        inTime.day == now.day;
  }
}
