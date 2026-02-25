import 'dart:convert';

List<HolidayLeave> holidayLeaveFromJson(String str) => List<HolidayLeave>.from(
  json.decode(str).map((x) => HolidayLeave.fromJson(x)),
);

String holidayLeaveToJson(List<HolidayLeave> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HolidayLeave {
  final int id;
  final String holidayName;
  final DateTime date;
  final String? type;

  HolidayLeave({
    required this.id,
    required this.holidayName,
    required this.date,
    this.type,
  });

  factory HolidayLeave.fromJson(Map<String, dynamic> json) => HolidayLeave(
    id: json["id"],
    holidayName: json["holiday_name"],
    date: DateTime.parse(json["date"]),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "holiday_name": holidayName,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "type": type,
  };
}
