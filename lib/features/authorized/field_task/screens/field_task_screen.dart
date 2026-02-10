import 'package:dronees/features/authorized/field_task/controllers/field_task_controller.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/constants/text_strings.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/custom_bottom_sheet_dropdown.dart';
import 'package:dronees/widgets/submit_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ephone_field/ephone_field.dart'; // Ensure this package is in pubspec

class FieldTaskScreen extends StatelessWidget {
  const FieldTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FieldTaskController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Task Completion Form",
          style: TextStyle(color: Colors.black, fontSize: 18),
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
                key: controller.taskFormKey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(TImages.taskBanner),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),
                    Container(
                      padding: const EdgeInsets.all(TSizes.defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Client Name"),
                          TextFormField(
                            controller: controller.clientNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: _buildInputDecoration(
                              hint: "Enter client name",
                              icon: Iconsax.user,
                            ),
                            validator: (value) =>
                                TValidator.emptyValidator(value, "Client Name"),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          _buildLabel("Client Phone Number"),
                          EPhoneField(
                            controller: controller.phoneController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            phoneValidator: TValidator.validatePhoneNumber,
                            initialCountry: Country.india,
                            countries: const [Country.india],
                            initialType: EphoneFieldType.phone,
                            decoration: _buildInputDecoration(
                              hint: "Phone Number",
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildLabel("Client Project"),
                          CustomBottomSheetDropdown<String>(
                            displayText: (value) => value,
                            isLoading: RxBool(false),
                            validator: (value) => TValidator.validateNull(
                              value,
                              "Project is required.",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            label: "Select Project",
                            items: controller.projects,
                            selectedValue: controller.selectedProject,
                            onSelect: (val) =>
                                controller.selectedProject.value = val,
                            icon: Iconsax.folder,
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildLabel("Work Type"),
                          CustomBottomSheetDropdown<String>(
                            displayText: (value) => value,
                            isLoading: RxBool(false),
                            label: "Work Type",
                            validator: (value) => TValidator.validateNull(
                              value,
                              "Work type is required.",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            items: controller.workTypes,
                            selectedValue: controller.selectedWorkType,
                            onSelect: (val) =>
                                controller.selectedWorkType.value = val,
                            icon: Iconsax.setting_4,
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems),

                          _buildLabel("Team Members"),
                          FormField<List<String>>(
                            initialValue: controller.selectedTeamMembers,
                            // validator: TValidator.validateTeamMember,
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            // onSaved: (newValue) {
                            //   controller.selectedTeamMembers.value = newValue ?? [];
                            // },
                            builder: (FormFieldState<List<String>> field) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => _showMultiSelectSheet(
                                      context,
                                      controller,
                                      field,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      constraints: const BoxConstraints(
                                        minHeight: 55,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: field.hasError
                                              ? TColors.error
                                              : const Color(0xFFE8E8E8),
                                        ),
                                      ),
                                      child: field.value?.isEmpty ?? false
                                          ? const Text(
                                              "Select Team Members",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            )
                                          : Wrap(
                                              spacing: 8,
                                              runSpacing: 4,
                                              children: field.value!
                                                  .map(
                                                    (e) => Chip(
                                                      label: Text(
                                                        e,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      deleteIcon: const Icon(
                                                        Icons.close,
                                                        size: 14,
                                                      ),
                                                      onDeleted: () =>
                                                          controller
                                                              .toggleTeamMember(
                                                                e,
                                                              ),
                                                      backgroundColor: TColors
                                                          .primary
                                                          .withOpacity(0.1),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                    ),
                                  ),
                                  if (field.hasError)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        top: 8.0,
                                      ),
                                      child: Text(
                                        field.errorText!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: TColors.error,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          _buildLabel("Geo Location (Auto-detected)"),
                          TextFormField(
                            controller: controller.locationController,
                            readOnly: true,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            decoration: _buildInputDecoration(
                              hint: "Detecting location...",
                              icon: Iconsax.location,
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildLabel("Nature of Job"),
                          CustomBottomSheetDropdown<String>(
                            displayText: (value) => value,
                            isLoading: RxBool(false),
                            validator: (value) => TValidator.validateNull(
                              value,
                              "Nature of job is required.",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            label: "Nature of Job",
                            items: controller.jobNatureList,
                            selectedValue: controller.selectedNatureOfJob,
                            onSelect: (val) =>
                                controller.selectedNatureOfJob.value = val,
                            icon: Iconsax.briefcase,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildSubmitButton(context, controller),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  void _showMultiSelectSheet(
    BuildContext context,
    FieldTaskController controller,
    FormFieldState<List<String>> field,
  ) {
    final searchQuery = "".obs;
    final filteredItems = <String>[].obs;
    filteredItems.assignAll(controller.teamMembers);

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const Text(
              "Select Team Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                filteredItems.assignAll(
                  controller.teamMembers
                      .where((m) => m.toLowerCase().contains(val.toLowerCase()))
                      .toList(),
                );
              },
              decoration: InputDecoration(
                hintText: "Search team...",
                prefixIcon: const Icon(Iconsax.search_status),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final member = filteredItems[index];
                    return Obx(
                      () => CheckboxListTile(
                        title: Text(member),
                        value: controller.selectedTeamMembers.contains(member),
                        activeColor: TColors.primary,
                        onChanged: (_) => controller.toggleTeamMember(member),
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                field.didChange(controller.selectedTeamMembers);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: TColors.primary,
              ),
              child: const Text("Done", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({String? hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null
          ? Icon(icon, color: const Color(0xFF6C5CE7), size: 20)
          : null,
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
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    FieldTaskController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (controller.taskFormKey.currentState!.validate()) {
                SubmitConfirmationSheet.show(
                  context,
                  icon: Iconsax.task_copy,
                  title: TTexts.confirmTask,
                  subtitle: TTexts.doubleCheckTask,
                  confirmButtonText: "Yes, Complete Task",
                  cancelButtonText: "Cancel",
                  onConfirm: () => controller.submitTask(),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Save Task Completion",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
