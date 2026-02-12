import 'package:dronees/features/authorized/money_receive/controllers/verify_payment_controller.dart';
import 'package:dronees/features/authorized/money_receive/models/payment_received_model.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class VerifyPaymentScreen extends StatelessWidget {
  const VerifyPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyPaymentController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: AppBar(title: const Text("Payments Received")),
      body: RefreshIndicator(
        onRefresh: controller.fetchPayments,
        child: Column(
          children: [
            // Filter Section
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: CustomBottomSheetDropdown<UserModel>(
            //     label: "Select User",
            //     isSearchable: true,
            //     items: controller.userList,
            //     selectedValue: controller.selectedUser,
            //     isLoading: controller.isUserLoading,
            //     displayText: (user) => user.name,
            //     onSearchChanged: (val) => controller.searchUsers(val),
            //     onSelect: (user) {
            //       controller.selectedUser.value = user;
            //       controller.fetchPayments(); // Refresh list on change
            //     },
            //   ),
            // ),

            // List Section
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.payments.isEmpty) {
                  return SizedBox(
                    width: double.infinity,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Lottie.asset(TImages.emptyList, height: 150),
                        Text(
                          "No Payments record found",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.payments.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index < controller.payments.length) {
                      final payment = controller.payments[index];
                      return _buildPaymentCard(context, payment, controller);
                    } else {
                      return controller.hasMoreData.value
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context,
    PaymentReceivedModel record,
    VerifyPaymentController controller,
  ) {
    return InkWell(
      onTap: () => _showPaymentDetails(context, record, controller),
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
                        "₹${_formatAmount(record.amount)}",
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
                    Icon(
                      Icons.notes_rounded,
                      size: 16,
                      color: Colors.grey[600],
                    ),
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
      ),
    );
  }

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

  // Helper function to format amount
  String _formatAmount(String amount) {
    final number = double.tryParse(amount) ?? 0;
    final formatter = NumberFormat('#,##,##,###.##', 'en_IN');
    String formatted = formatter.format(number);

    // Remove unnecessary decimals if whole number
    if (number == number.truncateToDouble()) {
      formatted = formatted.split('.')[0];
    }

    return formatted;
  }

  void _showPaymentDetails(
    BuildContext context,
    PaymentReceivedModel payment,
    VerifyPaymentController controller,
  ) {
    CustomBlurBottomSheet.show(
      context,
      widget: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Transaction Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),

            // Detail Grid
            _detailRow("Project", payment.projectName),
            _detailRow("Submitted By", payment.createdByName),
            _detailRow(
              "Amount",
              '₹${_formatAmount(payment.amount)}',
              isBold: true,
            ),
            _detailRow("Method", payment.method),
            _detailRow("Remark", payment.remark),
            _detailRow(
              "Date",
              payment.createdAt.toLocal().toString().split('.')[0],
            ),
            if (payment.approvedByName != null)
              _detailRow("Approved By", payment.approvedByName!),

            const SizedBox(height: 30),

            // Action Button
            if (payment.status.toLowerCase() == 'pending')
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      if (controller.isVerifying.value) return;
                      controller.verifyPayment(payment.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isVerifying.value
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : const Text(
                            "Verify & Approve",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                fontSize: 14,
                color: isBold ? TColors.primary : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
