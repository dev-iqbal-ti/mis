import 'dart:developer';

import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/travel_allowance/controllers/submit_travel_allowance_controller.dart';
import 'package:dronees/features/authorized/travel_allowance/controllers/travel_allowsnce_controller.dart';
import 'package:dronees/features/authorized/travel_allowance/models/travel_allowance_model.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/widgets/confirm_sheet.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

// Assuming your model and AuthController are imported here
// import 'path_to_your_model.dart';
// import 'path_to_auth_controller.dart';

class TravelAllowanceDetailScreen extends StatelessWidget {
  final TravelAllowance data;
  final bool isOwner;

  const TravelAllowanceDetailScreen({
    super.key,
    required this.data,
    required this.isOwner,
  });

  // Helper for status colors
  Color getStatusColor(String status) {
    switch (status) {
      case 'Rejected':
        return Colors.red.shade700;
      case 'Pending':
        return Colors.orange.shade700;
      default:
        return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic for Role and Ownership
    // Note: Replace 'role' with your actual key (e.g., .roleName or .roleId)
    final currentUser = AuthController.instance.authUser?.userDetails;
    final String userRole = "manager"; // e.g., "manager" or "finance"
    final controller = TravelAllowanceController.instance;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "TA Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildSectionTitle("Requester Info"),
            _buildInfoCard([
              _infoRow("Employee", data.name),
              _infoRow("Contact", data.contact),
            ]),
            if (data.taType == 'Advance') ...[
              const SizedBox(height: 20),
              _buildSectionTitle("Journey Details"),
              _buildJourneyCard(),
            ],
            const SizedBox(height: 20),
            _buildSectionTitle("Financials"),
            _buildInfoCard([
              if (data.taType == 'Normal')
                _infoRow("Claim Amount", "₹${data.amount ?? '0.00'}")
              else ...[
                _infoRow("Estimated Total", "₹${data.totalEstimatedExpense}"),
                _infoRow("Advance Requested", "₹${data.advanceAmount}"),
                _infoRow(
                  "Accommodation Req.",
                  data.accommodationRequired ? "Yes" : "No",
                ),
              ],
            ]),
            const SizedBox(height: 20),
            _buildSectionTitle("Purpose & Remarks"),
            _buildPurposeConversation(),

            if (data.imageUrl != null) ...[
              SizedBox(height: 20),
              _buildSectionTitle("Attachments"),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  data.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            SizedBox(height: 40),
            // Space for bottom buttons
          ],
        ),
      ),
      // STICKY ACTION BUTTONS
      bottomNavigationBar: data.status == "Rejected"
          ? null
          : isOwner && data.status != "Pending"
          ? null
          : _buildEnhancedActions(
              context,
              data.id,
              controller,
              isOwner,
              userRole,
            ),
    );
  }

  Widget _buildEnhancedActions(
    BuildContext context,
    int taId,
    TravelAllowanceController controller,
    bool isOwner,
    String role,
  ) {
    log(taId.toString());
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isOwner)
            Expanded(
              child: _gradientButton(
                "Delete Request",
                [Colors.redAccent, Colors.red.shade900],
                Icons.delete_outline,
                controller.isLoading,
                () {
                  CustomBlurBottomSheet.show(
                    context,
                    widget: ConfirmSheet(
                      title: "Delete Request?",
                      description:
                          "Are you sure you want to remove this TA request? This action cannot be reversed.",
                      confirmText: "Yes, Delete",
                      themeColor: Colors.redAccent,
                      icon: Icons.delete_sweep_rounded,
                      onConfirm: () {
                        controller.deleteTAReqast(taId);
                      },
                    ),
                  );
                },
              ),
            )
          else if (role == 'manager') ...[
            Expanded(
              child: _outlineButton(
                "Reject",
                Colors.red,
                () => CustomBlurBottomSheet.show(
                  context,
                  widget: _showRejectSheet(context),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _gradientButton(
                "Approve",
                [Colors.greenAccent.shade700, Colors.green.shade900],
                Icons.check_circle_outline,
                controller.isLoading,
                () {
                  CustomBlurBottomSheet.show(
                    context,
                    widget: ConfirmSheet(
                      title: "Approved Request?",
                      description:
                          "Are you sure you want to approve this TA request? This action cannot be reversed.",
                      confirmText: "Yes, Approve",
                      themeColor: Colors.green,
                      icon: Iconsax.card_tick_1_copy,
                      onConfirm: () {
                        controller.approveTAReqast(taId);
                      },
                    ),
                  );
                },
              ),
            ),
          ] else if (role == 'finance') ...[
            Expanded(
              child: _outlineButton(
                "Reject",
                Colors.red,
                () => CustomBlurBottomSheet.show(
                  context,
                  widget: _showRejectSheet(context),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _gradientButton(
                "Initialize",
                [Colors.blueAccent, Colors.indigo.shade900],
                Icons.account_balance_wallet_outlined,
                controller.isLoading,
                () {},
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _showRejectSheet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Keyboard padding
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Rejection Remarks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Text(
            "Please provide a reason for rejecting this request.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 15),
          TextField(
            // controller: _remarkController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter reason here...",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // BRO: Call your Reject API here using _remarkController.text
                // print("Rejected with: ${_remarkController.text}");
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Confirm Rejection",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // STYLED COMPONENT: Gradient Button
  Widget _gradientButton(
    String label,
    List<Color> colors,
    IconData icon,
    RxBool isLoading, // Add this
    VoidCallback onTap,
  ) {
    return Obx(
      () => Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (isLoading.value == false) {
              onTap();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // STYLED COMPONENT: Outlined Button for "Reject"
  Widget _outlineButton(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _actionButton(
    String title,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // --- UI Components (Same logic as before, now using Model properties) ---

  Widget _buildPurposeConversation() {
    if (data.purpose.contains("/:reply:")) {
      var parts = data.purpose.split("/:reply:");
      return Column(
        children: [
          _chatBubble(
            parts[0].trim(),
            "Your Purpose",
            Colors.blue.shade50,
            Colors.blue.shade900,
            true,
          ),
          const SizedBox(height: 10),
          _chatBubble(
            parts[1].trim(),
            "Dept. Remark",
            Colors.red.shade50,
            Colors.red.shade900,
            false,
          ),
        ],
      );
    }
    return _buildInfoCard([_infoRow("Purpose", data.purpose)]);
  }

  Widget _chatBubble(
    String text,
    String label,
    Color bg,
    Color textCol,
    bool isLeft,
  ) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isLeft ? 0 : 12),
            bottomRight: Radius.circular(isLeft ? 12 : 0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textCol.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textCol,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.taNo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${data.taType} Type",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor(data.status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard() {
    final df = DateFormat('dd MMM yyyy');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _infoRow("Tour", data.tourType),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _routePoint(
                data.fromLocation ?? "N/A",
                data.departureDate != null
                    ? df.format(data.departureDate!)
                    : "",
              ),
              Icon(Icons.swap_horiz, color: Colors.grey[400]),
              _routePoint(
                data.toLocation ?? "N/A",
                data.returnDate != null ? df.format(data.returnDate!) : "",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              value ?? "N/A",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routePoint(String city, String date) {
    return Column(
      children: [
        Text(
          city,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
          letterSpacing: 1,
        ),
      ),
    );
  }
}
