import 'package:cached_network_image/cached_network_image.dart';
import 'package:dronees/features/authorized/money_receive/models/payment_received_model.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add intl for better date formatting
import 'package:shimmer/shimmer.dart';

class TransactionDetailScreen extends StatelessWidget {
  final PaymentReceivedModel record;
  const TransactionDetailScreen({super.key, required this.record});

  // Helper to get status details
  Color _getStatusColor() {
    switch (record.status) {
      case "Approved":
        return const Color(0xFF00B894); // Approved/Success
      case "Pending":
        return const Color(0xFFFDCB6E); // Pending
      default:
        return const Color(0xFFFF7675); // Rejected/Error
    }
  }

  String _getStatusLabel() {
    switch (record.status) {
      case "Approved":
        return "APPROVED";
      case "Pending":
        return "PENDING";
      default:
        return "REJECTED";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(150),
      body: GestureDetector(
        onTap: () => Get.back(),
        child: Center(
          child: Hero(
            tag: 'transaction-${record.id}',
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.defaultPadding,
              ),
              child: Material(
                color: Colors.transparent,
                child: _buildTicketUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketUI() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      // Use ClipPath if you have a specific TicketClipper shape
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 30),
          _buildAmountSection(),
          const SizedBox(height: 20),

          if (record.proof != null) _buildPhotoProof(record.proof!),

          _buildRemarkSection(),

          _buildDashedSeparator(),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TSizes.defaultPadding,
        24,
        TSizes.defaultPadding,
        20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.projectName.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Color(0xFF636E72),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.method,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor().withOpacity(0.5), width: 1),
      ),
      child: Text(
        _getStatusLabel(),
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      children: [
        const Text(
          "TOTAL AMOUNT RECEIVED",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₹",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              record.amount,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2D3436),
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        Text(
          DateFormat('MMM dd, yyyy • hh:mm a').format(record.createdAt),
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildRemarkSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: TSizes.defaultPadding,
      ),
      child: Column(
        children: [
          const Icon(Icons.format_quote, color: Color(0xFFDCDDE1)),
          Text(
            record.remark.isEmpty ? "No remarks provided" : record.remark,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontSize: 15,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 12),
        Text(
          "$label:",
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoProof(String path) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CachedNetworkImage(
          imageUrl: path,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.white,
            child: Container(color: Colors.white),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFFF1F2F6),
            child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildDashedSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: List.generate(
          30,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 1,
              color: index % 2 == 0
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D3436),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Done",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
