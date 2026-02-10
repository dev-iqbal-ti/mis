import 'package:dronees/features/authorized/equipment/controllers/assign_equipment_controller.dart';
import 'package:dronees/features/authorized/equipment/models/equipment.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/utils/constants/text_strings.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/custom_file_picker.dart';
import 'package:dronees/widgets/submit_confirmation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';

class AssignEquipmentScreen extends StatelessWidget {
  const AssignEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AssignEquipmentController controller =
        Get.put<AssignEquipmentController>(AssignEquipmentController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_left_2_copy,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Assign New Equipment',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TSizes.defaultPadding),
              child: Form(
                key: controller.equipmentFormKey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(TImages.equipmentBanner),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),
                    Container(
                      padding: const EdgeInsets.all(TSizes.defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Equipment Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Select gear and provide assignment details",
                            style: TextStyle(
                              fontSize: 13,
                              color: TColors.darkGrey,
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          const Text(
                            "Select Equipment",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          FormField<EquipmentModel>(
                            initialValue: controller.selectedEquipment.value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: TValidator.validateEquipment,
                            builder: (FormFieldState<EquipmentModel> field) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => _showEquipmentPicker(
                                      context,
                                      controller,
                                      field,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: field.hasError
                                              ? TColors.error
                                              : const Color(0xFFE8E8E8),
                                          // width: field.hasError ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Iconsax.box,
                                            color: TColors.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            controller
                                                    .selectedEquipment
                                                    .value
                                                    ?.name ??
                                                "Choose Equipment",
                                            style: TextStyle(
                                              color:
                                                  controller
                                                          .selectedEquipment
                                                          .value ==
                                                      null
                                                  ? Colors.grey
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Iconsax.arrow_down_1_copy,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (field.hasError)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 2,
                                        left: 18,
                                      ),
                                      child: Text(
                                        field.errorText!,
                                        style: const TextStyle(
                                          color: TColors.error,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems),

                          // 2. Project Name
                          const Text(
                            "Project Name",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.projectNameController,
                            validator: (value) => TValidator.emptyValidator(
                              value,
                              "Project Name",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: _buildInputDecoration(
                              hint: "Enter Project Name",
                              icon: Iconsax.house,
                            ),
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems),

                          // 3. Remark
                          const Text(
                            "Remarks about equipment",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.remarkController,
                            validator: (value) =>
                                TValidator.emptyValidator(value, "Remark"),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLines: 5,
                            decoration: _buildInputDecoration(
                              hint: "Any specific notes...",
                            ),
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems),

                          // 4. Photo Upload Section
                          const Text(
                            "Equipment Photo",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),

                          CustomFilePicker(
                            title: "Upload Photo",
                            onPick: controller.pickImage,
                            initialValue: controller.selectedImage.value,
                            validator: (value) => TValidator.validateNull(
                              value,
                              "Select a Image",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Submit Button
          _buildBottomButton(context, controller),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({String? hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null
          ? Icon(icon, color: TColors.primary, size: 20)
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

  Widget _buildBottomButton(
    BuildContext context,
    AssignEquipmentController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (controller.equipmentFormKey.currentState!.validate()) {
                SubmitConfirmationSheet.show(
                  context,
                  icon: Iconsax.box,
                  title: TTexts.confirmAssignment,
                  subtitle: TTexts.doubleCheckEquipment,
                  confirmButtonText: "Yes, Assign",
                  cancelButtonText: "Cancel",
                  onConfirm: () => controller.assignEquipment(
                    controller.selectedEquipment.value!,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Confirm Assignment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // --- THE CUSTOM BOTTOM SHEET DROPDOWN ---
  void _showEquipmentPicker(
    BuildContext context,
    AssignEquipmentController controller,
    FormFieldState<EquipmentModel> field,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Available Equipment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Flexible(
              child: Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.equipmentList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final equipment = controller.equipmentList[index];
                    final bool isTaken = equipment.assignedTo != null;

                    return ListTile(
                      enabled: !isTaken,
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: isTaken
                            ? Colors.grey[200]
                            : TColors.primary.withOpacity(0.1),
                        child: Icon(
                          Iconsax.box,
                          size: 18,
                          color: isTaken ? Colors.grey : TColors.primary,
                        ),
                      ),
                      title: Text(
                        equipment.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isTaken ? Colors.grey : Colors.black87,
                        ),
                      ),
                      subtitle: isTaken
                          ? Text(
                              "Assigned to: ${equipment.assignedName ?? 'N/A'}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            )
                          : const Text(
                              "Available for use",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                      trailing: isTaken
                          ? const Icon(
                              Iconsax.lock,
                              color: Colors.grey,
                              size: 18,
                            )
                          : const Icon(
                              Iconsax.add_circle,
                              color: TColors.primary,
                              size: 18,
                            ),
                      onTap: () {
                        controller.selectedEquipment.value = equipment;
                        field.didChange(equipment);
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
      isScrollControlled: true,
    );
  }
}
