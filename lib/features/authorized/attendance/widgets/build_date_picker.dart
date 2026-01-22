import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

Widget buildDatePicker(
  BuildContext context,
  DateTime selectedDate,
  DateTime fistDate,
  DateTime lastDate,
  Function onSelectDate,
) {
  String _month(int m) {
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
    return months[m - 1];
  }

  String formatDate(DateTime date) {
    return "${date.day} ${_month(date.month)} ${date.year}";
  }

  return GestureDetector(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,

        firstDate: fistDate,
        lastDate: lastDate,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF6A5AE0), // Purple
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        // selectedDate = picked;
        onSelectDate(picked);
        // fetch attendance for this date
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 18, color: Color(0xFF6A5AE0)),
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
