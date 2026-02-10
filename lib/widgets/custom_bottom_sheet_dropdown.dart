import 'dart:async';

import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

// class CustomBottomSheetDropdown extends StatelessWidget {
//   final IconData? icon;
//   final String label;
//   final List<String> items;
//   final Rxn<String> selectedValue;
//   final Function(String) onSelect;
//   final String? Function(String?)? validator;
//   final AutovalidateMode autovalidateMode;
//   final String? errorText;
//   final bool isSearchable;

//   // New props for Remote Search
//   final RxBool isLoading;
//   final Function(String)? onSearchChanged;

//   const CustomBottomSheetDropdown({
//     super.key,
//     required this.label,
//     required this.items,
//     required this.selectedValue,
//     required this.onSelect,
//     this.validator,
//     this.icon,
//     this.autovalidateMode = AutovalidateMode.disabled,
//     this.errorText,
//     this.isSearchable = false,
//     required this.isLoading, // Pass the controller's loading state
//     this.onSearchChanged, // Pass the function that calls the API
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FormField<String>(
//       validator: validator,
//       initialValue: selectedValue.value,
//       autovalidateMode: autovalidateMode,
//       builder: (FormFieldState<String> state) {
//         final hasError = state.hasError || errorText != null;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () => _showBottomSheet(context, state),
//               child: Obx(() {
//                 final isSelected = selectedValue.value != null;
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isSelected ? Colors.white : const Color(0xFFF8F9FA),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: hasError
//                           ? Colors.red.shade400
//                           : const Color(0xFFE8E8E8),
//                       width: isSelected ? 1.5 : 1,
//                     ),
//                     boxShadow: isSelected
//                         ? [
//                             BoxShadow(
//                               color: TColors.primary.withOpacity(0.05),
//                               blurRadius: 10,
//                               offset: const Offset(0, 4),
//                             ),
//                           ]
//                         : [],
//                   ),
//                   child: Row(
//                     children: [
//                       if (icon != null) ...[
//                         Icon(
//                           icon,
//                           color: isSelected ? TColors.primary : Colors.grey,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 12),
//                       ],
//                       Expanded(
//                         child: Text(
//                           selectedValue.value ?? label,
//                           style: TextStyle(
//                             color: isSelected
//                                 ? Colors.black87
//                                 : Colors.grey.shade600,
//                             fontSize: 15,
//                             fontWeight: isSelected
//                                 ? FontWeight.w600
//                                 : FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Iconsax.arrow_down_1_copy,
//                         size: 18,
//                         color: hasError ? Colors.red.shade400 : Colors.black45,
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//             if (hasError)
//               Padding(
//                 padding: const EdgeInsets.only(left: 12, top: 8),
//                 child: Text(
//                   errorText ?? state.errorText!,
//                   style: TextStyle(
//                     color: Colors.red.shade700,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   void _showBottomSheet(BuildContext context, FormFieldState<String> state) {
//     Timer? debounce; // Local timer for debouncing

//     CustomBlurBottomSheet.show(
//       context,
//       widget: Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.8,
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Handle Bar
//             Container(
//               width: 45,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "Select $label",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
//             ),
//             const SizedBox(height: 20),

//             // Only show search bar if isSearchable is true
//             if (isSearchable) ...[
//               TextField(
//                 onChanged: (val) {
//                   // Debounce logic: wait 500ms after last keystroke
//                   if (debounce?.isActive ?? false) debounce?.cancel();
//                   debounce = Timer(const Duration(milliseconds: 500), () {
//                     if (onSearchChanged != null) onSearchChanged!(val);
//                   });
//                 },
//                 decoration: InputDecoration(
//                   hintText: "Search $label...",
//                   prefixIcon: const Icon(
//                     Iconsax.search_normal_1_copy,
//                     size: 20,
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide(color: Colors.grey.shade200),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],

//             Flexible(
//               child: Obx(() {
//                 // 1. Show loading ONLY when searching is active
//                 if (isLoading.value) {
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 40),
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         strokeWidth: 3,
//                         color: Color(0xFF6C5CE7), // Matches your primary color
//                       ),
//                     ),
//                   );
//                 }

