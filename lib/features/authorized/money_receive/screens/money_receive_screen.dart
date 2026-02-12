import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/money_receive/controllers/money_receive_controller.dart';
import 'package:dronees/features/authorized/money_receive/models/payment_received_model.dart';
import 'package:dronees/features/authorized/money_receive/screens/add_money_receive_screen.dart';
import 'package:dronees/features/authorized/money_receive/screens/transation_details_screen.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoneyReceiveScreen extends StatelessWidget {
  const MoneyReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MoneyReceiveController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      // Using an empty appBar or a transparent one to allow Slivers to sit behind it
      body: RefreshIndicator(
        onRefresh: () => controller.onRefresh(),
        edgeOffset:
            100, // Moves the spinner lower so it doesn't overlap the title
        color: const Color(0xFF6C5CE7),
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // 1. Sleek App Bar
            SliverAppBar(
              expandedHeight: TDeviceUtils.getAppBarHeight(),
              floating: true,
              pinned: true,
              elevation: 0,
              centerTitle: true,
              backgroundColor: const Color(0xFFF1F3F8).withOpacity(0.9),
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              title: const Text(
                "Payment Records",
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),

            // 2. Total Balance Section (Scrolls away)
            SliverToBoxAdapter(
              child: Obx(
                () => _buildTotalBalanceCard(controller.collection.value),
              ),
            ),

            // 3. Section Header (Sticky-ready)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    // Optional: Add a filter icon here
                    Icon(Icons.tune_rounded, size: 20, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),

            // 4. Transactions List (Infinite Scroll)
            Obx(() {
              if (controller.isLoading.value &&
                  controller.moneyRecord.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.moneyRecord.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index < controller.moneyRecord.length) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildTransactionCard(
                          controller.moneyRecord[index],
                        ),
                      );
                    } else {
                      // Pagination Loader at the bottom
                      return _buildPaginationLoader(controller);
                    }
                  }, childCount: controller.moneyRecord.length + 1),
                ),
              );
            }),

            // Extra space at the bottom for FAB clearance
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Reusable Pagination Loader
  Widget _buildPaginationLoader(MoneyReceiveController controller) {
    return Obx(
      () => controller.isMoreLoading.value
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              alignment: Alignment.center,
              child: const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Get.to(() => const AddMoneyReceiveScreen()),
      elevation: 4,
      highlightElevation: 8,
      label: const Text(
        "Report Payment",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
      backgroundColor: const Color(0xFF6C5CE7),
    );
  }

  Widget _buildTotalBalanceCard(double total) {
    final userName =
        AuthController.instance.authUser?.userDetails.firstName ?? "User";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F0C29),
            Color(0xFF302B63),
            Color(0xFF24243E),
          ], // Deep Midnight Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF302B63).withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Background Design Element: Large Blurred Glow
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6C5CE7).withOpacity(0.2),
                ),
              ),
            ),

            // Secondary Glow for Depth
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withOpacity(0.15),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Title and Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL COLLECTED",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.wallet_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Main Amount
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8, right: 6),
                        child: Text(
                          "₹",
                          style: TextStyle(
                            color: Color(0xFF6C5CE7),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        total.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Card Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Simulated Chip Icon
                      Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(
                            colors: [
                              Colors.orangeAccent,
                              Colors.yellow.shade200,
                            ],
                          ),
                        ),
                      ),
                      const Text(
                        "MIS PLATINUM",
                        style: TextStyle(
                          color: Colors.white24,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
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

  // Helper function to format amount with Indian numbering system
  String _formatAmount(double amount) {
    final formatter = NumberFormat('#,##,##,###.##', 'en_IN');
    String formatted = formatter.format(amount);

    // Remove unnecessary decimals if it's a whole number
    if (amount == amount.truncateToDouble()) {
      formatted = formatted.split('.')[0];
    }

    return formatted;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.money, size: 100, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            "Money Wallet is empty",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Pending money receives will appear here.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(PaymentReceivedModel record) {
    return Hero(
      tag: 'transaction-${record.id}', // Unique ID is the key for the animation
      child: Material(
        // Material is needed for the Hero transition
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          // ... rest of your existing container decoration ...
          child: InkWell(
            onTap: () => Get.to(
              () => TransactionDetailScreen(record: record),
              opaque: true, // Makes the background transparent
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 400),
            ),
            child: _buildCardContent(record),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(PaymentReceivedModel record) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Row: Project Name & Status Badge
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        letterSpacing: -0.3,
                        color: Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'to ${record.createdByName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusBadge(record.status, record.approvedByName),
            ],
          ),

          const SizedBox(height: 16),

          // 2. Amount Display (Hero element)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6C5CE7).withOpacity(0.08),
                  const Color(0xFF6C5CE7).withOpacity(0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF6C5CE7).withOpacity(0.15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount Received',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${_formatAmount(double.parse(record.amount))}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: Color(0xFF6C5CE7),
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.currency_rupee_rounded,
                    color: Color(0xFF6C5CE7),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Metadata Grid
          Row(
            children: [
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: DateFormat("dd MMM yyyy").format(record.createdAt),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Method',
                  value: record.method,
                ),
              ),
            ],
          ),

          // 4. Remark Section (if present)
          if (record.remark.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notes_rounded, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      record.remark,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (record.proof != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.attachment_rounded,
                        size: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Helper widget for metadata tiles
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Status badge widget
  Widget _buildStatusBadge(String status, String? approvedByName) {
    final bool isApproved =
        status == "Approved"; // Adjust based on your status codes

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isApproved
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isApproved
              ? Colors.green.withOpacity(0.3)
              : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isApproved ? Icons.check_circle_rounded : Icons.pending_rounded,
            size: 14,
            color: isApproved ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isApproved ? 'Approved' : 'Pending',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isApproved ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to format amount with commas
}
