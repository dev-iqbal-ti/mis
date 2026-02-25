import 'dart:io';
import 'dart:ui';

import 'package:dronees/features/authorized/leave/controllers/leave_controller.dart';
import 'package:dronees/features/authorized/leave/models/day_type.dart';
import 'package:dronees/features/authorized/leave/models/leaves.dart';
import 'package:dronees/features/authorized/leave/models/status_theme.dart';
import 'package:dronees/features/authorized/leave/screens/submit_leave_screen.dart';
import 'package:dronees/utils/constants/sizes.dart';

import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class LeaveSummaryScreen extends StatelessWidget {
  const LeaveSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaveController());

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
                            'Leave Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            'Track and manage your leaves.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Iconsax.clock_copy,
                          color: Colors.white,
                          size: 32,
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
                    const SizedBox(height: 16), // reduced from 20
                    const ModernLeaveStats(),
                    const SizedBox(height: 16), // reduced from 24
                    _SectionHeader(controller: controller),
                    const SizedBox(height: 8), // reduced from 12
                    Expanded(child: _LeaveList(controller: controller)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _FAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// ─── Leave Stats ───────────────────────────────────────────────────────────────

class PurpleBrutalistStats extends StatelessWidget {
  const PurpleBrutalistStats({super.key});

  // The core "Brutalist" stroke and shadow color
  final Color darkBorder = const Color(0xFF1D2D2D);
  // Your original Modern Purple
  final Color primaryPurple = const Color(0xFF6C5CE7);

  @override
  Widget build(BuildContext context) {
    final controller = LeaveController.to;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: primaryPurple,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: darkBorder, width: 3),
        boxShadow: [
          BoxShadow(
            color: darkBorder,
            offset: const Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Keeping the decorative circle but making it "Brutalist"
          Positioned(
            top: -15,
            right: -15,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => _BrutalistStatItem(
                        label: "Casual",
                        remaining:
                            controller.casualLeaveEntitlements.value.remaining,
                        color: const Color(0xFF00D2FF), // Original Cyan
                        icon: Icons.wb_sunny_rounded,
                      ),
                    ),
                    _VerticalDivider(),
                    Obx(
                      () => _BrutalistStatItem(
                        label: "Earned",
                        remaining:
                            controller.earnedLeaveEntitlements.value.remaining,
                        color: const Color(0xFF00FFAB), // Original Green
                        icon: Icons.card_travel_rounded,
                      ),
                    ),
                    _VerticalDivider(),
                    Obx(
                      () => _BrutalistStatItem(
                        label: "Floating",
                        remaining: controller
                            .floatingHolidayEntitlements
                            .value
                            .remaining,
                        color: const Color(0xFFFFC371), // Original Orange
                        icon: Icons.auto_awesome_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Solid High-Contrast Info Bar
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: darkBorder, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: darkBorder,
                        offset: const Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.tips_and_updates_rounded,
                        color: primaryPurple,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Obx(
                        () => Text(
                          "You have ${controller.totalLeave.value} days available",
                          style: TextStyle(
                            color: darkBorder,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _VerticalDivider() {
    return Container(
      width: 2,
      height: 40,
      color: Colors.white.withOpacity(0.3),
    );
  }
}

class _BrutalistStatItem extends StatelessWidget {
  final String label;
  final double remaining;
  final Color color;
  final IconData icon;

  const _BrutalistStatItem({
    required this.label,
    required this.remaining,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkBorder = Color(0xFF1D2D2D);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: darkBorder, width: 2),
            boxShadow: const [
              BoxShadow(color: darkBorder, offset: Offset(2, 2), blurRadius: 0),
            ],
          ),
          child: Icon(icon, color: darkBorder, size: 20),
        ),
        const SizedBox(height: 12),
        Text(
          remaining.toStringAsFixed(0),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text for better contrast on purple
          ),
        ),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// ─── Compact Leave Stats Card (no expand/collapse) ────────────────────────────

class ModernLeaveStats extends StatelessWidget {
  const ModernLeaveStats({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LeaveController.to;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C6CF0), Color(0xFF6C5CE7), Color(0xFF4834D4)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative blobs
            Positioned(
              top: -28,
              right: -18,
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.white.withOpacity(0.06),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -10,
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white.withOpacity(0.04),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Top: icon + title + badge ──────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tips_and_updates_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Leave Balance",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const Spacer(),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 6,
                                width: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00FFAB),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${controller.totalLeave.value} days left",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Divider ──────────────────────────────────────────────
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Stats row ─────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => _CompactStatItem(
                          label: "Casual",
                          remaining: controller
                              .casualLeaveEntitlements
                              .value
                              .remaining,
                          used: controller.casualLeaveEntitlements.value.used,
                          total: controller
                              .casualLeaveEntitlements
                              .value
                              .entitlement,
                          color: const Color(0xFF00D2FF),
                          icon: Icons.wb_sunny_rounded,
                        ),
                      ),
                      _GlowDivider(),
                      Obx(
                        () => _CompactStatItem(
                          label: "Earned",
                          remaining: controller
                              .earnedLeaveEntitlements
                              .value
                              .remaining,
                          used: controller.earnedLeaveEntitlements.value.used,
                          total: controller
                              .earnedLeaveEntitlements
                              .value
                              .entitlement,
                          color: const Color(0xFF00FFAB),
                          icon: Icons.card_travel_rounded,
                        ),
                      ),
                      _GlowDivider(),
                      Obx(
                        () => _CompactStatItem(
                          label: "Floating",
                          remaining: controller
                              .floatingHolidayEntitlements
                              .value
                              .remaining,
                          used:
                              controller.floatingHolidayEntitlements.value.used,
                          total: controller
                              .floatingHolidayEntitlements
                              .value
                              .entitlement,
                          color: const Color(0xFFFFC371),
                          icon: Icons.auto_awesome_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Compact Stat Item ─────────────────────────────────────────────────────────

class _CompactStatItem extends StatelessWidget {
  final String label;
  final num remaining;
  final num used;
  final num total;
  final Color color;
  final IconData icon;

  const _CompactStatItem({
    required this.label,
    required this.remaining,
    required this.used,
    required this.total,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Remaining days (big)
          Text(
            "$remaining",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),

          const SizedBox(height: 3),

          // Label
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 4),

          // Used / Total chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$used / $total used",
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glow Divider ──────────────────────────────────────────────────────────────

class _GlowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0),
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final LeaveController controller;

  const _SectionHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Leave Records",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                if (controller.selectedStatus.value != 'All')
                  Text(
                    "Filtered: ${controller.selectedStatus.value}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _openFilterSheet(context, controller),
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.tune_rounded,
                      size: 16,
                      color: Color(0xFF6C5CE7),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Filter",
                      style: TextStyle(
                        color: Color(0xFF6C5CE7),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    if (controller.selectedStatus.value != 'All') ...[
                      const SizedBox(width: 4),
                      Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6C5CE7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterSheet(BuildContext context, LeaveController controller) {
    CustomBlurBottomSheet.show(
      context,
      widget: _FilterSheetContent(controller: controller),
    );
  }
}

// ─── Leave List with Pagination ────────────────────────────────────────────────

class _LeaveList extends StatelessWidget {
  final LeaveController controller;

  const _LeaveList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final leaves = controller.leaves;

      if (leaves.isEmpty && !controller.isLoadingMore.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                "No leave records found",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: const Color(0xFF6C5CE7),
        onRefresh: controller.refresh,
        child: ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: leaves.length + 1, // +1 for footer
          itemBuilder: (context, index) {
            if (index < leaves.length) {
              return TweenAnimationBuilder<double>(
                key: ValueKey(leaves[index].id),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(
                  milliseconds: 300 + (index * 50).clamp(0, 400),
                ),
                curve: Curves.easeOut,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                ),
                child: _LeaveCard(leave: leaves[index]),
              );
            }

            if (!controller.hasMore.value && leaves.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.withOpacity(0.3)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "All records loaded",
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.withOpacity(0.3)),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );
    });
  }
}
// ─── Leave Card ────────────────────────────────────────────────────────────────

class _LeaveCard extends StatelessWidget {
  final Leaves leave;

  const _LeaveCard({required this.leave});

  // ── Status helpers ──────────────────────────────────────────────────────────

  StatusTheme _getTheme(String status) {
    switch (status.trim().toLowerCase()) {
      case 'approved':
        return StatusTheme(
          color: const Color(0xFF00C48C),
          bg: const Color(0xFFE6FFF7),
          icon: Icons.check_circle_rounded,
          gradient: [const Color(0xFF00C48C), const Color(0xFF00A878)],
        );
      case 'pending':
        return StatusTheme(
          color: const Color(0xFFF59E0B),
          bg: const Color(0xFFFFF8E7),
          icon: Icons.schedule_rounded,
          gradient: [const Color(0xFFF59E0B), const Color(0xFFE08A00)],
        );
      case 'rejected':
      case 'cancelled':
        return StatusTheme(
          color: const Color(0xFFEF4444),
          bg: const Color(0xFFFFEEEE),
          icon: Icons.cancel_rounded,
          gradient: [const Color(0xFFEF4444), const Color(0xFFCC2222)],
        );
      default:
        return StatusTheme(
          color: Colors.grey,
          bg: Colors.grey.shade100,
          icon: Icons.info_rounded,
          gradient: [Colors.grey, Colors.grey.shade600],
        );
    }
  }

  void _showDetails(BuildContext context, StatusTheme theme) {
    CustomBlurBottomSheet.show(
      context,
      widget: _LeaveDetailSheet(leave: leave, theme: theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme(leave.status);
    final isPending = leave.status.trim().toLowerCase() == 'pending';

    final fromStr = DateFormat('dd MMM').format(leave.fromDate);
    final toStr = DateFormat('dd MMM yyyy').format(leave.toDate);
    // return SizedBox.shrink();
    return GestureDetector(
      onTap: () => _showDetails(context, theme),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.color.withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left accent bar with gradient ─────────────────────────────
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: theme.gradient,
                    ),
                  ),
                ),

                // ── Card content ──────────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: icon + type + date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: theme.color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      _leaveIcon(leave.type),
                                      color: theme.color,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Text(
                                      leave.type,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E1B4B),
                                        letterSpacing: 0.1,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    size: 13,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "$fromStr – $toStr",
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F3FF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${leave.duration} Day${leave.duration != 1 ? 's' : ''} • ${DayType.getName(leave.leaveDurationType)}",
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: Color(0xFF6C5CE7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Right: status + actions
                        // ⚠️ mainAxisSize.min + mainAxisAlignment.start (NOT spaceBetween)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: theme.bg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.color.withOpacity(0.25),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    theme.icon,
                                    size: 11,
                                    color: theme.color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _capitalize(leave.status.trim()),
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: theme.color,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            if (isPending)
                              GestureDetector(
                                onTap: () =>
                                    LeaveController.to.cancelLeave(leave),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEEEE),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFEF4444,
                                      ).withOpacity(0.3),
                                    ),
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                              )
                            else
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.grey.shade300,
                                size: 20,
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

  IconData _leaveIcon(String type) {
    final t = type.toLowerCase();
    if (t.contains('casual')) return Icons.wb_sunny_rounded;
    if (t.contains('earn') || t.contains('annual')) {
      return Icons.card_travel_rounded;
    }
    if (t.contains('float')) return Icons.auto_awesome_rounded;
    if (t.contains('sick') || t.contains('medical')) {
      return Icons.healing_rounded;
    }
    if (t.contains('maternity') || t.contains('paternity')) {
      return Icons.child_care_rounded;
    }
    return Icons.event_note_rounded;
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}

// ─── FAB ───────────────────────────────────────────────────────────────────────

class _FAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => Get.to(() => SubmitLeaveScreen()),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            "Submit New Leave",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C5CE7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 6,
            shadowColor: const Color(0xFF6C5CE7).withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

// ─── Filter Bottom Sheet ───────────────────────────────────────────────────────

class _FilterSheetContent extends StatefulWidget {
  final LeaveController controller;

  const _FilterSheetContent({required this.controller});

  @override
  State<_FilterSheetContent> createState() => _FilterSheetContentState();
}

class _FilterSheetContentState extends State<_FilterSheetContent> {
  late String _status;
  DateTime? _date;

  final List<String> _statuses = ['All', 'Pending', 'Approved', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _status = widget.controller.selectedStatus.value;
    _date = widget.controller.selectedDate.value;
  }

  Color _chipColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF00C17C);
      case 'Pending':
        return const Color(0xFFFF9800);
      case 'Cancelled':
        return const Color(0xFFFF4D4D);
      default:
        return const Color(0xFF6C5CE7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Text(
            "Filter Leaves",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1B4B),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Status",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _statuses.map((s) {
              final isSelected = _status == s;
              final color = _chipColor(s);
              return GestureDetector(
                onTap: () => setState(() => _status = s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? color : color.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // const Text(
          //   "Date",
          //   style: TextStyle(
          //     fontWeight: FontWeight.w600,
          //     color: Colors.grey,
          //     fontSize: 13,
          //   ),
          // ),
          // const SizedBox(height: 10),
          // GestureDetector(
          //   onTap: () async {
          //     final picked = await showDatePicker(
          //       context: context,
          //       initialDate: _date ?? DateTime.now(),
          //       firstDate: DateTime(2023),
          //       lastDate: DateTime(2026),
          //       builder: (context, child) => Theme(
          //         data: Theme.of(context).copyWith(
          //           colorScheme: const ColorScheme.light(
          //             primary: Color(0xFF6C5CE7),
          //           ),
          //         ),
          //         child: child!,
          //       ),
          //     );
          //     if (picked != null) setState(() => _date = picked);
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          //     decoration: BoxDecoration(
          //       color: const Color(0xFFF5F3FF),
          //       borderRadius: BorderRadius.circular(12),
          //       border: Border.all(color: const Color(0xFFEDE9FE)),
          //     ),
          //     child: Row(
          //       children: [
          //         const Icon(
          //           Icons.calendar_today_outlined,
          //           size: 18,
          //           color: Color(0xFF6C5CE7),
          //         ),
          //         const SizedBox(width: 10),
          //         Text(
          //           _date == null
          //               ? "Select a date"
          //               : "${_date!.day}/${_date!.month}/${_date!.year}",
          //           style: TextStyle(
          //             color: _date == null
          //                 ? Colors.grey
          //                 : const Color(0xFF1E1B4B),
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //         const Spacer(),
          //         if (_date != null)
          //           GestureDetector(
          //             onTap: () => setState(() => _date = null),
          //             child: const Icon(
          //               Icons.close,
          //               size: 16,
          //               color: Colors.grey,
          //             ),
          //           ),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _status = 'All';
                      _date = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.controller.applyFilter(_status, _date);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 4,
                    shadowColor: const Color(0xFF6C5CE7).withOpacity(0.4),
                  ),
                  child: const Text(
                    "Apply Filters",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeaveDetailSheet extends StatelessWidget {
  final Leaves leave;
  final StatusTheme theme;

  const _LeaveDetailSheet({required this.leave, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isPending = leave.status.trim().toLowerCase() == 'pending';
    final dateRange =
        "${DateFormat('dd MMM yyyy').format(leave.fromDate)} – ${DateFormat('dd MMM yyyy').format(leave.toDate)}";

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──────────────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.only(top: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // ── Hero header ─────────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.color.withOpacity(0.12),
                  theme.color.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.color.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                // Gradient icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: theme.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: theme.color.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(theme.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leave.type,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: theme.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _capitalize(leave.status.trim()),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: theme.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Big duration number
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${leave.duration}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: theme.color,
                        height: 1,
                      ),
                    ),
                    Text(
                      "Day${leave.duration != 1 ? 's' : ''}",
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.color.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Detail rows ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                _DetailTile(
                  icon: Icons.calendar_month_rounded,
                  label: "Date Range",
                  value: dateRange,
                  iconColor: const Color(0xFF6C5CE7),
                ),
                _DetailTile(
                  icon: Icons.timelapse_rounded,
                  label: "Duration Type",
                  value: DayType.getName(leave.leaveDurationType),
                  iconColor: const Color(0xFF00C48C),
                ),
                _DetailTile(
                  icon: Icons.person_pin_rounded,
                  label: "Reporting Manager",
                  value: leave.reportingManagerName,
                  iconColor: const Color(0xFFF59E0B),
                ),
                _DetailTile(
                  icon: Icons.event_available_rounded,
                  label: "Applied On",
                  value: DateFormat('dd MMM yyyy').format(leave.appliedOn),
                  iconColor: const Color(0xFF00D2FF),
                ),
                if (leave.isHalfDay == 1)
                  _DetailTile(
                    icon: Icons.splitscreen_rounded,
                    label: "Half Day Shift",
                    value: leave.leaveShift?.toString() ?? "—",
                    iconColor: const Color(0xFFFFC371),
                  ),
              ],
            ),
          ),

          // ── Reason box ──────────────────────────────────────────────────────
          if (leave.reason.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF6C5CE7).withOpacity(0.15),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    color: Color(0xFF6C5CE7),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      leave.reason,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF4A3FB5),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Cancel button ────────────────────────────────────────────────────
          if (isPending) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    LeaveController.to.cancelLeave(leave);
                  },
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text(
                    "Cancel Leave Request",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],

          // ── Bottom safe area ────────────────────────────────────────────────
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}

// ─── Detail Tile ───────────────────────────────────────────────────────────────

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
