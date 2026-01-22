import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CustomBottomSheetDropdown extends StatelessWidget {
  final IconData? icon;
  final String label;
  final List<String> items;
  final Rxn<String> selectedValue;
  final Function(String) onSelect;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final String? errorText;
  final bool isSearchable; // Added searchable flag

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
    this.isSearchable = false, // Default to false
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
                      color: state.hasError
                          ? Colors.red.shade700
                          : const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF8F9FA),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            icon != null
                                ? Icon(icon, color: TColors.primary, size: 20)
                                : const SizedBox.shrink(),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                selectedValue.value ?? label,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: selectedValue.value == null
                                      ? Colors.grey
                                      : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Iconsax.arrow_down_1_copy,
                        color: state.hasError
                            ? Colors.red.shade700
                            : Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
    final searchQuery = "".obs;
    final filteredItems = <String>[].obs;
    filteredItems.assignAll(items);

    return CustomBlurBottomSheet.show(
      context,
      widget: Container(
        padding: const EdgeInsets.all(TSizes.defaultPadding),
        // constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: TSizes.defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              "Select $label",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: TSizes.minSpaceBtw),

            // Search Field
            if (isSearchable)
              TextField(
                onChanged: (val) {
                  searchQuery.value = val;
                  filteredItems.assignAll(
                    items
                        .where(
                          (item) =>
                              item.toLowerCase().contains(val.toLowerCase()),
                        )
                        .toList(),
                  );
                },
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Iconsax.search_status),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            if (isSearchable) const SizedBox(height: 10),

            const Divider(),
            Flexible(
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      title: Text(item),
                      trailing: selectedValue.value == item
                          ? Icon(Icons.check_circle, color: TColors.primary)
                          : null,
                      onTap: () {
                        onSelect(item);
                        state.didChange(item);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Get.bottomSheet(
    //   isScrollControlled: true,
    //   Container(
    //     padding: const EdgeInsets.all(20),
    //     constraints: BoxConstraints(maxHeight: Get.height * 0.8),
    //     decoration: const BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    //     ),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text(
    //           "Select $label",
    //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //         ),
    //         const SizedBox(height: 15),

    //         // Search Field
    //         if (isSearchable)
    //           TextField(
    //             onChanged: (val) {
    //               searchQuery.value = val;
    //               filteredItems.assignAll(
    //                 items
    //                     .where(
    //                       (item) =>
    //                           item.toLowerCase().contains(val.toLowerCase()),
    //                     )
    //                     .toList(),
    //               );
    //             },
    //             decoration: InputDecoration(
    //               hintText: "Search...",
    //               prefixIcon: const Icon(Iconsax.search_status),
    //               filled: true,
    //               fillColor: Colors.grey.shade100,
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(12),
    //                 borderSide: BorderSide.none,
    //               ),
    //             ),
    //           ),
    //         if (isSearchable) const SizedBox(height: 10),

    //         const Divider(),
    //         Flexible(
    //           child: Obx(
    //             () => ListView.builder(
    //               shrinkWrap: true,
    //               itemCount: filteredItems.length,
    //               itemBuilder: (context, index) {
    //                 final item = filteredItems[index];
    //                 return ListTile(
    //                   title: Text(item),
    //                   trailing: selectedValue.value == item
    //                       ? Icon(Icons.check_circle, color: TColors.primary)
    //                       : null,
    //                   onTap: () {
    //                     onSelect(item);
    //                     state.didChange(item);
    //                     Get.back();
    //                   },
    //                 );
    //               },
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
