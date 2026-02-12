import 'dart:developer';

import 'package:dronees/features/authorized/money_receive/controllers/submit_money_received_controller.dart';
import 'package:dronees/features/authorized/money_receive/models/projects_model.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/utils/constants/sizes.dart';

import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/confirm_sheet.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:dronees/widgets/custom_bottom_sheet_dropdown.dart';
import 'package:dronees/widgets/custom_file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AddMoneyReceiveScreen extends StatelessWidget {
  const AddMoneyReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SubmitMoneyReceivedController controller = Get.put(
      SubmitMoneyReceivedController(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Report Received Money",
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
                key: controller.paymentFormKey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(TImages.receivedMoneyBanner),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),

                    Container(
                      padding: const EdgeInsets.all(TSizes.defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Project Dropdown
                          const Text(
                            "Client Project",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          CustomBottomSheetDropdown<ProjectsModel>(
                            displayText: (project) => project.name,
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

                          // Amount
                          const Text(
                            "Received Amount",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            onTapOutside: (PointerDownEvent event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: TValidator.validateAmount,
                            decoration: _buildInputDecoration(
                              hint: "0.00",
                              icon: Icons.currency_rupee,
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          const Text(
                            "Payment Mode",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          CustomBottomSheetDropdown<String>(
                            displayText: (mode) => mode,
                            isLoading: RxBool(false),
                            validator: (value) => TValidator.validateNull(
                              value,
                              "Payment mode is required.",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,

                            label: "Payment Mode",
                            items: const [
                              "UPI / QR",
                              "Bank Transfer",
                              "Cash",
                              "Cheque",
                            ],
                            selectedValue: controller.selectedMode,
                            onSelect: (val) =>
                                controller.selectedMode.value = val,
                            icon: Iconsax.card,
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems),

                          // Remark
                          const Text(
                            "Payment Remark",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            onTapOutside: (PointerDownEvent event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: controller.remarkController,
                            validator: (value) =>
                                TValidator.emptyValidator(value, "Remark"),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLines: 3,
                            decoration: _buildInputDecoration(
                              hint: "E.g. Part payment for Phase 1",
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          // Custom Image Upload
                          const Text(
                            "Payment Proof (Screenshot/Receipt)",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
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
          _buildBottomButton(context, controller),
        ],
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

  Widget _buildBottomButton(
    BuildContext context,
    SubmitMoneyReceivedController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultPadding),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.value) return;
                if (controller.paymentFormKey.currentState!.validate()) {
                  CustomBlurBottomSheet.show(
                    context,
                    widget: ConfirmSheet(
                      title: "Submit Payment",
                      description:
                          "Double-check your payment details to ensure everything is correct. Do you want to proceed?",
                      onConfirm: controller.submitPaymentRecord,
                      confirmText: "Yes Sumbit",
                      themeColor: TColors.othersColor,
                      icon: Iconsax.money_add_copy,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: controller.isLoading.value
                  ? const CupertinoActivityIndicator(color: TColors.white)
                  : const Text(
                      "Submit Payment Report",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
