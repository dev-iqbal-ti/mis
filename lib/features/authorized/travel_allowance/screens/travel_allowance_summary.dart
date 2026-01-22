import 'dart:io';

import 'package:dronees/features/authorized/travel_allowance/screens/submit_travel_allowance.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelAllowanceSummary extends StatelessWidget {
  const TravelAllowanceSummary({super.key});

  @override
  Widget build(BuildContext context) {
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
                top: Platform.isAndroid ? TSizes.defaultPadding + 5 : 0,
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
                    // Summary Card
                    Container(
                      margin: const EdgeInsets.all(TSizes.defaultPadding),
                      padding: const EdgeInsets.all(TSizes.defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Allowance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Period 1 Jan 2025 - 30 Dec 2025',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(height: TSizes.spaceBtwItems),
                          Row(
                            children: [
                              _buildSummaryItem(
                                icon: Icons.currency_rupee,
                                iconColor: const Color(0xFF6C5CE7),
                                label: 'Total',
                                amount: '₹1010',
                              ),
                              const SizedBox(width: 20),
                              _buildSummaryItem(
                                icon: Icons.pending,
                                iconColor: const Color(0xFFFFA726),
                                label: 'Review',
                                amount: '₹455',
                              ),
                              const SizedBox(width: 20),
                              _buildSummaryItem(
                                icon: Icons.check_circle,
                                iconColor: const Color(0xFF66BB6A),
                                label: 'Approved',
                                amount: '₹555',
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFilterTab('Review', 3, true),
                          const SizedBox(width: 12),
                          _buildFilterTab('Approved', 2, false),
                          const SizedBox(width: 12),
                          _buildFilterTab('Rejected', 0, false),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Allowance List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _buildAllowanceItem(
                            date: '27 September 2024',
                            type: 'Transportation',
                            amount: '₹55',
                          ),
                          const SizedBox(height: 12),
                          _buildAllowanceItem(
                            date: '24 September 2024',
                            type: 'Accommodation',
                            amount: '₹155',
                          ),
                          const SizedBox(height: 12),
                          _buildAllowanceItem(
                            date: '21 September 2024',
                            type: 'Meals & Entertainment',
                            amount: '₹255',
                          ),
                          const SizedBox(height: 12),
                          _buildAllowanceItem(
                            date: '21 September 2024',
                            type: 'Meals & Entertainment',
                            amount: '₹515',
                          ),
                          const SizedBox(height: 12),
                          _buildAllowanceItem(
                            date: '21 September 2024',
                            type: 'Meals & Entertainment',
                            amount: '₹5345',
                          ),
                          const SizedBox(height: 12),
                          _buildAllowanceItem(
                            date: '21 September 2024',
                            type: 'Meals & Entertainment',
                            amount: '₹155',
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
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
        color: Color(0xFFF5F6FA),

        child: ElevatedButton(
          onPressed: () {
            Get.to(() => SubmitTravelAllowance());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C5CE7),

            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: const Color(0xFF6C5CE7).withOpacity(0.4),
            side: BorderSide(color: const Color(0xFF6C5CE7), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
            ),
          ),
          child: const Text(
            'Submit Allowance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      // floatingActionButton:
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: const Color(0xFF2D3436),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.1),
      //         blurRadius: 20,
      //         offset: const Offset(0, -4),
      //       ),
      //     ],
      //   ),
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 12),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           _buildNavIcon(Icons.home_outlined, false),
      //           _buildNavIcon(Icons.calendar_today_outlined, false),
      //           _buildNavIcon(Icons.receipt_outlined, false),
      //           _buildNavIcon(Icons.receipt_long, true),
      //           _buildNavIcon(Icons.layers_outlined, false),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String amount,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, int count, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6C5CE7) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.grey,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : const Color(0xFFE8E8E8),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isActive ? const Color(0xFF6C5CE7) : Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAllowanceItem({
    required String date,
    required String type,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: const Color(0xFF6C5CE7),
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Type',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Allowance',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive) {
    return Icon(icon, color: isActive ? Colors.white : Colors.grey, size: 24);
  }
}
