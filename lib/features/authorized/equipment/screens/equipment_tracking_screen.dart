import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dronees/features/authorized/equipment/models/assign_equipment.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:dronees/widgets/custom_file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dronees/features/authorized/equipment/controllers/equipment_controller.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
                'In Use',
                controller.assignedEquipment.toString(),
              ),
              _buildVerticalDivider(),
              _buildStatDetail(
                'Available',
                controller.availableEquipment.toString(),
              ),
              _buildVerticalDivider(),
              _buildStatDetail('Total', controller.equipmentList.toString()),
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
      if (controller.assignEquipmentList.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _buildEmptyState(),
        );
      }
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final equipment = controller.assignEquipmentList[index];
            return _buildEnhancedEquipmentCard(context, equipment);
          }, childCount: controller.assignEquipmentList.length),
        ),
      );
    });
  }

  Widget _buildEnhancedEquipmentCard(
    BuildContext context,
    AssignEquipment equipment,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. IMAGE SECTION WITH OVERLAYS
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: equipment.assignPhoto,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.white,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[100],
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ),
                // Floating Status Chip
                Positioned(
                  top: 16,
                  right: 16,
                  child: _buildGlassStatus("Active"),
                ),
              ],
            ),

            // 2. CONTENT SECTION
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.precision_manufacturing,
                          size: 20,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          equipment.equipmentName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Info Grid (Date and Project)
                  Row(
                    children: [
                      _buildInfoTile(
                        Icons.calendar_today_outlined,
                        "Date Assigned",
                        DateFormat("dd MMM, yyyy").format(equipment.assignDate),
                      ),
                      const SizedBox(width: 16),
                      _buildInfoTile(
                        Icons.location_on_outlined,
                        "Location",
                        equipment.projectOrLocation,
                      ),
                    ],
                  ),

                  // 3. REMARK BOX
                  if (equipment.assignRemark.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: const Border(
                          left: BorderSide(color: Colors.blueAccent, width: 4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote_rounded,
                            color: Colors.blueAccent.withOpacity(0.5),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              equipment.assignRemark,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blueGrey[700],
                                height: 1.4,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // 4. ACTION BUTTON
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showReturnBottomSheet(context, equipment),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.2),
                          ),
                          color: Colors.redAccent.withOpacity(0.05),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_return_outlined,
                              size: 20,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Return to Inventory",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
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
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.blueGrey[400]),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.blueGrey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassStatus(String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: Colors.white.withOpacity(0.2),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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

  void _showReturnBottomSheet(BuildContext context, AssignEquipment equipment) {
    final controller = Get.find<EquipmentController>();

    return CustomBlurBottomSheet.show(
      context,
      onClosed: () {
        controller.returnImage.value = null;
        controller.returnRemarkController.clear();
      },
      isDismissible: false,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Return ${equipment.equipmentName}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.isLoading.value) return;
                        Get.back();
                      },
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ), // Adjust blur intensity here
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // The color must be semi-transparent for the blur to be visible
                              color: Colors.grey.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
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
                  initialValue: controller.returnImage.value,
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
