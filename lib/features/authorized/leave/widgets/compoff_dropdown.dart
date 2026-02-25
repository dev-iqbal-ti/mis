import 'package:dronees/features/authorized/leave/models/comp_off.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompOffDropdown extends StatelessWidget {
  final List<CompOff> compOffs;
  final Rx<CompOff?> selectedCompOff;
  final void Function(CompOff) onSelect;
  final bool isLoading;
  final String? Function(CompOff?)? validator;

  const CompOffDropdown({
    super.key,
    required this.compOffs,
    required this.selectedCompOff,
    required this.onSelect,
    this.isLoading = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<CompOff>(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => _CompOffTriggerButton(
                selected: selectedCompOff.value,
                isLoading: isLoading,
                hasError: state.hasError,
                onTap: () => _showSheet(context, state),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 6),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showSheet(BuildContext context, FormFieldState<CompOff> state) {
    CustomBlurBottomSheet.show(
      context,
      widget: _CompOffBottomSheet(
        compOffs: compOffs,
        selected: selectedCompOff.value,
        onSelect: (c) {
          selectedCompOff.value = c;
          state.didChange(c);
          onSelect(c);
          Get.back();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Trigger Button
// ─────────────────────────────────────────────
class _CompOffTriggerButton extends StatelessWidget {
  final CompOff? selected;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onTap;

  const _CompOffTriggerButton({
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: hasSelected
              ? const Color(0xFFE3F2FD)
              : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasError
                ? Colors.red
                : hasSelected
                ? const Color(0xFF2196F3)
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.work_outline, color: Color(0xFF2196F3)),
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: hasSelected
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Comp Off Selected",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          DateFormat(
                            'EEEE, MMM dd yyyy',
                          ).format(selected!.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      isLoading
                          ? 'Loading comp off...'
                          : 'Select Comp Off Date',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
            ),

            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom Sheet
// ─────────────────────────────────────────────

class _CompOffBottomSheet extends StatelessWidget {
  final List<CompOff> compOffs;
  final CompOff? selected;
  final void Function(CompOff) onSelect;

  const _CompOffBottomSheet({
    required this.compOffs,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Grab Handle ---
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // --- Header ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Comp Off",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      "${compOffs.length} available balance",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                // Close Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // --- List Content ---
          Expanded(child: compOffs.isEmpty ? _buildEmptyState() : _buildList()),

          const SizedBox(height: 16), // Bottom safe area padding
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: compOffs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final item = compOffs[i];
        final isSelected = selected?.date == item.date;

        return InkWell(
          onTap: () => onSelect(item),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF6A5AE0).withOpacity(0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6A5AE0)
                    : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF6A5AE0).withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Icon Decoration
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6A5AE0)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event_available,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Date Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, MMM dd').format(item.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy').format(item.date),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selected Indicator
                if (isSelected)
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF6A5AE0),
                    child: Icon(Icons.check, color: Colors.white, size: 16),
                  )
                else
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No Comp Off Available",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "You haven't earned any compensatory leaves yet.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
