import 'package:dronees/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheetDropdown extends StatelessWidget {
  final IconData? icon;
  final String label;
  final List<String> items;
  final Rxn<String> selectedValue;
  final Function(String) onSelect;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final String? errorText;

  const CustomBottomSheetDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onSelect,
    this.validator,
    this.icon,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      initialValue: selectedValue.value,
      autovalidateMode: autovalidateMode,

      builder: (FormFieldState<String> state) {
        final effectiveErrorText = errorText ?? state.errorText;
        final hasError = effectiveErrorText != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showBottomSheet(context, state),
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      // Change border color if there is a validation error
                      color: state.hasError
                          ? Colors.red.shade700
                          : Color(0xFFE8E8E8),
                      width: state.hasError ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: <Widget>[
                          icon != null
                              ? Icon(icon, color: TColors.primary)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Text(
                            selectedValue.value ?? label,
                            style: TextStyle(
                              color: selectedValue.value == null
                                  ? Colors.grey
                                  : Colors.black,
                              letterSpacing: selectedValue.value == null
                                  ? 1
                                  : 1.5,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: state.hasError
                            ? Colors.red.shade700
                            : Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Display error message if validation fails
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 6),
                child: Text(
                  effectiveErrorText,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, FormFieldState<String> state) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select $label",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      onSelect(items[index]);
                      state.didChange(items[index]); // Update FormField state
                      Get.back();
                    },
                    trailing: selectedValue.value == items[index]
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
