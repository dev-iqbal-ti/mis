import 'dart:developer';

import 'package:dronees/features/authorized/leave/controllers/leave_calender_controller.dart';
import 'package:dronees/features/authorized/leave/models/selected_day.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomLeaveCalendar extends StatelessWidget {
  final LeaveCalendarController controller;

  const CustomLeaveCalendar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormField<List<SelectedDay>>(
      initialValue: controller.selectedDays,
      validator: TValidator.validateLeaveDuration,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<List<SelectedDay>> state) {
        return Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildWeekdayHeaders(),
            const SizedBox(height: 8),
            _buildCalendarGrid(state),
            const SizedBox(height: TSizes.spaceBtwItems),
            _buildLegend(),
            const SizedBox(height: 16),
            _buildSummaryCard(state),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A5AE0), Color(0xFF8B7BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () => controller.previousMonth(),
            ),
            Text(
              DateFormat('MMMM yyyy').format(controller.displayedMonth.value),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () => controller.nextMonth(),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildCalendarGrid(FormFieldState<List<SelectedDay>> state) {
    return Obx(() {
      final daysInMonth = _getDaysInMonth(controller.displayedMonth.value);
      final firstDayOfMonth = DateTime(
        controller.displayedMonth.value.year,
        controller.displayedMonth.value.month,
        1,
      );
      final startingWeekday = firstDayOfMonth.weekday;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 0.8,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: daysInMonth + startingWeekday - 1,
        itemBuilder: (context, index) {
          if (index < startingWeekday - 1) {
            return const SizedBox.shrink();
          }

          final day = index - startingWeekday + 2;
          final currentDate = DateTime(
            controller.displayedMonth.value.year,
            controller.displayedMonth.value.month,
            day,
          );

          final isToday = _isToday(currentDate);
          final isPast = currentDate.isBefore(
            DateTime.now().subtract(const Duration(days: 1)),
          );

          return _buildDayCell(currentDate, isToday, isPast, state);
        },
      );
    });
  }

  Widget _buildDayCell(
    DateTime date,
    bool isToday,
    bool isPast,
    FormFieldState<List<SelectedDay>> state,
  ) {
    return Obx(() {
      final selectionType = controller.getSelectionType(date);
      final isSelected = selectionType != null;

      return GestureDetector(
        onTap: isPast ? null : () => _showSelectionDialog(date, state),
        child: Container(
          decoration: BoxDecoration(
            color: isPast
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                  color: isPast
                      ? Colors.grey.shade400
                      : isToday
                      ? const Color(0xFF6A5AE0)
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              if (isSelected) _buildSelectionIndicator(selectionType),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSelectionIndicator(DaySelectionType type) {
    switch (type) {
      case DaySelectionType.fullDay:
        return Container(
          width: 32,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF6A5AE0),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      case DaySelectionType.firstHalf:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF6A5AE0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
              ),
            ),
            Container(
              width: 14,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                ),
              ),
            ),
          ],
        );
      case DaySelectionType.secondHalf:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
              ),
            ),
            Container(
              width: 14,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF6A5AE0),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                ),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showSelectionDialog(
    DateTime date,
    FormFieldState<List<SelectedDay>> state,
  ) {
    final index = state.value == null
        ? -1
        : state.value!.indexWhere((item) => item.date == date);
    final item = index != -1 ? state.value![index] : null;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('EEEE, MMM dd').format(date),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildSelectionOption(
                'Full Day',
                item == null
                    ? false
                    : item.selectionType == DaySelectionType.fullDay,
                Icons.calendar_today,
                () {
                  controller.toggleDaySelection(
                    date,
                    DaySelectionType.fullDay,
                    state,
                  );
                  Get.back();
                },
              ),
              const SizedBox(height: 12),
              _buildSelectionOption(
                'First Half',
                item == null
                    ? false
                    : item.selectionType == DaySelectionType.firstHalf,
                Icons.wb_sunny_outlined,
                () {
                  controller.toggleDaySelection(
                    date,
                    DaySelectionType.firstHalf,
                    state,
                  );
                  Get.back();
                },
              ),
              const SizedBox(height: 12),
              _buildSelectionOption(
                'Second Half',
                item == null
                    ? false
                    : item.selectionType == DaySelectionType.secondHalf,
                Icons.nightlight_outlined,
                () {
                  controller.toggleDaySelection(
                    date,
                    DaySelectionType.secondHalf,
                    state,
                  );
                  Get.back();
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: index == -1
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  index == -1
                      ? const SizedBox.shrink()
                      : TextButton(
                          onPressed: () {
                            controller.toggleDaySelection(
                              date,
                              state.value![index].selectionType,
                              state,
                            );
                            Get.back();
                          },
                          child: const Text(
                            'Remove',
                            style: TextStyle(color: TColors.deleteColor),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionOption(
    String label,
    bool isSelected,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? TColors.accent : const Color(0xFFF8F9FA),

          // color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6A5AE0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF6A5AE0), size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legend',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLegendItem('Full Day', DaySelectionType.fullDay),
              const SizedBox(width: 16),
              _buildLegendItem('First Half', DaySelectionType.firstHalf),
              const SizedBox(width: 16),
              _buildLegendItem('Second Half', DaySelectionType.secondHalf),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, DaySelectionType type) {
    return Row(
      children: [
        _buildSelectionIndicator(type),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black87),
        ),
      ],
    );
  }

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

  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

// import 'package:dronees/features/authorized/leave/controllers/leave_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:get/get.dart';

// class CustomLeaveCalendar extends StatelessWidget {
//   final controller = Get.put(LeaveController());

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Obx(
//           () => TableCalendar(
//             firstDay: DateTime.now(),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: controller.focusedDay.value,
//             rangeStartDay: controller.rangeStart.value,
//             rangeEndDay: controller.rangeEnd.value,
//             calendarFormat: CalendarFormat.month,
//             rangeSelectionMode: RangeSelectionMode.enforced,

//             // Disable Sundays
//             enabledDayPredicate: (day) => day.weekday != DateTime.sunday,

//             onRangeSelected: controller.onRangeSelected,
//             calendarStyle: CalendarStyle(
//               rangeHighlightColor: Colors.blue.withOpacity(0.2),
//               rangeStartDecoration: const BoxDecoration(
//                 color: Colors.blue,
//                 shape: BoxShape.circle,
//               ),
//               rangeEndDecoration: const BoxDecoration(
//                 color: Colors.blue,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(height: 20),

//         // Options for Half Days
//         Obx(
//           () => Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               children: [
//                 _buildToggleTile(
//                   "Start Day is Half Day",
//                   controller.isStartHalfDay.value,
//                   (val) => controller.isStartHalfDay.value = val,
//                 ),
//                 if (controller.rangeEnd.value != null &&
//                     controller.rangeEnd.value != controller.rangeStart.value)
//                   _buildToggleTile(
//                     "End Day is Half Day",
//                     controller.isEndHalfDay.value,
//                     (val) => controller.isEndHalfDay.value = val,
//                   ),

//                 const Divider(),

//                 // Summary Display
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Total Leave Duration:",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "${controller.totalDays} Days",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildToggleTile(String title, bool value, Function(bool) onChanged) {
//     return SwitchListTile(
//       title: Text(title, style: const TextStyle(fontSize: 14)),
//       value: value,
//       onChanged: onChanged,
//       dense: true,
//     );
//   }
// }

// import 'package:dronees/features/authorized/leave/controllers/leave_calender_controller.dart';
// import 'package:dronees/features/authorized/leave/models/selected_day.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class CustomLeaveCalendar extends StatelessWidget {
//   final LeaveCalendarController controller;

//   const CustomLeaveCalendar({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildHeader(),
//         const SizedBox(height: 16),
//         _buildWeekdayHeaders(),
//         const SizedBox(height: 8),
//         _buildCalendarGrid(),
//         const SizedBox(height: 20),
//         _buildLegend(),
//         const SizedBox(height: 16),
//         _buildSummaryCard(),
//       ],
//     );
//   }

//   Widget _buildHeader() {
//     return Obx(
//       () => Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF6A5AE0), Color(0xFF8B7BFF)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.chevron_left, color: Colors.white),
//               onPressed: () => controller.previousMonth(),
//             ),
//             Text(
//               DateFormat('MMMM yyyy').format(controller.displayedMonth.value),
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.chevron_right, color: Colors.white),
//               onPressed: () => controller.nextMonth(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeekdayHeaders() {
//     const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//     return Row(
//       children: weekdays
//           .map(
//             (day) => Expanded(
//               child: Center(
//                 child: Text(
//                   day,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }

//   Widget _buildCalendarGrid() {
//     return Obx(() {
//       final daysInMonth = _getDaysInMonth(controller.displayedMonth.value);
//       final firstDayOfMonth = DateTime(
//         controller.displayedMonth.value.year,
//         controller.displayedMonth.value.month,
//         1,
//       );
//       final startingWeekday = firstDayOfMonth.weekday;

//       return GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 7,
//           childAspectRatio: 0.8,
//           crossAxisSpacing: 4,
//           mainAxisSpacing: 4,
//         ),
//         itemCount: daysInMonth + startingWeekday - 1,
//         itemBuilder: (context, index) {
//           if (index < startingWeekday - 1) {
//             return const SizedBox.shrink();
//           }

//           final day = index - startingWeekday + 2;
//           final currentDate = DateTime(
//             controller.displayedMonth.value.year,
//             controller.displayedMonth.value.month,
//             day,
//           );

//           final isToday = _isToday(currentDate);
//           final isPast = currentDate.isBefore(
//             DateTime.now().subtract(const Duration(days: 1)),
//           );

//           return _buildDayCell(currentDate, isToday, isPast);
//         },
//       );
//     });
//   }

//   Widget _buildDayCell(DateTime date, bool isToday, bool isPast) {
//     return Obx(() {
//       final selectionType = controller.getSelectionType(date);
//       final isSelected = selectionType != null;

//       return GestureDetector(
//         onTap: isPast ? null : () => _showSelectionDialog(date),
//         child: Container(
//           decoration: BoxDecoration(
//             color: isPast
//                 ? Colors.grey.shade100
//                 : isToday
//                 ? const Color(0xFF6A5AE0).withOpacity(0.1)
//                 : Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: isToday ? const Color(0xFF6A5AE0) : Colors.grey.shade200,
//               width: isToday ? 2 : 1,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 '${date.day}',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
//                   color: isPast
//                       ? Colors.grey.shade400
//                       : isToday
//                       ? const Color(0xFF6A5AE0)
//                       : Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               if (isSelected) _buildSelectionIndicator(selectionType),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildSelectionIndicator(DaySelectionType type) {
//     switch (type) {
//       case DaySelectionType.fullDay:
//         return Container(
//           width: 32,
//           height: 4,
//           decoration: BoxDecoration(
//             color: const Color(0xFF6A5AE0),
//             borderRadius: BorderRadius.circular(2),
//           ),
//         );
//       case DaySelectionType.firstHalf:
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 14,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6A5AE0),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(2),
//                   bottomLeft: Radius.circular(2),
//                 ),
//               ),
//             ),
//             Container(
//               width: 14,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(2),
//                   bottomRight: Radius.circular(2),
//                 ),
//               ),
//             ),
//           ],
//         );
//       case DaySelectionType.secondHalf:
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 14,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(2),
//                   bottomLeft: Radius.circular(2),
//                 ),
//               ),
//             ),
//             Container(
//               width: 14,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6A5AE0),
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(2),
//                   bottomRight: Radius.circular(2),
//                 ),
//               ),
//             ),
//           ],
//         );
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   void _showSelectionDialog(DateTime date) {
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 DateFormat('EEEE, MMM dd').format(date),
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildSelectionOption('Full Day', Icons.calendar_today, () {
//                 controller.toggleDaySelection(date, DaySelectionType.fullDay);
//                 Get.back();
//               }),
//               const SizedBox(height: 12),
//               _buildSelectionOption('First Half', Icons.wb_sunny_outlined, () {
//                 controller.toggleDaySelection(date, DaySelectionType.firstHalf);
//                 Get.back();
//               }),
//               const SizedBox(height: 12),
//               _buildSelectionOption(
//                 'Second Half',
//                 Icons.nightlight_outlined,
//                 () {
//                   controller.toggleDaySelection(
//                     date,
//                     DaySelectionType.secondHalf,
//                   );
//                   Get.back();
//                 },
//               ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () => Get.back(),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSelectionOption(
//     String label,
//     IconData icon,
//     VoidCallback onTap,
//   ) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8F9FA),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFFE8E8E8)),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6A5AE0).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: const Color(0xFF6A5AE0), size: 20),
//             ),
//             const SizedBox(width: 16),
//             Text(
//               label,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLegend() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F9FA),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Legend',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               _buildLegendItem('Full Day', DaySelectionType.fullDay),
//               const SizedBox(width: 16),
//               _buildLegendItem('First Half', DaySelectionType.firstHalf),
//               const SizedBox(width: 16),
//               _buildLegendItem('Second Half', DaySelectionType.secondHalf),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegendItem(String label, DaySelectionType type) {
//     return Row(
//       children: [
//         _buildSelectionIndicator(type),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 11, color: Colors.black87),
//         ),
//       ],
//     );
//   }

//   Widget _buildSummaryCard() {
//     return Obx(() {
//       final totalDays = controller.getTotalDays();
//       final selectedCount = controller.selectedDays.length;

//       return Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF6A5AE0), Color(0xFF8B7BFF)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF6A5AE0).withOpacity(0.3),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(
//                 Icons.event_available,
//                 color: Colors.white,
//                 size: 32,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Total Leave Duration',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white70,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Text(
//                         '$totalDays',
//                         style: const TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         totalDays == 1 ? 'Day' : 'Days',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (selectedCount > 0)
//                     Text(
//                       '$selectedCount date${selectedCount > 1 ? 's' : ''} selected',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.white60,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             if (selectedCount > 0)
//               IconButton(
//                 icon: const Icon(Icons.clear, color: Colors.white),
//                 onPressed: () => controller.clearSelections(),
//                 tooltip: 'Clear all',
//               ),
//           ],
//         ),
//       );
//     });
//   }

//   int _getDaysInMonth(DateTime date) {
//     return DateTime(date.year, date.month + 1, 0).day;
//   }

//   bool _isToday(DateTime date) {
//     final now = DateTime.now();
//     return date.year == now.year &&
//         date.month == now.month &&
//         date.day == now.day;
//   }
// }

// // import 'package:dronees/features/authorized/leave/controllers/leave_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:table_calendar/table_calendar.dart';
// // import 'package:get/get.dart';

// // class CustomLeaveCalendar extends StatelessWidget {
// //   final controller = Get.put(LeaveController());

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Obx(
// //           () => TableCalendar(
// //             firstDay: DateTime.now(),
// //             lastDay: DateTime.utc(2030, 12, 31),
// //             focusedDay: controller.focusedDay.value,
// //             rangeStartDay: controller.rangeStart.value,
// //             rangeEndDay: controller.rangeEnd.value,
// //             calendarFormat: CalendarFormat.month,
// //             rangeSelectionMode: RangeSelectionMode.enforced,

// //             // Disable Sundays
// //             enabledDayPredicate: (day) => day.weekday != DateTime.sunday,

// //             onRangeSelected: controller.onRangeSelected,
// //             calendarStyle: CalendarStyle(
// //               rangeHighlightColor: Colors.blue.withOpacity(0.2),
// //               rangeStartDecoration: const BoxDecoration(
// //                 color: Colors.blue,
// //                 shape: BoxShape.circle,
// //               ),
// //               rangeEndDecoration: const BoxDecoration(
// //                 color: Colors.blue,
// //                 shape: BoxShape.circle,
// //               ),
// //             ),
// //           ),
// //         ),

// //         const SizedBox(height: 20),

// //         // Options for Half Days
// //         Obx(
// //           () => Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //             child: Column(
// //               children: [
// //                 _buildToggleTile(
// //                   "Start Day is Half Day",
// //                   controller.isStartHalfDay.value,
// //                   (val) => controller.isStartHalfDay.value = val,
// //                 ),
// //                 if (controller.rangeEnd.value != null &&
// //                     controller.rangeEnd.value != controller.rangeStart.value)
// //                   _buildToggleTile(
// //                     "End Day is Half Day",
// //                     controller.isEndHalfDay.value,
// //                     (val) => controller.isEndHalfDay.value = val,
// //                   ),

// //                 const Divider(),

// //                 // Summary Display
// //                 Container(
// //                   padding: const EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     color: Colors.blue.shade50,
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       const Text(
// //                         "Total Leave Duration:",
// //                         style: TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                       Text(
// //                         "${controller.totalDays} Days",
// //                         style: const TextStyle(
// //                           fontSize: 18,
// //                           color: Colors.blue,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildToggleTile(String title, bool value, Function(bool) onChanged) {
// //     return SwitchListTile(
// //       title: Text(title, style: const TextStyle(fontSize: 14)),
// //       value: value,
// //       onChanged: onChanged,
// //       dense: true,
// //     );
// //   }
// // }
