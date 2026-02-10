import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/travel_allowance/controllers/allowance_list_record_controller.dart';
import 'package:dronees/features/authorized/travel_allowance/screens/travel_allowance_summary.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';

class AllowanceListRecordScreen extends StatelessWidget {
  const AllowanceListRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllowanceListRecordController());

    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Lighter background for better card contrast
      appBar: AppBar(
        title: const Text(
          'Travel Allowances',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: TColors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy, color: TColors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: TColors.white,
            ), // Modern filter icon
            onPressed: () => CustomBlurBottomSheet.show(
              context,
              widget: _showFilterBottomSheet(context, controller),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allowances.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
          );
        }

        if (controller.allowances.isEmpty) {
          return _buildEmptyState(controller);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshAllowances,
          color: const Color(0xFF6C5CE7),
          child: ListView.separated(
            // 1. Changed to .separated
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount:
                controller.allowances.length +
                (controller.isLoadingMore.value ? 1 : 0),

            // 2. Define the space between items here
            separatorBuilder: (context, index) => const SizedBox(height: 16),

            itemBuilder: (context, index) {
              if (index == controller.allowances.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
                  ),
                );
              }

              return AllowanceCard(
                allowance: controller.allowances[index],
                isOwner:
                    AuthController.instance.authUser!.userDetails.id ==
                    controller.allowances[index].userId,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(AllowanceListRecordController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(TImages.emptyList, height: 100),
          const SizedBox(height: 16),
          const Text(
            "No Travel Allowances found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your filters or search criteria",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _showFilterBottomSheet(
    BuildContext context,
    AllowanceListRecordController controller,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Filter Records',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),

          // Date Range Section
          const Text(
            'By Date Range',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => controller.selectDateRange(context),
            borderRadius: BorderRadius.circular(12),
            child: GetBuilder<AllowanceListRecordController>(
              builder: (ctrl) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF6C5CE7),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        (ctrl.startDate != null && ctrl.endDate != null)
                            ? '${_formatDate(ctrl.startDate!)} - ${_formatDate(ctrl.endDate!)}'
                            : 'Select Period',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (ctrl.startDate != null)
                      GestureDetector(
                        onTap: () {
                          ctrl.startDate = null;
                          ctrl.endDate = null;
                          ctrl.update();
                        },
                        child: const Icon(
                          Icons.cancel,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    controller.clearFilters();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilters();
                    Navigator.pop(context); // Close sheet after applying
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