//                 // 2. Empty State
//                 if (items.isEmpty) {
//                   return _buildEmptyState();
//                 }

//                 // 3. The List
//                 return ListView.separated(
//                   shrinkWrap: true,
//                   padding: const EdgeInsets.only(bottom: 20),
//                   itemCount: items.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 8),
//                   itemBuilder: (context, index) {
//                     final item = items[index];
//                     final bool isSelected = selectedValue.value == item;
//                     return _buildItemTile(item, isSelected, state);
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 40),
//       child: Column(
//         children: [
//           Icon(Iconsax.search_status, size: 40, color: Colors.grey.shade300),
//           const SizedBox(height: 12),
//           Text(
//             "No results found",
//             style: TextStyle(color: Colors.grey.shade500),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildItemTile(
//     String item,
//     bool isSelected,
//     FormFieldState<String> state,
//   ) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           onSelect(item);
//           state.didChange(item);
//           Get.back();
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: isSelected
//                 ? TColors.primary.withOpacity(0.1)
//                 : Colors.transparent,
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   item,
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
//                     color: isSelected ? TColors.primary : Colors.black87,
//                   ),
//                 ),
//               ),
//               if (isSelected)
//                 Icon(
//                   Iconsax.tick_circle_copy,
//                   color: TColors.primary,
//                   size: 20,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomBottomSheetDropdown<T> extends StatelessWidget {
  final IconData? icon;
  final String label;
  final List<T> items;
  final Rxn<T> selectedValue;
  final Function(T) onSelect;
  final String? Function(T?)? validator;
  final AutovalidateMode autovalidateMode;
  final String? errorText;
  final bool isSearchable;

  // New props for Remote Search
  final RxBool isLoading;
  final Function(String)? onSearchChanged;

  // Generic helper functions
  final String Function(T) displayText; // Convert object to display string
  final String Function(T)?
  searchText; // Optional: custom search text extraction

  const CustomBottomSheetDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onSelect,
    required this.displayText, // Required to show the object as string
    this.validator,
    this.icon,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.errorText,
    this.isSearchable = false,
    required this.isLoading,
    this.onSearchChanged,
    this.searchText, // Optional custom search text
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      validator: validator,
      initialValue: selectedValue.value,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<T> state) {
        final hasError = state.hasError || errorText != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showBottomSheet(context, state),
              child: Obx(() {
                final isSelected = selectedValue.value != null;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasError
                          ? Colors.red.shade400
                          : const Color(0xFFE8E8E8),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: TColors.primary.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: isSelected ? TColors.primary : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          selectedValue.value != null
                              ? displayText(selectedValue.value!)
                              : label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black87
                                : Colors.grey.shade600,
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      Icon(
                        Iconsax.arrow_down_1_copy,
                        size: 18,
                        color: hasError ? Colors.red.shade400 : Colors.black45,
                      ),
                    ],
                  ),
                );
              }),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text(
                  errorText ?? state.errorText!,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, FormFieldState<T> state) {
    Timer? debounce;

    CustomBlurBottomSheet.show(
      context,
      widget: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Select $label",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),

            // Search bar
            if (isSearchable) ...[
              TextField(
                onChanged: (val) {
                  if (debounce?.isActive ?? false) debounce?.cancel();
                  debounce = Timer(const Duration(milliseconds: 500), () {
                    if (onSearchChanged != null) onSearchChanged!(val);
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search $label...",
                  prefixIcon: const Icon(
                    Iconsax.search_normal_1_copy,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            Flexible(
              child: Obx(() {
                // Loading state
                if (isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  );
                }

                // Empty state
                if (items.isEmpty) {
                  return _buildEmptyState();
                }

                // List
                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final bool isSelected = selectedValue.value == item;
                    return _buildItemTile(item, isSelected, state);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Iconsax.search_status, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            "No results found",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(T item, bool isSelected, FormFieldState<T> state) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSelect(item);
          state.didChange(item);
          Get.back();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? TColors.primary.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayText(item),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? TColors.primary : Colors.black87,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Iconsax.tick_circle_copy,
                  color: TColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
