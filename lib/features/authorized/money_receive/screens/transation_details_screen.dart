import 'dart:io';

import 'package:dronees/clipper/ticket_clipper.dart';
import 'package:dronees/features/authorized/money_receive/models/money_record.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDetailScreen extends StatelessWidget {
  final MoneyRecord record;
  const TransactionDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // Dim the background
      body: GestureDetector(
        onTap: () => Get.back(), // Close when tapping outside
        child: Center(
          child: Hero(
            tag: record.id, // Same ID as the list item
            child: SingleChildScrollView(
              child: Material(
                color: Colors.transparent,
                child:
                    _buildTicketUI(), // Your Ticket UI logic from previous turn
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketUI() {
    return Container(
      width: Get.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: ClipPath(
        clipper: TicketClipper(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- HEADER: Project, Method, Date ---
            _buildHeader(),

            const SizedBox(height: 24),

            // --- PAID AMOUNT ---
            _buildAmountSection(),

            const SizedBox(height: 20),

            // --- CONDITIONAL REMARK (TOP) ---
            if (record.imagePath != null) _buildRemark(record.remark),

            // --- PHOTO PROOF ---
            if (record.imagePath != null) _buildPhotoProof(record.imagePath!),

            // --- CONDITIONAL REMARK (BOTTOM) ---
            if (record.imagePath == null) _buildRemark(record.remark),

            const SizedBox(height: 10),

            // --- DASHED LINE & HELP ---
            _buildDashedSeparator(),

            // --- ACTION BUTTON ---
            _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  // Helper methods (Header, Amount, Remark, etc.) would go here...
  // 1. HEADER: Project, Method, and Date
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Text(
            "Project: ${record.projectName}  |  Method: ${record.mode}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Date: ${record.date} • 12:45 PM",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 2. AMOUNT SECTION: Large central display
  Widget _buildAmountSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 12, right: 4),
              child: Text(
                "Paid",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Text(
              "₹",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.8,
                color: Color(0xFF6C5CE7),
              ),
            ),
            Text(
              record.amount,
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: Color(0xFF2D3436),
              ),
            ),
          ],
        ),
        const Text(
          "to Dronees Office",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // 3. REMARK: Reusable text block
  Widget _buildRemark(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
          fontStyle: FontStyle.italic,
          height: 1.4,
        ),
      ),
    );
  }

  // 4. PHOTO PROOF: Dark container with contained image
  Widget _buildPhotoProof(String path) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF1E1E1E), // Dark background for contrast
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(File(path), fit: BoxFit.contain),
      ),
    );
  }

  // 5. DASHED SEPARATOR: The "Tear" line
  Widget _buildDashedSeparator() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: List.generate(
              25,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: index % 2 == 0
                      ? Colors.transparent
                      : Colors.grey.shade300,
                  height: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Need help with this transaction?",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "click here",
            style: TextStyle(
              color: Color(0xFF6C5CE7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // 6. CLOSE BUTTON: Styled primary button
  Widget _buildCloseButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C5CE7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Close Report",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
