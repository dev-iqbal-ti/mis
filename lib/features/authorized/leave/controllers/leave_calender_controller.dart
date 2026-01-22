import 'package:dronees/features/authorized/leave/models/selected_day.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveCalendarController extends GetxController {
  RxList<SelectedDay> selectedDays = <SelectedDay>[].obs;
  Rx<DateTime> displayedMonth = DateTime.now().obs;

  double getTotalDays() {
    double total = 0;
    for (var day in selectedDays) {
      switch (day.selectionType) {
        case DaySelectionType.fullDay:
          total += 1.0;
          break;
        case DaySelectionType.firstHalf:
        case DaySelectionType.secondHalf:
          total += 0.5;
          break;
        default:
          break;
      }
    }
    return total;
  }

  void toggleDaySelection(
    DateTime date,
    DaySelectionType type,
    FormFieldState<List<SelectedDay>> state,
  ) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final existingIndex = selectedDays.indexWhere(
      (day) =>
          day.date.year == normalizedDate.year &&
          day.date.month == normalizedDate.month &&
          day.date.day == normalizedDate.day,
    );

    if (existingIndex != -1) {
      if (selectedDays[existingIndex].selectionType == type) {
        // Same type clicked - remove selection
        selectedDays.removeAt(existingIndex);
      } else {
        // Different type - update selection
        selectedDays[existingIndex] = SelectedDay(
          date: normalizedDate,
          selectionType: type,
        );
      }
    } else {
      // New selection
      selectedDays.add(SelectedDay(date: normalizedDate, selectionType: type));
    }

    state.didChange(selectedDays);
  }

  DaySelectionType? getSelectionType(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final index = selectedDays.indexWhere(
      (day) =>
          day.date.year == normalizedDate.year &&
          day.date.month == normalizedDate.month &&
          day.date.day == normalizedDate.day,
    );

    return index != -1 ? selectedDays[index].selectionType : null;
  }

  void nextMonth() {
    displayedMonth.value = DateTime(
      displayedMonth.value.year,
      displayedMonth.value.month + 1,
    );
  }

  void previousMonth() {
    displayedMonth.value = DateTime(
      displayedMonth.value.year,
      displayedMonth.value.month - 1,
    );
  }

  void clearSelections() {
    selectedDays.clear();
  }

  List<Map<String, dynamic>> getSelectedDaysData() {
    return selectedDays
        .map(
          (day) => {
            'date': day.date.toIso8601String(),
            'type': day.selectionType.toString().split('.').last,
            'value': day.selectionType == DaySelectionType.fullDay ? 1.0 : 0.5,
          },
        )
        .toList();
  }
}
