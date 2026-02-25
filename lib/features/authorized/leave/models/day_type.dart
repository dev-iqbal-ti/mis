import 'package:dronees/utils/logging/logger.dart';

class DayType {
  // [{"date":"2026-02-27","dayType":"SECOND_HALF"},{"date":"2026-02-28","dayType":"FIRST_HALF"},{"date":"2026-03-09","dayType":"FULL_DAY"}]
  static const String fullDay = 'FULL_DAY';
  static const String firstHalf = 'FIRST_HALF';
  static const String secondHalf = 'SECOND_HALF';

  static String getValue(String key) {
    TLoggerHelper.customPrint(key);
    if (key == "fullDay") return fullDay;
    if (key == "firstHalf") return firstHalf;
    if (key == "secondHalf") return secondHalf;
    return fullDay;
  }

  static String getName(String key) {
    if (key == fullDay) return "Full Day";
    if (key == firstHalf) return "First Half";
    if (key == secondHalf) return "Second Half";
    return "Full Day";
  }
}
