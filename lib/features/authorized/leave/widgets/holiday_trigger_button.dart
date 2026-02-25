import 'package:dronees/features/authorized/leave/models/holiday_leave.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HolidayTriggerButton extends StatelessWidget {
  final HolidayLeave? selected;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onTap;

  const HolidayTriggerButton({
    super.key,
    required this.selected,
    required this.isLoading,
    required this.hasError,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelected = selected != null;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: hasSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFFF3E0), Color(0xFFFFECB3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: hasSelected ? null : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasError
                ? Colors.red.shade400
                : hasSelected
                ? const Color(0xFFFFB300).withOpacity(0.6)
                : const Color(0xFFE8E8E8),
            width: hasSelected ? 1.5 : 1,
          ),
          boxShadow: hasSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFB300).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon area
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasSelected
                    ? const Color(0xFFFFB300).withOpacity(0.2)
                    : const Color(0xFF6A5AE0).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6A5AE0),
                      ),
                    )
                  : Center(
                      child: Text(
                        hasSelected ? '🏮' : '🎉',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            // Text area
            Expanded(
              child: hasSelected
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selected!.holidayName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A3800),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat(
                            'EEEE, MMM dd yyyy',
                          ).format(selected!.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.brown.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      isLoading
                          ? 'Loading holidays...'
                          : 'Select a Floating Holiday',
                      style: TextStyle(
                        fontSize: 15,
                        color: hasError
                            ? Colors.red.shade400
                            : Colors.grey.shade500,
                      ),
                    ),
            ),

            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: hasSelected
                  ? const Color(0xFFFFB300)
                  : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
