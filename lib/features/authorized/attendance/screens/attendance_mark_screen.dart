import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/attendance/controllers/attendance_mark_controller.dart';
import 'package:dronees/features/authorized/attendance/widgets/attendance_map.dart';
import 'package:dronees/features/authorized/attendance/widgets/running_clock.dart';
import 'package:dronees/features/authorized/attendance/widgets/vehicle_selector.dart';
import 'package:dronees/features/authorized/money_receive/models/projects_model.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/custom_bottom_sheet_dropdown.dart';
import 'package:dronees/widgets/submit_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

// Note: Replace these with your actual imports
// import 'package:dronees/utils/constants/colors.dart';

class AttendanceMarkScreen extends StatelessWidget {
  const AttendanceMarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendanceMarkController controller = Get.put(
      AttendanceMarkController(),
    );
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // 1. --- SHRINKING MAP HEADER ---
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF5F4FD1),
            automaticallyImplyLeading: false,
            leadingWidth: 70,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Iconsax.arrow_left_2_copy,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.goBack();
                  },
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  attendanceMap(controller), // Your Map Widget
                  // Subtle gradient overlay to make the map look premium
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. --- SCROLLABLE CONTENT ---
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Profile Section
                    _buildSectionHeader(context, "Employee Profile"),
                    _buildEnhancedProfileCard(),

                    const SizedBox(height: 20),

                    // Schedule Section
                    _buildSectionHeader(context, "Current Schedule"),

                    _buildEnhancedScheduleCard(),
                    const SizedBox(height: 20),

                    _buildDriverSection(controller),
                    const SizedBox(height: 20),

                    // Attendance Proof Section
                    Obx(() {
                      if (controller.selfieFile.value == null) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(context, "Clock-in Proof"),
                          // const SizedBox(height: 8),
                          _buildSelfiePreview(),
                        ],
                      );
                    }),
                    const SizedBox(height: 120), // Bottom padding for button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // 3. --- FLOATING ACTION BUTTON AREA ---
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Obx(() => _buildMainActionButton(context)),
      ),
    );
  }

  Widget _buildDriverSection(AttendanceMarkController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // --- Idle State Toggle Row ---
          if (AuthController.instance.authUser?.userDetails.rolesDisplayNames !=
              "Driver")
            Form(
              key: controller.formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.status,
                              size: 20,
                              color: TColors.primary,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Idle State",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => Switch.adaptive(
                            // Adaptive provides a native look on iOS/Android
                            value: controller.isIdle.value,
                            activeColor: Colors.green.shade600,
                            activeTrackColor: Colors.green.shade100,
                            onChanged: (value) =>
                                controller.isIdle.value = value,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Animated Visibility for Client Project ---
                  Obx(
                    () => AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: !controller.isIdle.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  "Client Project",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
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
                                  onSelect: (val, state) {
                                    controller.selectedProject.value = val;
                                    state.didChange(val);
                                  },
                                  icon: Iconsax.folder,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),

          // --- Meter Reading ---
          if (AuthController.instance.authUser?.userDetails.rolesDisplayNames ==
              "Driver")
            Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VehicleSelectorFormField(
                    vehicles: controller.vehicles,
                    initialValue: controller.selectedVehicle.value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onVehicleSelected: (v) =>
                        controller.selectedVehicle.value = v,
                    onSaved: (v) => controller.selectedVehicle.value = v,
                    validator: (value) =>
                        TValidator.validateNull(value, "Vehicle is required."),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(thickness: 1, height: 1),
                  ),
                  const Text(
                    "Meter Reading",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: controller.meterReadingController,
                    validator: (value) =>
                        TValidator.validateDecimalInput("Meter Reading", value),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration(
                      hint: "Enter Meter Reading",
                      icon: FontAwesomeIcons.gaugeHigh,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- Co-Passenger ---
                  const Text(
                    "Co-Passenger",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: controller.coPassengerController,
                    validator: (value) =>
                        TValidator.emptyValidator(value, "Co-Passenger"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration(
                      hint: "Enter Co-Passenger",
                      icon: FontAwesomeIcons.person,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- UI COMPONENT HELPERS ---

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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.grey[600],
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEnhancedProfileCard() {
    final controller = AttendanceMarkController.to;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Color(0xFF5F4FD1),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(Iconsax.user, size: 30, color: Color(0xFF5F4FD1)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      "Tonald Drump",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.verified, size: 16, color: Colors.blue),
                  ],
                ),
                Text(
                  controller.currentDate.value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5F4FD1),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    "📍 Lat: ${controller.currentPosition.value?.latitude.toStringAsFixed(4) ?? '...'} | Long: ${controller.currentPosition.value?.longitude.toStringAsFixed(4) ?? '...'}",
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedScheduleCard() {
    final controller = AttendanceMarkController.to;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Obx(
            () => _buildInfoRow(
              Iconsax.location_copy,
              controller.locationName.value,
              isObx: true,
            ),
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Iconsax.clock_copy,
            "Current Time",
            trailing: RunningClock(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text, {
    bool isObx = false,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5F4FD1), size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildSelfiePreview() {
    final controller = AttendanceMarkController.to;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.file(
            controller.selfieFile.value!,
            width: double.infinity,

            fit: BoxFit.cover,
          ),
          Positioned(
            top: 12,
            right: 12,
            child: FloatingActionButton.small(
              backgroundColor: Colors.black.withOpacity(0.7),
              onPressed: () => controller.takeSelfieAndTag(),
              child: const Icon(
                Iconsax.refresh_copy,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionButton(BuildContext context) {
    final controller = AttendanceMarkController.to;
    bool hasPhoto = controller.selfieFile.value != null;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5F4FD1),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        elevation: 8,
        shadowColor: const Color(0xFF5F4FD1).withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: () {
        if (controller.isLoading.value) {
          return;
        }
        if (!controller.formKey.currentState!.validate()) {
          return;
        } else if (!hasPhoto) {
          controller.takeSelfieAndTag();
        } else {
          SubmitConfirmationSheet.show(
            context,
            icon: Iconsax.clock,
            title: "Confirm Attendance",
            subtitle: "Are you sure you want to mark your attendance now?",
            confirmButtonText: "Yes, Mark Now",
            cancelButtonText: "Cancel",
            onConfirm: () => controller.clockIn(),
            cancelOutside: false,
          );
        }
      },
      child: controller.isLoading.value
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              hasPhoto ? "MARK ATTENDANCE" : "TAKE PHOTO TO MARK",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
    );
  }
}
