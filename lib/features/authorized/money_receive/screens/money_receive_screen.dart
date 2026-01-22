import 'dart:io';

import 'package:dronees/clipper/ticket_clipper.dart';
import 'package:dronees/features/authorized/money_receive/controllers/money_receive_controller.dart';
import 'package:dronees/features/authorized/money_receive/models/money_record.dart';
import 'package:dronees/features/authorized/money_receive/screens/add_money_receive_screen.dart';
import 'package:dronees/features/authorized/money_receive/screens/transation_details_screen.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MoneyReceiveScreen extends StatelessWidget {
  const MoneyReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MoneyReceiveController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),

          color: Colors.black,
        ),
        title: const Text(
          "Payment Records",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Credit Card UI
          Obx(() => _buildTotalBalanceCard(controller.totalCollected)),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // 2. Transactions List
          Expanded(
            child: Obx(
              () => controller.receipts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.receipts.length,
                      itemBuilder: (context, index) =>
                          _buildTransactionCard(controller.receipts[index]),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddMoneyReceiveScreen()),
        label: const Text(
          "Report Payment",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF6C5CE7),
      ),
    );
  }

  Widget _buildTotalBalanceCard(double total) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultPadding,
        vertical: 15,
      ),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF8E78FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Collected",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Icon(Icons.account_balance_wallet, color: Colors.white54),
                  ],
                ),
                Text(
                  "₹ ${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      "EMPLOYEE ID: 4509",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "VISA/UPI",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildTransactionCard(MoneyRecord record) {
    return Hero(
      tag: record.id, // Unique ID is the key for the animation
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

  Widget _buildCardContent(MoneyRecord record) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Project Name & Amount Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  record.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    letterSpacing: -0.5,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "₹${record.amount}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF6C5CE7),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 2. Metadata: Date and Payment Mode
          Row(
            children: [
              _buildSmallInfo(Icons.calendar_today_rounded, record.date),
              const SizedBox(width: 16),
              _buildSmallInfo(
                Icons.account_balance_wallet_rounded,
                record.mode,
              ),
            ],
          ),

          // 3. Remark Section (Enhanced visibility)
          if (record.remark.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F3F5)),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    record.remark,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                if (record.imagePath != null)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.attachment_rounded,
                      size: 14,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmallInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
