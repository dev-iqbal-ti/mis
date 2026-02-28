import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dronees/bottom_navigator.dart';
import 'package:dronees/features/authorized/gallery/screens/gallery_screen.dart';
import 'package:dronees/features/authorized/gallery/screens/image_details_screen.dart';
import 'package:dronees/features/authorized/home/controllers/home_controller.dart';
import 'package:dronees/features/authorized/home/widgets/enhanced_attendance_card.dart';
import 'package:dronees/utils/constants/contants.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(controller)),
                SliverToBoxAdapter(child: _buildQuickStats(controller)),
                SliverToBoxAdapter(child: buildAttendanceCard(controller)),
                SliverToBoxAdapter(
                  child: _buildRecentlyUploadedImages(controller),
                ),
                SliverToBoxAdapter(child: _buildQuickActionsSection()),
                SliverToBoxAdapter(
                  child: _buildPendingTravelAllowance(controller),
                ),
                SliverToBoxAdapter(child: _buildUpcomingLeave(controller)),
                SliverToBoxAdapter(child: _buildRecentActivity()),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  HEADER
  // ─────────────────────────────────────────
  Widget _buildHeader(HomeController controller) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        TSizes.defaultPadding,
        Platform.isAndroid ? 20 : 8,
        TSizes.defaultPadding,
        12,
      ),
      child: Row(
        children: [
          // Avatar with gradient
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4776E6).withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Obx(
                () => Text(
                  controller.initials.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.formattedToday,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    'Hi, ${controller.fullName.value.split(' ').first} 👋',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1F36),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Date pill
          // Obx(() {
          //   final dt = controller.today.value;
          //   if (dt == null) return const SizedBox.shrink();
          //   return Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(14),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.05),
          //           blurRadius: 10,
          //           offset: const Offset(0, 3),
          //         ),
          //       ],
          //     ),
          //     child: Column(
          //       children: [
          //         Text(
          //           DateFormat('dd').format(dt),
          //           style: const TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.w900,
          //             color: Color(0xFF4776E6),
          //             height: 1,
          //           ),
          //         ),
          //         Text(
          //           DateFormat('MMM').format(dt).toUpperCase(),
          //           style: TextStyle(
          //             fontSize: 10,
          //             fontWeight: FontWeight.w700,
          //             color: Colors.grey.shade500,
          //             letterSpacing: 1,
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  QUICK STATS
  // ─────────────────────────────────────────
  Widget _buildQuickStats(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultPadding,
        vertical: 4,
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.calendar_today_rounded,
                label: 'Present Days',
                value: controller.today.value == null
                    ? 'N/A'
                    : DateFormat('dd MMM').format(controller.today.value!),
                color: const Color(0xFF00C48C),
                bgColor: const Color(0xFFE6FAF4),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                icon: Icons.celebration_rounded,
                label: 'Upcomming Holiday',
                value: controller.formattedHoliday,
                color: const Color(0xFFFF6B6B),
                bgColor: const Color(0xFFFFF0F0),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                icon: Iconsax.airplane,
                label: 'Upcomming Leave',
                value: controller.nextLeaveDate,
                color: const Color(0xFFFF9800),
                bgColor: const Color(0xFFFFF3E0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1F36),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  ATTENDANCE CARD (delegated)
  // ─────────────────────────────────────────
  Widget buildAttendanceCard(HomeController controller) {
    return EnhancedAttendanceCard(controller: controller);
  }

  // ─────────────────────────────────────────
  //  RECENTLY UPLOADED IMAGES
  // ─────────────────────────────────────────
  Widget _buildRecentlyUploadedImages(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle('Recent Uploads'),
                // _seeAllButton('See All', () {
                //   NavigationController.to.changeIndex(3);
                // }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final images = controller.galleryImages;
            if (images.isEmpty) {
              return _buildEmptyState(
                icon: Icons.photo_library_outlined,
                message: 'No uploads yet',
                height: 140,
              );
            }
            return SizedBox(
              height: 140,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultPadding,
                ),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: images.length + 1, // 🔥 +1 for See All
                itemBuilder: (context, index) {
                  /// ✅ LAST ITEM → SEE ALL CARD
                  if (index == images.length) {
                    return Container(
                      width: 105,
                      margin: const EdgeInsets.only(
                        left: 8,
                        right: 4,
                        bottom: 4,
                        top: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => NavigationController.to.changeIndex(3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.grid_view_rounded,
                                  size: 24,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "See All",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  /// ✅ NORMAL IMAGE CARD
                  final img = images[index];

                  return GestureDetector(
                    onTap: () {
                      controller.selectedImage.value = img;
                      Get.to(
                        () => ImageDetailScreen(
                          selectedItem: controller.selectedImage,
                          detailsItems: images,
                          onConformDelete: (id) {
                            controller.deleteImage(id);
                          },
                          showHero: false,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < images.length - 1 ? 12 : 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 105,
                              height: 140,
                              imageUrl: img.thumbnailUrl,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey[400],
                                      size: 30,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Unavailable",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// 📅 Date Overlay
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.65),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  DateFormat(
                                    'MMM d',
                                  ).format(img.createdAt.toLocal()),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  QUICK ACTIONS
  // ─────────────────────────────────────────
  Widget _buildQuickActionsSection() {
    List<List<dynamic>> chunks = [];
    for (var i = 0; i < homeScreenQuickActions.length; i += 2) {
      chunks.add(
        homeScreenQuickActions.sublist(
          i,
          (i + 2 > homeScreenQuickActions.length)
              ? homeScreenQuickActions.length
              : i + 2,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TSizes.defaultPadding,
        0,
        TSizes.defaultPadding,
        TSizes.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Quick Actions'),
          const SizedBox(height: TSizes.minSpaceBtw),
          Column(
            children: chunks.map((chunk) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: chunk.asMap().entries.map((entry) {
                    final index = entry.key;
                    final e = entry.value;
                    final isSingle = chunk.length == 1;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: (!isSingle && index == 0) ? 12.0 : 0,
                        ),
                        child: AspectRatio(
                          aspectRatio: isSingle ? 2.2 : 1.1,
                          child: _buildActionCard(
                            icon: e.icon,
                            title: e.title,
                            subtitle: e.subtitle,
                            color: e.color,
                            onTap: e.onTap,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.08), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: color.withOpacity(0.08),
          highlightColor: color.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.07),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  PENDING TRAVEL ALLOWANCE
  // ─────────────────────────────────────────
  Widget _buildPendingTravelAllowance(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TSizes.defaultPadding,
        0,
        TSizes.defaultPadding,
        TSizes.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle('Pending Allowance'),
              _seeAllButton('View All', () {}),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final list = controller.pendingAllowances;
            if (list.isEmpty) {
              return _buildEmptyState(
                icon: Icons.receipt_long_outlined,
                message: 'No pending allowances',
                height: 80,
              );
            }
            return Column(
              children: list
                  .map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildAllowanceCard(allowance: a),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAllowanceCard({required PendingAllowance allowance}) {
    const accentColor = Color(0xFF00BCD4);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.18),
                  accentColor.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: accentColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        allowance.purpose.capitalizeFirst ?? allowance.purpose,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1F36),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        allowance.taNo,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 11,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      allowance.formattedDate,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
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
              Text(
                allowance.formattedAmount,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 5),
              _statusBadge(allowance.statusLabel),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  UPCOMING LEAVE
  // ─────────────────────────────────────────
  Widget _buildUpcomingLeave(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TSizes.defaultPadding,
        0,
        TSizes.defaultPadding,
        TSizes.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle('Upcoming Leave'),
              _seeAllButton('Manage', () {}),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final list = controller.upcomingLeaves;
            if (list.isEmpty) {
              return _buildEmptyState(
                icon: Icons.beach_access_outlined,
                message: 'No upcoming leaves',
                height: 80,
              );
            }
            return Column(
              children: list
                  .map(
                    (leave) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildLeaveCard(leave: leave),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLeaveCard({required LeaveEntry leave}) {
    final color = leave.isApproved
        ? const Color(0xFF00C48C)
        : const Color(0xFF9C27B0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.18), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.18), color.withOpacity(0.07)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              leave.isApproved
                  ? Icons.check_circle_rounded
                  : Icons.schedule_rounded,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leave.leaveTypeName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 11,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      leave.formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (leave.reason.isNotEmpty)
                      Expanded(
                        child: Text(
                          '· ${leave.reason.capitalizeFirst}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _statusBadge(leave.status, color: color),
              const SizedBox(height: 5),
              Text(
                leave.daysLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  RECENT ACTIVITY (unchanged as requested)
  // ─────────────────────────────────────────
  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Recent Activity'),
          const SizedBox(height: 12),
          _buildActivityItem(
            icon: Icons.task_alt_rounded,
            title: 'Task Completed',
            subtitle: 'Site inspection at MG Road',
            time: '2 hours ago',
            color: const Color(0xFF4CAF50),
          ),
          _buildActivityItem(
            icon: Icons.photo_camera_rounded,
            title: 'Photos Uploaded',
            subtitle: '5 work photos added to gallery',
            time: '5 hours ago',
            color: const Color(0xFFE91E63),
          ),
          _buildActivityItem(
            icon: Icons.check_circle_rounded,
            title: 'Leave Approved',
            subtitle: 'Sick leave for Jan 30',
            time: 'Yesterday',
            color: const Color(0xFF9C27B0),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────
  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: Color(0xFF1A1F36),
      letterSpacing: -0.5,
    ),
  );

  Widget _seeAllButton(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF4776E6).withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4776E6),
        ),
      ),
    ),
  );

  Widget _statusBadge(String label, {Color? color}) {
    final c = color ?? _statusColor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: c,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF00C48C);
      case 'rejected':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFFFFA726);
    }
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    double height = 100,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey.shade300, size: 28),
            const SizedBox(height: 6),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
