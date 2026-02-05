import 'dart:io';

import 'package:dronees/features/authorized/attendance/widgets/build_date_picker.dart';
import 'package:dronees/features/authorized/travel_allowance/controllers/submit_travel_allowance_controller.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/custom_bottom_sheet_dropdown.dart';
import 'package:dronees/widgets/custom_file_picker.dart';
import 'package:dronees/widgets/submit_confirmation.dart';

import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/constants/text_strings.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------
const _cardColor = Color(0xFFFFFFFF);
const _bgColor = Color(0xFFF1F3F8);
const _inputFill = Color(0xFFF8F9FA);
const _borderColor = Color(0xFFE8E8E8);
const _accentPurple = Color(0xFF6C5CE7);
const _textDark = Color(0xFF2D3436);
const _textGrey = Color(0xFF636E72);

// ---------------------------------------------------------------------------
// Tour-type dropdown options
// ---------------------------------------------------------------------------
const List<String> _tourTypes = [
  'Field Visit',
  'Client Meeting',
  'Training',
  'Other',
];

class SubmitTravelAllowance extends StatelessWidget {
  SubmitTravelAllowance({super.key});

  final controller = Get.put(SubmitTravelAllowanceController());

  // -----------------------------------------------------------------------
  // Build helpers – shared InputDecoration
  // -----------------------------------------------------------------------
  InputDecoration _inputDecor({
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFB2BEC3), fontSize: 14),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    prefixIconColor: _accentPurple,
    suffixIconColor: _textGrey,
    filled: true,
    fillColor: _inputFill,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _accentPurple, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );

  // -----------------------------------------------------------------------
  // Section header helper
  // -----------------------------------------------------------------------
  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: _textDark,
    ),
  );

  // -----------------------------------------------------------------------
  // Divider with optional label
  // -----------------------------------------------------------------------
  Widget _dividerWithLabel(String label) => Column(
    children: [
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(child: Container(height: 1, color: _borderColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textGrey,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: _borderColor)),
        ],
      ),
      const SizedBox(height: 8),
    ],
  );

  // -----------------------------------------------------------------------
  // Card wrapper
  // -----------------------------------------------------------------------
  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(TSizes.defaultPadding),
    decoration: BoxDecoration(
      color: _cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );

  // =======================================================================
  // Main build
  // =======================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultPadding),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Banner ────────────────────────────────────────────
                      Image.asset(TImages.taBanner),
                      const SizedBox(height: TSizes.defaultPadding),

                      // ── Main form card ────────────────────────────────────
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              TTexts.fillClaim,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              TTexts.imformationAbout,
                              style: TextStyle(fontSize: 13, color: _textGrey),
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            // ── 1. TA Type toggle (Normal / Advance) ────────
                            _sectionLabel('Allowance Type'),
                            const SizedBox(height: 8),
                            Obx(
                              () => _TaTypeToggle(
                                selected: controller.taType.value,
                                onChange: (val) {
                                  if (val == "Normal") {
                                    controller.fromLocationController.clear();
                                    controller.toLocationController.clear();
                                    controller.departureDate.value = null;
                                    controller.returnDate.value = null;
                                    controller.accommodationRequired.value =
                                        false;
                                    controller.advanceRequired.value = false;
                                    controller.totalEstimatedExpenseController
                                        .clear();
                                    controller.amountController.clear();
                                  } else {
                                    controller.selectedDate.value =
                                        DateTime.now();
                                    controller.selectedFile.value = null;
                                    controller.amountController.clear();
                                  }
                                  controller.taType.value = val;
                                },
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            // ── 2. Tour Type dropdown ───────────────────────
                            _sectionLabel('Tour Type'),
                            const SizedBox(height: 8),
                            CustomBottomSheetDropdown(
                              validator: (value) => TValidator.validateNull(
                                value,
                                "Please Select a Tour Type",
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              label: "Tour Type",
                              items: _tourTypes,
                              selectedValue: controller.tourType,
                              onSelect: (val) =>
                                  controller.tourType.value = val,
                            ),

                            const SizedBox(height: TSizes.spaceBtwItems),

                            // ── 4. Other – conditional text field ───────────
                            Obx(
                              () => controller.tourType.value == 'Other'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _sectionLabel('Specify other reason'),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          onTapOutside:
                                              (PointerDownEvent event) {
                                                FocusManager
                                                    .instance
                                                    .primaryFocus
                                                    ?.unfocus();
                                              },
                                          validator: (value) =>
                                              TValidator.emptyValidator(
                                                value,
                                                "Reason",
                                              ),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          maxLines: 3,
                                          controller:
                                              controller.otherSpecifyController,
                                          decoration: _inputDecor(
                                            hint: 'Describe the tour reason…',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: TSizes.spaceBtwItems,
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),

                            // ── 3. Upload image ─────────────────────────────
                            Obx(
                              () => controller.taType.value == 'Advance'
                                  ? const SizedBox.shrink()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _sectionLabel('Upload Claim Document'),
                                        const SizedBox(height: 6),
                                        CustomFilePicker(
                                          title: "Upload Claim Document",
                                          subTitle:
                                              "Take a photo of the equipment condition now",
                                          onPick: controller.pickDocument,
                                          initialValue:
                                              controller.selectedFile.value,
                                          validator: (value) =>
                                              TValidator.validateNull(
                                                value,
                                                "Please Provide a Image",
                                              ),
                                        ),
                                        const SizedBox(
                                          height: TSizes.spaceBtwItems,
                                        ),
                                        _sectionLabel(
                                          'Transaction Date (Max 2 days Back)',
                                        ),
                                        const SizedBox(height: 6),
                                        Obx(
                                          () => buildDatePicker(
                                            context,
                                            controller.selectedDate.value,
                                            DateTime.now().subtract(
                                              const Duration(days: 2),
                                            ),
                                            DateTime.now(),
                                            (DateTime pickedDate) {
                                              controller.setDate(pickedDate);
                                            },
                                            (value) => TValidator.validateNull(
                                              value,
                                              "Select Transation Date",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: TSizes.defaultPadding,
                                        ),
                                        // ── 6. Amount ───────────────────────────────────
                                        _sectionLabel('Allowance Amount (₹)'),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          onTapOutside:
                                              (PointerDownEvent event) {
                                                FocusManager
                                                    .instance
                                                    .primaryFocus
                                                    ?.unfocus();
                                              },
                                          validator: TValidator.validateAmount,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller:
                                              controller.amountController,
                                          keyboardType: TextInputType.number,
                                          decoration: _inputDecor(
                                            hint: 'Amount',
                                            prefixIcon: const Icon(
                                              Icons.currency_rupee_outlined,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: TSizes.defaultPadding,
                                        ),
                                      ],
                                    ),
                            ),

                            // ── 7. Purpose ──────────────────────────────────
                            _sectionLabel('Purpose Description'),
                            const SizedBox(height: 6),
                            TextFormField(
                              validator: (value) =>
                                  TValidator.emptyValidator(value, "Purpose"),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTapOutside: (PointerDownEvent event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              controller: controller.purposeController,
                              minLines: 3,
                              maxLines: 6,
                              decoration: _inputDecor(hint: 'Purpose'),
                            ),
                          ],
                        ),
                      ),

                      // ── Advance Details card (conditional) ────────────────
                      Obx(
                        () => controller.taType.value == 'Advance'
                            ? Column(
                                children: [
                                  const SizedBox(height: TSizes.defaultPadding),
                                  _card(_buildAdvanceDetailsSection(context)),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: TSizes.defaultPadding),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom submit bar ─────────────────────────────────────────
          _buildSubmitBar(context),
        ],
      ),
    );
  }

  // =======================================================================
  // AppBar
  // =======================================================================
  AppBar _buildAppBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 14.0 : 0),
        child: const Icon(
          Iconsax.arrow_left_2_copy,
          color: Colors.black,
          size: 20,
        ),
      ),
      onPressed: () => Get.back(),
    ),
    title: Padding(
      padding: EdgeInsets.only(top: Platform.isAndroid ? 14.0 : 0),
      child: const Text(
        'Submit Travel Allowance',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    centerTitle: true,
  );

  // =======================================================================
  // Advance details section
  // =======================================================================
  Widget _buildAdvanceDetailsSection(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ── Section header ──────────────────────────────────────────
      Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: _accentPurple,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Travel Advance Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      const Text(
        'Fill in the details for your advance request',
        style: TextStyle(fontSize: 13, color: _textGrey),
      ),

      _dividerWithLabel('LOCATIONS'),

      // ── From location ─────────────────────────────────────────
      _sectionLabel('From'),
      const SizedBox(height: 6),
      TextFormField(
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        validator: (value) => TValidator.emptyValidator(value, 'From Location'),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller.fromLocationController,
        decoration: _inputDecor(
          hint: 'Starting location',
          prefixIcon: const Icon(Iconsax.location_tick, size: 20),
        ),
      ),
      const SizedBox(height: TSizes.spaceBtwItems),

      // ── To location ───────────────────────────────────────────
      _sectionLabel('To'),
      const SizedBox(height: 6),
      TextFormField(
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        validator: (value) => TValidator.emptyValidator(value, 'To Location'),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller.toLocationController,
        decoration: _inputDecor(
          hint: 'Destination',
          prefixIcon: const Icon(Iconsax.location, size: 20),
        ),
      ),

      _dividerWithLabel('TRAVEL DATES'),

      // ── Departure date ────────────────────────────────────────
      _sectionLabel('Departure Date'),
      const SizedBox(height: 6),
      buildDatePicker(
        context,
        controller.departureDate.value,
        DateTime.now(),
        DateTime.now().add(const Duration(days: 365)),
        (DateTime picked) => controller.departureDate.value = picked,
        (value) => TValidator.validateNull(value, "Select Departure Date."),
      ),
      const SizedBox(height: TSizes.spaceBtwItems),

      // ── Return date ───────────────────────────────────────────
      _sectionLabel('Return Date'),
      const SizedBox(height: 6),
      Obx(
        () => buildDatePicker(
          context,
          controller.returnDate.value,
          controller.departureDate.value ??
              DateTime.now(), // cannot be before departure
          DateTime.now().add(const Duration(days: 365)),
          (DateTime picked) => controller.returnDate.value = picked,
          (value) => TValidator.validateNull(value, "Select return Date."),
        ),
      ),

      _dividerWithLabel('OPTIONS'),

      // ── Accommodation & Advance toggles ───────────────────────
      Obx(
        () => _ToggleRow(
          icon: Iconsax.hospital,
          label: 'Accommodation Required',
          value: controller.accommodationRequired.value,
          onToggle: (v) => controller.accommodationRequired.value = v,
        ),
      ),
      const SizedBox(height: 12),
      Obx(
        () => _ToggleRow(
          icon: Iconsax.money,
          label: 'Advance Required',
          value: controller.advanceRequired.value,
          onToggle: (v) => controller.advanceRequired.value = v,
        ),
      ),

      _dividerWithLabel('EXPENSES'),

      // ── Total estimated expense ───────────────────────────────
      _sectionLabel('Total Estimated Expense (₹)'),
      const SizedBox(height: 6),
      TextFormField(
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        validator: TValidator.validateAmount,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller.totalEstimatedExpenseController,
        keyboardType: TextInputType.number,
        decoration: _inputDecor(
          hint: 'Estimated total',
          prefixIcon: const Icon(Icons.currency_rupee_outlined, size: 20),
        ),
      ),
      const SizedBox(height: TSizes.spaceBtwItems),
      Obx(
        () => controller.advanceRequired.value
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Advance amount ────────────────────────────────────────
                  _sectionLabel('Advance Amount (₹)'),
                  const SizedBox(height: 6),
                  TextFormField(
                    onTapOutside: (PointerDownEvent event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: TValidator.validateAmount,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller.advanceAmountController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecor(
                      hint: 'Advance amount',
                      prefixIcon: const Icon(
                        Icons.currency_rupee_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    ],
  );

  // =======================================================================
  // Submit bar
  // =======================================================================
  Widget _buildSubmitBar(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(
      TSizes.defaultPadding,
      TSizes.defaultPadding,
      TSizes.defaultPadding,
      0,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            if (controller.formKey.currentState!.validate()) {
              SubmitConfirmationSheet.show(
                context,
                icon: Iconsax.receipt_2,
                title: TTexts.readyToSubmit,
                subtitle: TTexts.doubleCheck,
                confirmButtonText: TTexts.yesSubmit,
                cancelButtonText: TTexts.noLetme,
                onConfirm: controller.submitAllowance,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentPurple,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Submit Allowance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ),
  );
}

// ==========================================================================
// TA-Type Toggle widget  (Normal ↔ Advance)
// ==========================================================================
class _TaTypeToggle extends StatelessWidget {
  const _TaTypeToggle({required this.selected, required this.onChange});

  final String selected;
  final void Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    // Determine the alignment for the sliding background
    final alignment = selected == 'Normal'
        ? Alignment.centerLeft
        : Alignment.centerRight;

    return Container(
      height: 48,
      padding: const EdgeInsets.all(
        4,
      ), // Padding so the pill doesn't touch the borders
      decoration: BoxDecoration(
        color: _inputFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Stack(
        children: [
          // 1. The Sliding Background (The "Thumb")
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve:
                Curves.easeOutBack, // Adds a slight, organic "overshoot" effect
            alignment: alignment,
            child: FractionallySizedBox(
              widthFactor: 0.5, // Covers half the width
              child: Container(
                decoration: BoxDecoration(
                  color: _accentPurple,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _accentPurple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. The Interactive Labels
          Row(
            children: [
              _pill('Normal', Iconsax.note),
              _pill('Advance', Iconsax.money_change),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, IconData icon) {
    final bool active = selected == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChange(label),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated color swap for the icon and text
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : _textGrey,
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: active ? Colors.white : _textGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// Boolean toggle row  (icon + label + Switch)
// ==========================================================================
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onToggle,
  });

  final IconData icon;
  final String label;
  final bool value;
  final void Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: value
                  ? _accentPurple.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 18,
                color: value ? _accentPurple : _textGrey,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: _textDark),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onToggle,
            activeColor: _accentPurple,
            activeTrackColor: _accentPurple.withOpacity(0.35),
          ),
        ],
      ),
    );
  }
}
