import 'dart:io';

import 'package:dronees/features/authorized/travel_allowance/controllers/travel_allowsnce_controller.dart';
import 'package:dronees/features/authorized/travel_allowance/models/travel_allowance_model.dart';
import 'package:dronees/features/authorized/travel_allowance/screens/submit_travel_allowance.dart';
import 'package:dronees/features/authorized/travel_allowance/screens/travel_allowance_detail_screen.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TravelAllowanceSummary extends StatelessWidget {
  const TravelAllowanceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TravelAllowanceController());

    return Scaffold(
      backgroundColor: const Color(0xFF6C5CE7),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.only(
                left: TSizes.defaultPadding,
                right: TSizes.defaultPadding,
                top: Platform.isAndroid ? TSizes.defaultPadding : 0,
                bottom: TSizes.defaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Travel Allowance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Claim your travel allowances here.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Transform.rotate(
                        angle: -0.2,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.flight_takeoff,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Summary Card - Compact Version
                    Container(
                      margin: const EdgeInsets.all(TSizes.defaultPadding),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: TSizes.minSpaceBtw,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => _buildCompactSummaryItem(
                                  icon: Icons.lock_clock_sharp,
                                  iconColor: const Color(0xFF6C5CE7),
                                  label: 'Pending',
                                  amount: controller.pendingAmount.value,
                                  enabled: controller.loadingStats.value,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 35,
                                color: Colors.grey[200],
                              ),
                              Obx(
                                () => _buildCompactSummaryItem(
                                  icon: Icons.check_circle,
                                  iconColor: const Color(0xFF66BB6A),
                                  label: 'Approved',
                                  amount: controller.approvedAmount.value,
                                  enabled: controller.loadingStats.value,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 35,
                                color: Colors.grey[200],
                              ),
                              Obx(
                                () => _buildCompactSummaryItem(
                                  icon: Icons.cancel,
                                  iconColor: TColors.error,
                                  label: 'Rejected',
                                  amount: controller.rejectedAmount.value,
                                  enabled: controller.loadingStats.value,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Filter Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.defaultPadding,
                      ),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFilterTab(
                              controller,
                              'Pending',
                              controller.pendingCount.value,
                              controller.selectedStatus.value == 'Pending',
                              'Pending',
                            ),
                            const SizedBox(width: 10),
                            _buildFilterTab(
                              controller,
                              'Approved',
                              controller.approvedCount.value,
                              controller.selectedStatus.value == 'Approved',
                              'Approved',
                            ),
                            const SizedBox(width: 10),
                            _buildFilterTab(
                              controller,
                              'Rejected',
                              controller.rejectedCount.value,
                              controller.selectedStatus.value == 'Rejected',
                              'Rejected',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: TSizes.minSpaceBtw),

                    // Allowance List
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value &&
                            controller.allowances.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF6C5CE7),
                            ),
                          );
                        }

                        if (controller.allowances.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No ${controller.selectedStatus.value.toLowerCase()} allowances',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: controller.refreshAllowances,
                          color: const Color(0xFF6C5CE7),
                          child: ListView.builder(
                            controller: controller.scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount:
                                controller.allowances.length +
                                (controller.isLoadingMore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == controller.allowances.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF6C5CE7),
                                    ),
                                  ),
                                );
                              }

                              final allowance = controller.allowances[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AllowanceCard(allowance: allowance),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          left: TSizes.defaultPadding,
          right: TSizes.defaultPadding,
          bottom: TSizes.defaultPadding,
        ),
        width: double.infinity,
        color: const Color(0xFFF5F6FA),
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => SubmitTravelAllowance());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C5CE7),
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: const Color(0xFF6C5CE7).withOpacity(0.4),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Submit Allowance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // Compact Summary Item
  Widget _buildCompactSummaryItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String amount,
    required bool enabled,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Skeletonizer(
            enabled: enabled,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    TravelAllowanceController controller,
    String label,
    int count,
    bool isActive,
    String status,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeFilter(status),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF6C5CE7) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF6C5CE7).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : const Color(0xFFE8E8E8),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isActive ? const Color(0xFF6C5CE7) : Colors.grey,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Expandable Allowance Card Widget
class AllowanceCard extends StatelessWidget {
  final TravelAllowance allowance;

  const AllowanceCard({super.key, required this.allowance});

  @override
  Widget build(BuildContext context) {
    final isAdvance = allowance.taType == 'Advance';
    final statusColor = _getStatusColor(allowance.status);
    final sideColor = _getSideColor(allowance.taType);

    return GestureDetector(
      onTap: () {
        // Navigate to detail screen
        Get.to(
          () => TravelAllowanceDetailScreen(data: allowance, isOwner: false),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Status Color Indicator
                Container(width: 4, color: sideColor),

                // Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          allowance.taNo ?? 'N/A',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Color(0xFF2D3436),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      _buildTypeChip(allowance.taType),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 11,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDate(
                                          isAdvance
                                              ? allowance.departureDate
                                              : allowance.transationDate,
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildCompactStatusBadge(allowance.status),
                                const SizedBox(height: 4),
                                isAdvance
                                    ? Row(
                                        children: <Widget>[
                                          Text(
                                            '₹${allowance.totalEstimatedExpense}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '₹${allowance.advanceAmount}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF6C5CE7),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '₹${allowance.amount}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF6C5CE7),
                                        ),
                                      ),
                                // Text(
                                //   isAdvance
                                //       ?
                                //       : ,
                                // style: const TextStyle(
                                //   fontSize: 18,
                                //   fontWeight: FontWeight.w800,
                                //   color: Color(0xFF6C5CE7),
                                // ),
                                // ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Purpose (Truncated to 2 lines)
                        Text(
                          allowance.purpose.split("/:reply:")[0],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2D3436),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        // View Details Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'View details',
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color(0xFF6C5CE7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Color(0xFF6C5CE7),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String? type) {
    final isAdvance = type == 'Advance';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isAdvance
            ? Colors.orange.withOpacity(0.15)
            : Colors.blue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type?.toUpperCase() ?? '',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: isAdvance ? Colors.orange[800] : Colors.blue[800],
        ),
      ),
    );
  }

  Color _getSideColor(String type) {
    if (type == 'Advance') {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }

  Widget _buildCompactStatusBadge(String? status) {
    final color = _getStatusColor(status);
    String displayStatus = status ?? 'Pending';

    if (displayStatus == 'Approved by Department') {
      displayStatus = 'Dept. OK';
    }
    if (displayStatus == 'Rejected by Department') {
      displayStatus = 'Dept. Rejected';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 2.5, backgroundColor: color),
          const SizedBox(width: 4),
          Text(
            displayStatus,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status?.contains('Approved') == true) return const Color(0xFF00B894);
    if (status?.contains('Rejected') == true) return const Color(0xFFD63031);
    return const Color(0xFFFDCB6E);
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      final dateTime = DateTime.parse(date.toString());
      return DateFormat('dd MMM yy').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }
}
