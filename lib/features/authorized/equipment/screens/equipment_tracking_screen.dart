import 'package:dotted_border/dotted_border.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:dronees/widgets/custom_file_picker.dart';
import 'package:dronees/widgets/upload_document.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:dronees/features/authorized/equipment/controllers/equipment_controller.dart';
import 'package:dronees/features/authorized/equipment/models/equipment.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EquipmentScreen extends StatelessWidget {
  final EquipmentController controller = Get.put(EquipmentController());

  EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern soft background
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left_2_copy, color: Colors.white),
        ),
        title: const Text(
          'Equipment Inventory',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          // Stats Section
          SliverToBoxAdapter(child: _buildStatsCard()),

          // Header Section
          SliverPadding(
            padding: const EdgeInsets.only(
              left: TSizes.defaultPadding,
              right: TSizes.defaultPadding,
              bottom: 8,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Assigned Equipment",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // List Section
          _buildAssignedListSliver(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToAssignScreen,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Assignment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: TColors.primary,
        elevation: 4,
      ),
    );
  }

  Widget _buildStatsCard() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.all(TSizes.defaultPadding),
        padding: const EdgeInsets.all(TSizes.defaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [TColors.primary, TColors.primary.withBlue(200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: TColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _buildStatDetail(
                'Assigned',
                controller.assignedEquipment.length.toString(),
              ),
              _buildVerticalDivider(),
              _buildStatDetail(
                'Available',
                controller.availableEquipment.length.toString(),
              ),
              _buildVerticalDivider(),
              _buildStatDetail(
                'Total',
                controller.equipmentList.length.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatDetail(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return VerticalDivider(
      color: Colors.white.withOpacity(0.2),
      thickness: 1,
      indent: 10,
      endIndent: 10,
    );
  }

  Widget _buildAssignedListSliver() {
    return Obx(() {
      if (controller.assignedEquipment.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _buildEmptyState(),
        );
      }
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final equipment = controller.assignedEquipment[index];
            return _buildEnhancedEquipmentCard(context, equipment);
          }, childCount: controller.assignedEquipment.length),
        ),
      );
    });
  }

  Widget _buildEnhancedEquipmentCard(
    BuildContext context,
    Equipment equipment,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header with Name and Status
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: TColors.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.precision_manufacturing,
                    color: TColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    equipment.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                _StatusChip(label: "Active", color: Colors.green),
              ],
            ),
          ),

          // 2. Photo Section (If exists)
          if (equipment.photoUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.file(
                      File(equipment.photoUrl!),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay to make it look premium
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 3. Details & Remarks
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  Icons.calendar_today_rounded,
                  "Assigned",
                  equipment.assignedDate ?? 'N/A',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  Icons.rocket_launch_outlined,
                  "Project",
                  equipment.projectName ?? 'N/A',
                ),

                // THE REMARK BOX (Added back and styled)
                if (equipment.remark != null &&
                    equipment.remark!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.sticky_note_2_outlined,
                          size: 18,
                          color: Colors.amber[900],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            equipment.remark!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.amber[900],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // 4. Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showReturnBottomSheet(context, equipment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.keyboard_return_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Return to Inventory",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 100, color: Colors.grey[200]),
          const SizedBox(height: 20),
          const Text(
            "Inventory is clear",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Assigned equipment will appear here.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showReturnBottomSheet(BuildContext context, Equipment equipment) {
    final controller = Get.find<EquipmentController>();

    return CustomBlurBottomSheet.show(
      context,
      onClosed: () {
        controller.returnImage.value = null;
        controller.returnRemarkController.clear();
      },
      widget: SingleChildScrollView(
        child: Form(
          key: controller.returnFormKey,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(
                      bottom: TSizes.defaultPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  "Return ${equipment.name}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Please record the condition of the gear before returning.",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Remark Field
                const Text(
                  "Condition Remark",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.returnRemarkController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter a remark" : null,
                  decoration: InputDecoration(
                    hintText: "E.g. Returned in good condition, battery 20%...",
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
                const SizedBox(height: 20),

                // Photo Section
                const Text(
                  "Current Photo",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                CustomFilePicker(
                  title: "Equipment Return Photo",
                  subTitle: "Take a photo of the equipment condition now",
                  onPick: controller.pickReturnImage,
                  initialValue: controller.selectedImage.value,
                  validator: (value) =>
                      TValidator.validateNull(value, "Please Provide a Image"),
                ),

                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => controller.finalizeReturn(equipment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Confirm Return",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper Components
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
