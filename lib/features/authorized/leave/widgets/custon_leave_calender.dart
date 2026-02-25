import 'package:dronees/features/authorized/leave/controllers/leave_calender_controller.dart';
import 'package:dronees/features/authorized/leave/models/holiday_leave.dart';
import 'package:dronees/features/authorized/leave/models/selected_day.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomLeaveCalendar extends StatelessWidget {
  final LeaveCalendarController controller;
  final bool allowMultipleSelection;
  final RxList<HolidayLeave> holidays;
  final RxList<HolidayLeave> floatingHolidays;
  final bool isSelectedFloating;

  const CustomLeaveCalendar({
    super.key,
    required this.controller,
    required this.holidays,
    required this.floatingHolidays,
    this.allowMultipleSelection = true,
    this.isSelectedFloating = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<List<SelectedDay>>(
      initialValue: controller.selectedDays,
      validator: TValidator.validateLeaveDuration,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        return Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildWeekdayHeaders(),
            const SizedBox(height: 8),
            _buildCalendarGrid(context, state),
            const SizedBox(height: TSizes.spaceBtwItems),
            const SizedBox(height: 16),
            _buildSummaryCard(state),
          ],
        );
      },
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A5AE0), Color(0xFF8B7BFF)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: controller.previousMonth,
            ),
            Text(
              DateFormat('MMMM yyyy').format(controller.displayedMonth.value),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: controller.nextMonth,
            ),
          ],
        ),
      ),
    );
  }

  // ================= WEEK =================
  Widget _buildWeekdayHeaders() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      children: weekdays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  // ================= GRID =================
  Widget _buildCalendarGrid(
    BuildContext context,
    FormFieldState<List<SelectedDay>> state,
  ) {
    return Obx(() {
      final daysInMonth = _getDaysInMonth(controller.displayedMonth.value);
      final firstDay = DateTime(
        controller.displayedMonth.value.year,
        controller.displayedMonth.value.month,
        1,
      );

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemCount: daysInMonth + firstDay.weekday - 1,
        itemBuilder: (_, index) {
          if (index < firstDay.weekday - 1) {
            return const SizedBox.shrink();
          }

          final day = index - firstDay.weekday + 2;

          final date = DateTime(
            controller.displayedMonth.value.year,
            controller.displayedMonth.value.month,
            day,
          );

          final isToday = _isToday(date);
          final isPast = date.isBefore(
            DateTime.now().subtract(const Duration(days: 1)),
          );
          final isSunday = _isSunday(date);
          final isHoliday = _isHoliday(date);
          final isFloatingHoliday = _isFloatingHoliday(date);

          return _buildDayCell(
            context,
            date,
            isToday,
            isPast,
            isSunday,
            isHoliday,
            isFloatingHoliday,
            state,
          );
        },
      );
    });
  }

  // ================= DAY CELL =================
  Widget _buildDayCell(
    BuildContext context,
    DateTime date,
    bool isToday,
    bool isPast,
    bool isSunday,
    bool isHoliday,
    bool isFloatingHoliday,
    FormFieldState<List<SelectedDay>> state,
  ) {
    return Obx(() {
      TLoggerHelper.customPrint(isSelectedFloating.toString());
      final selectionType = controller.getSelectionType(date);
      final isSelected = selectionType != null;
      final holiday = _getHoliday(date);
      // final floatingHoliday = _getFloatingHoliday(date);
      // 🔥 DISABLE LOGIC
      final isDisabled = isSelectedFloating
          ? !isFloatingHoliday // only allow floating holidays
          : (isPast || isSunday || isHoliday);

      return GestureDetector(
        onTap: isDisabled
            ? null
            : () {
                if (!allowMultipleSelection) {
                  controller.clearSelections();
                  controller.toggleDaySelection(
                    date,
                    DaySelectionType.fullDay,
                    state,
                  );
                } else {
                  _showSelectionDialog(context, date, state);
                }
              },
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.shade100
                : isToday
                ? const Color(0xFF6A5AE0).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isToday ? const Color(0xFF6A5AE0) : Colors.grey.shade200,
              width: isToday ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              if (isSelectedFloating && isFloatingHoliday)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green, width: 1.5),
                    ),
                  ),
                ),
              Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.grey
                        : isToday
                        ? const Color(0xFF6A5AE0)
                        : Colors.black,
                  ),
                ),
              ),

              if (isSelected)
                Positioned(
                  bottom: 4,
                  left: 4,
                  right: 4,
                  child: _buildSelectionIndicator(selectionType),
                ),

              if (isHoliday && holiday != null)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Tooltip(
                    message: holiday.holidayName,
                    child: const Icon(
                      Icons.event_busy,
                      size: 12,
                      color: Colors.red,
                    ),
                  ),
                ),

              if (isSunday)
                const Positioned(
                  top: 2,
                  left: 2,
                  child: Text(
                    'S',
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  // ================= DIALOG =================
  void _showSelectionDialog(
    BuildContext context,
    DateTime date,
    FormFieldState<List<SelectedDay>> state,
  ) {
    if (!allowMultipleSelection) {
      controller.clearSelections();
      controller.toggleDaySelection(date, DaySelectionType.fullDay, state);
      return;
    }

    final index = state.value == null
        ? -1
        : state.value!.indexWhere((e) => _isSameDate(e.date, date));
    final item = index != -1 ? state.value![index] : null;

    CustomBlurBottomSheet.show(
      context,
      widget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Header with Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Duration",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, MMM dd').format(date),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Selection Options
            _buildModernOption(
              title: "Full Day",
              subtitle: "Standard working hours",
              icon: Icons.wb_sunny,
              isSelected: item?.selectionType == DaySelectionType.fullDay,
              onTap: () {
                controller.toggleDaySelection(
                  date,
                  DaySelectionType.fullDay,
                  state,
                );
                Get.back();
              },
            ),
            const SizedBox(height: 12),
            _buildModernOption(
              title: "First Half",
              subtitle: "Morning session only",
              icon: Icons.wb_twilight,
              isSelected: item?.selectionType == DaySelectionType.firstHalf,
              onTap: () {
                controller.toggleDaySelection(
                  date,
                  DaySelectionType.firstHalf,
                  state,
                );
                Get.back();
              },
            ),
            const SizedBox(height: 12),
            _buildModernOption(
              title: "Second Half",
              subtitle: "Afternoon session only",
              icon: Icons.nights_stay_outlined,
              isSelected: item?.selectionType == DaySelectionType.secondHalf,
              onTap: () {
                controller.toggleDaySelection(
                  date,
                  DaySelectionType.secondHalf,
                  state,
                );
                Get.back();
              },
            ),

            // Remove Button (Dynamic)
            if (item != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    controller.toggleDaySelection(
                      date,
                      item.selectionType,
                      state,
                    );
                    Get.back();
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    "Remove Selection",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.red.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildModernOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primaryColor = const Color(0xFF6A5AE0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primaryColor : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: primaryColor)
            else
              Icon(Icons.circle_outlined, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _option(String title, bool selected, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: onTap,
    );
  }

  // ================= INDICATOR =================
  Widget _buildSelectionIndicator(DaySelectionType type) {
    switch (type) {
      case DaySelectionType.fullDay:
        return Container(height: 4, color: const Color(0xFF6A5AE0));
      case DaySelectionType.firstHalf:
        return Row(
          children: [
            Expanded(child: Container(height: 4, color: Colors.blue)),
            Expanded(child: Container(height: 4, color: Colors.grey)),
          ],
        );
      case DaySelectionType.secondHalf:
        return Row(
          children: [
            Expanded(child: Container(height: 4, color: Colors.grey)),
            Expanded(child: Container(height: 4, color: Colors.blue)),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  // ================= SUMMARY =================

  Widget _buildSummaryCard(FormFieldState<List<SelectedDay>> state) {
    return Obx(() {
      final totalDays = controller.getTotalDays();
      final selectedCount = controller.selectedDays.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: state.hasError
                    ? [TColors.error, TColors.deleteColor]
                    : [Color(0xFF6A5AE0), Color(0xFF8B7BFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6A5AE0).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.event_available,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Leave Duration',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '$totalDays',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            totalDays == 1 ? 'Day' : 'Days',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (selectedCount > 0)
                        Text(
                          '$selectedCount date${selectedCount > 1 ? 's' : ''} selected',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                    ],
                  ),
                ),
                if (selectedCount > 0)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () => controller.clearSelections(),
                    tooltip: 'Clear all',
                  ),
              ],
            ),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 6),
              child: Text(
                state.errorText ?? '',
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
              ),
            ),
        ],
      );
    });
  }

  // ================= HELPERS =================
  int _getDaysInMonth(DateTime d) => DateTime(d.year, d.month + 1, 0).day;

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  bool _isSunday(DateTime d) => d.weekday == DateTime.sunday;

  bool _isHoliday(DateTime date) {
    return holidays.any((h) => _isSameDate(h.date, date));
  }

  bool _isFloatingHoliday(DateTime date) {
    return floatingHolidays.any((h) => _isSameDate(h.date, date));
  }

  HolidayLeave? _getFloatingHoliday(DateTime date) {
    try {
      return floatingHolidays.firstWhere((h) => _isSameDate(h.date, date));
    } catch (_) {
      return null;
    }
  }

  HolidayLeave? _getHoliday(DateTime date) {
    try {
      return holidays.firstWhere((h) => _isSameDate(h.date, date));
    } catch (_) {
      return null;
    }
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
