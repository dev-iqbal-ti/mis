// ==================== ENUMS ====================
enum DaySelectionType { none, firstHalf, secondHalf, fullDay }

// ==================== MODELS ====================
class SelectedDay {
  final DateTime date;
  final DaySelectionType selectionType;

  SelectedDay({required this.date, required this.selectionType});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedDay &&
          runtimeType == other.runtimeType &&
          date.year == other.date.year &&
          date.month == other.date.month &&
          date.day == other.date.day;

  @override
  int get hashCode => date.hashCode;
}
