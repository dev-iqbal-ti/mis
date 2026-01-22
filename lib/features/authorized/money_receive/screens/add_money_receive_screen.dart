import 'dart:io';

import 'package:dronees/features/authorized/money_receive/controllers/money_receive_controller.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/widgets/custom_bottom_sheet_dropdown.dart';
import 'package:dronees/widgets/upload_document.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddMoneyReceiveScreen extends StatelessWidget {
  const AddMoneyReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoneyReceiveController>();

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
              padding: const EdgeInsets.all(20),
              child: Form(
                key: controller.paymentFormKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Project Dropdown
                          Obx(
                            () => CustomBottomSheetDropdown(
                              label: "Select Project",
                              items: const [
                                "Skyline Residency",
                                "Metro Bridge",
                                "Global Tech Hub",
                              ],
                              selectedValue: controller.selectedProject,
                              errorText: controller.showProjectError.value
                                  ? "Please select a project"
                                  : null,
                              onSelect: (val) =>
                                  controller.selectedProject.value = val,
                              icon: Iconsax.folder,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Amount
                          const Text(
                            "Received Amount",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                            validator: (v) =>
                                v!.isEmpty ? "Enter amount" : null,
                            decoration: _buildInputDecoration(
                              hint: "0.00",
                              icon: Icons.currency_rupee,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Payment Mode Dropdown
                          CustomBottomSheetDropdown(
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

                          const SizedBox(height: 20),

                          // Remark
                          const Text(
                            "Payment Remark",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.remarkController,
                            maxLines: 2,
                            decoration: _buildInputDecoration(
                              hint: "E.g. Part payment for Phase 1",
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Custom Image Upload
                          const Text(
                            "Payment Proof (Screenshot/Receipt)",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () async {
                              final image =
                                  await ImageUploadService.pickImageFromSource(
                                    ImageSource.gallery,
                                  );
                              if (image != null) {
                                controller.selectedImage.value = image;
                              }
                            },
                            child: Obx(
                              () => controller.selectedImage.value == null
                                  ? UploadDocument(
                                      errorText: controller.showImageError.value
                                          ? "Please upload proof"
                                          : null,
                                    )
                                  : _buildImagePreview(
                                      controller.selectedImage.value!,
                                    ),
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
          _buildBottomButton(controller),
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

  Widget _buildImagePreview(File file) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        file,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBottomButton(MoneyReceiveController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.addRecord,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Submit Payment Report",
              style: TextStyle(
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
