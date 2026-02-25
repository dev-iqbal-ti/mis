import 'package:dronees/features/authorized/attendance/widgets/build_date_picker.dart';
import 'package:dronees/features/authorized/bd_visit/controllers/bd_visit_controller.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/custom_bottom_sheet_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BDVisitCreateScreen extends StatelessWidget {
  const BDVisitCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BDVisitController.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8), // Matching FieldTask background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Business Development Visit",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TSizes.defaultPadding),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // Header Banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        TImages.taskBanner,
                      ), // Using your standard banner
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Form Container
                    Container(
                      padding: const EdgeInsets.all(TSizes.defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Client Information ---
                          _buildLabel("Select Existing Client (Optional)"),
                          CustomBottomSheetDropdown<String>(
                            displayText: (value) => value,
                            isLoading: RxBool(false),
                            label: "Select Client",
                            validator: null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            items: controller.clients,
                            selectedValue: controller.selectedClient,
                            onSelect: (val, state) {
                              controller.selectedClient.value = val;
                              state.didChange(val);
                            },
                            icon: Iconsax.user,
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          _buildLabel("Client Name *"),
                          _buildTextField(
                            controller: controller.clientNameController,
                            hint: "Enter client name",
                            icon: Iconsax.user_edit,
                            validator: (value) => TValidator.validateNull(
                              value,
                              "Client name is required.",
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          // --- Visit Details ---
                          _buildLabel("Visit Type *"),
                          CustomBottomSheetDropdown<String>(
                            displayText: (value) => _formatEnumValue(value),
                            isLoading: RxBool(false),
                            label: "Select Visit Type",
                            validator: (value) => TValidator.validateNull(
                              value,
                              "Visit type is required.",
                            ),
                            items: controller.visitTypes,
                            selectedValue: controller.selectedVisitType,
                            onSelect: (val, state) {
                              controller.selectedVisitType.value = val;
                              state.didChange(val);
                            },
                            icon: Iconsax.category,
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          _buildLabel("Visit Mode *"),
                          CustomBottomSheetDropdown<String>(
                            displayText: (value) => _formatEnumValue(value),
                            isLoading: RxBool(false),
                            label: "Select Mode",
                            validator: (value) => TValidator.validateNull(
                              value,
                              "Visit mode is required.",
                            ),
                            items: controller.visitModes,
                            selectedValue: controller.selectedVisitMode,
                            onSelect: (val, state) {
                              controller.selectedVisitMode.value = val;
                              state.didChange(val);
                            },
                            icon: Iconsax.location,
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          _buildLabel("Purpose *"),
                          _buildTextField(
                            controller: controller.purposeController,
                            hint: "Enter visit purpose",
                            icon: Iconsax.document_text,
                            maxLines: 2,
                            validator: (value) => TValidator.validateNull(
                              value,
                              "Purpose is required.",
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          // --- Schedule ---
                          _buildLabel("Departure Date"),
                          buildDatePicker(
                            context,
                            controller.departureDate.value,
                            DateTime.now(),
                            DateTime.now().add(const Duration(days: 365)),
                            (DateTime picked) =>
                                controller.departureDate.value = picked,
                            (value) => TValidator.validateNull(
                              value,
                              "Select Departure Date.",
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          _buildLabel("Return Date"),
                          Obx(
                            () => buildDatePicker(
                              context,
                              controller.returnDate.value,
                              controller.departureDate.value ?? DateTime.now(),
                              DateTime.now().add(const Duration(days: 365)),
                              (DateTime picked) =>
                                  controller.returnDate.value = picked,
                              (value) => TValidator.validateNull(
                                value,
                                "Select return Date.",
                              ),
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          // --- Discussion ---
                          _buildLabel("Discussion Summary"),
                          _buildTextField(
                            controller: controller.discussionSummaryController,
                            hint: "Enter summary (optional)",
                            icon: Iconsax.note_text,
                            maxLines: 3,
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          // _buildLabel("Deal Stage *"),
                          // CustomBottomSheetDropdown<String>(
                          //   displayText: (value) => _formatEnumValue(value),
                          //   isLoading: RxBool(false),
                          //   label: "Select Deal Stage",
                          //   validator: (value) => TValidator.validateNull(
                          //     value,
                          //     "Deal stage is required.",
                          //   ),
                          //   items: controller.dealStages,
                          //   selectedValue: controller.selectedDealStage,
                          //   onSelect: (val) =>
                          //       controller.selectedDealStage.value = val,
                          //   icon: Iconsax.status,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildSubmitButton(controller),
        ],
      ),
    );
  }

  // --- Helper Widgets matching FieldTask UI ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF6C5CE7), size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BDVisitController controller) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultPadding),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.submitForm(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7), // Brand Purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Submit Visit Request",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatEnumValue(String value) {
    return value
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
