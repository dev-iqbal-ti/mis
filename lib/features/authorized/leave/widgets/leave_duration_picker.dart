import 'package:dronees/features/authorized/leave/controllers/leave_controller.dart';
import 'package:dronees/features/authorized/leave/models/leave_duration.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveDurationPicker extends StatelessWidget {
  final LeaveController controller;

  const LeaveDurationPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Leave Duration Type"),
        const SizedBox(height: 6),

        // Leave Type Selection
        Obx(
          () => Row(
            children: [
              _buildLeaveTypeChip(
                "Full Day",
                LeaveType.fullDay,
                controller.selectedLeaveType.value == LeaveType.fullDay,
              ),
              const SizedBox(width: 8),
              _buildLeaveTypeChip(
                "Half Day",
                LeaveType.halfDay,
                controller.selectedLeaveType.value == LeaveType.halfDay,
              ),
              const SizedBox(width: 8),
              _buildLeaveTypeChip(
                "Multiple Days",
                LeaveType.multipleDays,
                controller.selectedLeaveType.value == LeaveType.multipleDays,
              ),
            ],
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwItems),

        // Date Selection based on type
        Obx(() {
          switch (controller.selectedLeaveType.value) {
            case LeaveType.fullDay:
              return _buildFullDaySection(context);
            case LeaveType.halfDay:
              return _buildHalfDaySection(context);
            case LeaveType.multipleDays:
              return _buildMultipleDaysSection(context);
          }
        }),

        const SizedBox(height: TSizes.spaceBtwItems),

        // Total Days Display
        Obx(() => _buildTotalDaysCard()),
      ],
    );
  }

  Widget _buildLeaveTypeChip(String label, LeaveType type, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setLeaveType(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6A5AE0) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF6A5AE0)
                  : const Color(0xFFE8E8E8),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullDaySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Select Date"),
        const SizedBox(height: 6),
        _buildDatePicker(
          context,
          controller.startDate.value,
          "Select leave date",
          (date) => controller.setStartDate(date),
        ),
      ],
    );
  }

  Widget _buildHalfDaySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Select Date"),
        const SizedBox(height: 6),
        _buildDatePicker(
          context,
          controller.startDate.value,
          "Select leave date",
          (date) => controller.setStartDate(date),
        ),

        const SizedBox(height: TSizes.spaceBtwItems),

        _buildFieldLabel("Select Half Day Session"),
        const SizedBox(height: 8),
        Obx(
          () => Row(
            children: [
              _buildSessionChip(
                "First Half",
                HalfDaySession.firstHalf,
                controller.startHalfDay.value == HalfDaySession.firstHalf,
                (session) => controller.setStartHalfDay(session),
              ),
              const SizedBox(width: 12),
              _buildSessionChip(
                "Second Half",
                HalfDaySession.secondHalf,
                controller.startHalfDay.value == HalfDaySession.secondHalf,
                (session) => controller.setStartHalfDay(session),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleDaysSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start Date
        _buildFieldLabel("From Date"),
        const SizedBox(height: 6),
        _buildDatePicker(
          context,
          controller.startDate.value,
          "Start date",
          (date) => controller.setStartDate(date),
        ),

        const SizedBox(height: 12),

        // Start Half Day Option
        Obx(
          () => _buildHalfDayCheckbox(
            "First day is half day",
            controller.startHalfDay.value != null,
            (value) {
              if (value) {
                controller.setStartHalfDay(HalfDaySession.firstHalf);
              } else {
                controller.setStartHalfDay(HalfDaySession.firstHalf);
                controller.startHalfDay.value = null;
              }
            },
          ),
        ),

        // If start is half day, show session selection
        Obx(() {
          if (controller.startHalfDay.value != null) {
            return Padding(
              padding: const EdgeInsets.only(left: 24, top: 8),
              child: Row(
                children: [
                  _buildSessionChip(
                    "First Half",
                    HalfDaySession.firstHalf,
                    controller.startHalfDay.value == HalfDaySession.firstHalf,
                    (session) => controller.setStartHalfDay(session),
                  ),
                  const SizedBox(width: 8),
                  _buildSessionChip(
                    "Second Half",
                    HalfDaySession.secondHalf,
                    controller.startHalfDay.value == HalfDaySession.secondHalf,
                    (session) => controller.setStartHalfDay(session),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        const SizedBox(height: 20),

        // End Date
        _buildFieldLabel("To Date"),
        const SizedBox(height: 8),
        Obx(
          () => _buildDatePicker(
            context,
            controller.endDate.value ??
                controller.startDate.value.add(Duration(days: 1)),
            "End date",
            (date) => controller.setEndDate(date),
          ),
        ),

        const SizedBox(height: 12),

        // End Half Day Option
        Obx(
          () => _buildHalfDayCheckbox(
            "Last day is half day",
            controller.endHalfDay.value != null,
            (value) {
              if (value) {
                controller.setEndHalfDay(HalfDaySession.firstHalf);
              } else {
                controller.setEndHalfDay(null);
              }
            },
          ),
        ),

        // If end is half day, show session selection
        Obx(() {
          if (controller.endHalfDay.value != null) {
            return Padding(
              padding: const EdgeInsets.only(left: 24, top: 8),
              child: Row(
                children: [
                  _buildSessionChip(
                    "First Half",
                    HalfDaySession.firstHalf,
                    controller.endHalfDay.value == HalfDaySession.firstHalf,
                    (session) => controller.setEndHalfDay(session),
                  ),
                  const SizedBox(width: 8),
                  _buildSessionChip(
                    "Second Half",
                    HalfDaySession.secondHalf,
                    controller.endHalfDay.value == HalfDaySession.secondHalf,
                    (session) => controller.setEndHalfDay(session),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildSessionChip(
    String label,
    HalfDaySession session,
    bool isSelected,
    Function(HalfDaySession) onSelect,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(session),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF6A5AE0).withOpacity(0.1)
                : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF6A5AE0)
                  : const Color(0xFFE8E8E8),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFF6A5AE0) : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHalfDayCheckbox(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(
            value: value,
            onChanged: (val) => onChanged(val ?? false),
            activeColor: const Color(0xFF6A5AE0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    DateTime selectedDate,
    String hint,
    Function(DateTime) onSelectDate,
  ) {
    String formatDate(DateTime date) {
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "${date.day} ${months[date.month - 1]} ${date.year}";
    }

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF6A5AE0),
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          onSelectDate(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 18,
              color: Color(0xFF6A5AE0),
            ),
            const SizedBox(width: 10),
            Text(
              formatDate(selectedDate),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalDaysCard() {
    final leaveDuration = controller.getLeaveDuration();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6A5AE0).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6A5AE0).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF6A5AE0), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Leave Duration",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${leaveDuration.getTotalDays()} Days",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A5AE0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}
