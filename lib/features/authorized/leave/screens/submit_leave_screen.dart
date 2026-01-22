import 'package:dronees/features/authorized/leave/controllers/leave_calender_controller.dart';
import 'package:dronees/features/authorized/leave/controllers/leave_controller.dart';
import 'package:dronees/features/authorized/leave/widgets/custon_leave_calender.dart';

import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/constants/text_strings.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/custom_bottom_sheet_dropdown.dart';
import 'package:dronees/widgets/submit_confirmation.dart';
import 'package:ephone_field/ephone_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SubmitLeaveScreen extends StatelessWidget {
  const SubmitLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Find existing controller
    final LeaveController controller = Get.find<LeaveController>();
    final calendarController = Get.put(LeaveCalendarController());

    return Scaffold(
      backgroundColor: TColors.lightGrayBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF7B61FF),
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Submit Leave",
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultPadding),
        child: Container(
          padding: const EdgeInsets.all(TSizes.defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: controller.leaveFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fill Leave Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Information about leave details",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: TSizes.defaultPadding),

                _buildFieldLabel("Leave Category"),
                const SizedBox(height: 6),
                CustomBottomSheetDropdown(
                  label: "Choose a Leave Category",
                  items: const [
                    "Casual Leave",
                    "Comp Off",
                    "Earned Leave",
                    "Floating Holiday",
                    "LWP",
                    "WFH",
                  ],
                  icon: Iconsax.keyboard_open,
                  selectedValue: controller.selectedValue,
                  onSelect: (value) {
                    controller.updateValue(value);
                    print("Selected: $value");
                  },
                  validator: TValidator.leaveCategoryValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: TSizes.defaultPadding),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Color(0xFF6A5AE0),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Select Leave Dates",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          // Tap day to select
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6A5AE0).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Tap days to select',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF6A5AE0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomLeaveCalendar(controller: calendarController),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.defaultPadding),

                // _buildFieldLabel("Task Delegation"),
                // const SizedBox(height: 6),
                // TextFormField(
                //   // controller: controller.amountController,
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //     hintText: "Employee Name",
                //     prefixIcon: Icon(Iconsax.user),
                //     iconColor: TColors.primary,
                //     prefixIconColor: TColors.primary,
                //     filled: true,
                //     fillColor: const Color(0xFFF8F9FA),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(12),
                //       borderSide: BorderSide.none,
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(12),
                //       borderSide: BorderSide(color: const Color(0xFFE8E8E8)),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: TSizes.defaultPadding),
                _buildFieldLabel("Emergency Contact During Leave Period"),
                const SizedBox(height: 8),
                EPhoneField(
                  controller: controller.emergencyContactController.value,
                  phoneValidator: TValidator.validatePhoneNumber,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialType: EphoneFieldType.phone,
                  initialCountry: Country.india,
                  countries: [Country.india],
                  decoration: InputDecoration(
                    hintText: "Employee",
                    prefixIcon: Icon(Iconsax.user),
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
                      borderSide: BorderSide(color: const Color(0xFFE8E8E8)),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.defaultPadding),

                _buildFieldLabel("Leave Purpose"),
                const SizedBox(height: 6),
                TextFormField(
                  controller: controller.purposeController.value,
                  validator: TValidator.leavePurposeValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  minLines: 5, // initial height
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
                      borderSide: BorderSide(color: const Color(0xFFE8E8E8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(context, controller),
    );
  }

  // --- Helper UI Widgets ---

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, LeaveController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          if (controller.leaveFormKey.currentState!.validate()) {
            SubmitConfirmationSheet.show(
              context,
              icon: Iconsax.airplane_square,
              title: TTexts.submitLeave,
              subtitle: TTexts.doubleCheckLeave,
              confirmButtonText: TTexts.yesSubmit,
              cancelButtonText: TTexts.noLetme,
              onConfirm: controller.submitLeave,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary, // Muted purple from image
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Submit Now",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
