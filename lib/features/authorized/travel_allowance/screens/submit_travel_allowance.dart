import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dronees/features/authorized/attendance/widgets/build_date_picker.dart';
import 'package:dronees/features/authorized/travel_allowance/controllers/travel_allowance_controller.dart';
import 'package:dronees/widgets/submit_confirmation.dart';

import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/constants/text_strings.dart';
import 'package:dronees/widgets/upload_document.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SubmitTravelAllowance extends StatelessWidget {
  SubmitTravelAllowance({super.key});

  final controller = Get.put(TravelAllowanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: AppBar(
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
          onPressed: () => Navigator.pop(context),
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Banner
                    Image.asset(TImages.taBanner),
                    SizedBox(height: TSizes.defaultPadding),
                    // Form Section
                    Container(
                      padding: const EdgeInsets.all(TSizes.defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                            TTexts.fillClaim,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            TTexts.imformationAbout,
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          // Upload Document Section
                          GestureDetector(
                            onTap: controller.pickDocument,

                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                dashPattern: [7, 5],
                                strokeWidth: 1,
                                radius: Radius.circular(16),
                                color: TColors.primary.withAlpha(200),
                              ),
                              child: Obx(() {
                                return controller.selectedFile.value == null
                                    ? UploadDocument(
                                        title: "Upload Claim Document",
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          16.0,
                                        ),
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              controller.selectedFile.value!,
                                              height: 220,
                                            ),
                                            Positioned(
                                              right: 10,
                                              top: 10,
                                              child: const Icon(
                                                Iconsax.refresh_circle,
                                                color: TColors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              }),
                            ),
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems),

                          const Text(
                            'Transaction Date (Max 2 days Back)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Obx(
                            () => buildDatePicker(
                              context,
                              controller.selectedDate.value,
                              DateTime.now().subtract(const Duration(days: 2)),
                              DateTime.now(),
                              (DateTime pickedDate) {
                                controller.setDate(pickedDate);
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Allowance Amount
                          const Text(
                            'Allowance Amount (₹)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Amount",
                              prefixIcon: Icon(Icons.currency_rupee_outlined),
                              iconColor: TColors.primary,
                              prefixIconColor: TColors.primary,
                              filled: true,
                              fillColor: const Color(0xFFF8F9FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color(0xFFE8E8E8),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: TSizes.defaultPadding),

                          // Allowance Description
                          const Text(
                            'Purpose Description',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controller.purposeController,
                            minLines: 3, // initial height
                            maxLines: 6,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: "Purpose",

                              filled: true,
                              fillColor: const Color(0xFFF8F9FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color(0xFFE8E8E8),
                                ),
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

          // Submit Button
          Container(
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
                    // showSubmitConfirmation(context, controller.submitAllowance);
                    SubmitConfirmationSheet.show(
                      context,
                      icon: Iconsax.receipt_2,
                      title: TTexts.readyToSubmit,
                      subtitle: TTexts.doubleCheck,
                      confirmButtonText: TTexts.yesSubmit,
                      cancelButtonText: TTexts.noLetme,
                      onConfirm: controller.submitAllowance,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
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
          ),
        ],
      ),
    );
  }
}
