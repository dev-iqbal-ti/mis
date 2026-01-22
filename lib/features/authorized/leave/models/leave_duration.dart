// ==================== ENUMS ====================
enum LeaveType { fullDay, halfDay, multipleDays }

enum HalfDaySession { firstHalf, secondHalf }

// ==================== MODEL ====================
class LeaveDuration {
  final DateTime startDate;
  final DateTime? endDate;
  final LeaveType leaveType;
  final HalfDaySession? startHalfDay;
  final HalfDaySession? endHalfDay;

  LeaveDuration({
    required this.startDate,
    this.endDate,
    required this.leaveType,
    this.startHalfDay,
    this.endHalfDay,
  });

  // Calculate total leave days
  double getTotalDays() {
    if (leaveType == LeaveType.fullDay) {
      return 1.0;
    } else if (leaveType == LeaveType.halfDay) {
      return 0.5;
    } else {
      // Multiple days
      if (endDate == null) return 1.0;

      int daysDifference = endDate!.difference(startDate).inDays + 1;
      double total = daysDifference.toDouble();

      // Subtract 0.5 if start date is half day
      if (startHalfDay != null) {
        total -= 0.5;
      }

      // Subtract 0.5 if end date is half day
      if (endHalfDay != null) {
        total -= 0.5;
      }

      return total;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'leaveType': leaveType.toString(),
      'startHalfDay': startHalfDay?.toString(),
      'endHalfDay': endHalfDay?.toString(),
      'totalDays': getTotalDays(),
    };
  }

  String getDescription() {
    if (leaveType == LeaveType.fullDay) {
      return "1 Full Day";
    } else if (leaveType == LeaveType.halfDay) {
      String session = startHalfDay == HalfDaySession.firstHalf
          ? "First Half"
          : "Second Half";
      return "Half Day ($session)";
    } else {
      return "${getTotalDays()} Days";
    }
  }
}
