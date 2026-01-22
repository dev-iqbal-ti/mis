import 'dart:developer';

import 'package:dronees/features/authorized/leave/controllers/leave_controller.dart';
import 'package:dronees/features/authorized/leave/screens/submit_leave_screen.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveSummaryScreen extends StatelessWidget {
  LeaveSummaryScreen({super.key});
  final LeaveController controller = Get.put(LeaveController());

  @override
  Widget build(BuildContext context) {
    // Initialize the controller

    return Scaffold(
      backgroundColor: TColors.lightGrayBackground,
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 80),
              _buildTabSelector(controller),
              Expanded(
                // Use Obx to listen to tab changes
                child: Obx(() => _buildTabContent(controller)),
              ),
            ],
          ),
          Positioned(top: 130, child: _buildSummaryCard(context)),
          // Positioned(child: _buildSummaryCard()),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildHeader() {
    return Container(
      height: 220,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: TDeviceUtils.getAppBarHeight(),
        left: TSizes.defaultPadding,
        right: TSizes.defaultPadding,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF7B61FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Leave Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Submit Leave",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      width: TDeviceUtils.getScreenWidth(context) - (TSizes.defaultPadding * 2),
      height: 170,
      padding: const EdgeInsets.all(TSizes.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Leave",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text(
            "Period 1 Jan 2024 - 30 Dec 2024",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoBox(
                "Available",
                "${controller.availableLeave}",
                Colors.green,
              ),
              const SizedBox(width: 12),
              _buildInfoBox(
                "Leave Used",
                "${controller.usedLeave}",
                const Color(0xFF7B61FF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 4, backgroundColor: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector(LeaveController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Obx(
        () => Row(
          children: [
            _tabItem("Review", 0, controller),
            _tabItem("Approved", 1, controller),
            _tabItem("Rejected", 2, controller),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, int index, LeaveController controller) {
    bool isSelected = controller.selectedTabIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7B61FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(LeaveController controller) {
    switch (controller.selectedTabIndex.value) {
      case 0:
        {
          final leaves = controller.leaves
              .where((leave) => leave["status"] == "Pending")
              .toList();
          log(leaves.toString());
          return _buildApprovedList(leaves);
          // return _buildEmptyState();
        }

      case 1:
        {
          final leaves = controller.leaves
              .where((leave) => leave["status"] == "Approved")
              .toList();
          log(leaves.toString());
          return _buildApprovedList(leaves);
        }
      case 2:
        {
          final leaves = controller.leaves
              .where((leave) => leave["status"] == "Rejected")
              .toList();
          log(leaves.toString());
          return _buildApprovedList(leaves);
        }
      default:
        return const Center(child: Text("No Data"));
    }
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.luggage, size: 100, color: Colors.purple.shade50),
        const SizedBox(height: 16),
        const Text(
          "No Leave Submitted!",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: Text(
            "Ready to catch some fresh air? Click \"Submit Leave\" and take that well-deserved break!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildApprovedList(List<Map<String, dynamic>> leaves) {
    if (leaves.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultPadding),
      itemCount: leaves.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = leaves[index];
        return Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  color: Color(0xFF7B61FF),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  item['submitDate'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: TColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.minSpaceBtw),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _leaveDetailColumn("Leave Date", item['range']),
                        _leaveDetailColumn(
                          "Total Leave",
                          "${item['totalDays']} Days",
                          crossAxis: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                    item["status"] == "Pending"
                        ? SizedBox.shrink()
                        : const Divider(height: 30),
                    item["status"] == "Pending"
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Approved at ${item['reviewedDate']}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "By ",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.orangeAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['reviewer'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.minSpaceBtw),
          ],
        );
      },
    );
  }

  Widget _leaveDetailColumn(
    String label,
    String value, {
    CrossAxisAlignment crossAxis = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: () => Get.to(() => SubmitLeaveScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7B61FF),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Submit Leave",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// import 'package:dronees/features/authorized/leave/controllers/leave_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LeaveSummaryScreen extends StatelessWidget {
//   const LeaveSummaryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final LeaveController controller = Get.put(LeaveController());

//     return Scaffold(
//       backgroundColor: const Color(0xFF6C5CE7),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header Section
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Leave Summary',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Submit Leave',
//                         style: TextStyle(color: Colors.white70, fontSize: 14),
//                       ),
//                     ],
//                   ),
//                   // Decorative icon
//                   Image.asset(
//                     'assets/leave_icon.png',
//                     width: 80,
//                     height: 80,
//                     errorBuilder: (context, error, stackTrace) => const Icon(
//                       Icons.assignment,
//                       color: Colors.white,
//                       size: 50,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Main Content Card
//             Expanded(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),

//                     // Total Leave Card
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 10,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Total Leave',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             const Text(
//                               'Period 1 Jan 2024 - 30 Dec 2024',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: _buildLeaveItem(
//                                     'Available',
//                                     controller.availableLeave.toString(),
//                                     const Color(0xFF00D9A0),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 20),
//                                 Expanded(
//                                   child: _buildLeaveItem(
//                                     'Leave Used',
//                                     controller.usedLeave.toString(),
//                                     const Color(0xFF6C5CE7),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Tab Buttons
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Obx(
//                         () => Row(
//                           children: [
//                             _buildTabButton(
//                               'Review',
//                               1,
//                               controller.selectedTabIndex.value == 1,
//                               () => controller.setTab(1),
//                             ),
//                             const SizedBox(width: 10),
//                             _buildTabButton(
//                               'Approved',
//                               2,
//                               controller.selectedTabIndex.value == 2,
//                               () => controller.setTab(2),
//                             ),
//                             const SizedBox(width: 10),
//                             _buildTabButton(
//                               'Rejected',
//                               3,
//                               controller.selectedTabIndex.value == 3,
//                               () => controller.setTab(3),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Leave Submitted Section
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Leave Submitted',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             const Text(
//                               'Leave information',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(height: 40),

//                             // Empty State
//                             Expanded(
//                               child: Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.luggage_outlined,
//                                       size: 80,
//                                       color: const Color(
//                                         0xFF6C5CE7,
//                                       ).withOpacity(0.3),
//                                     ),
//                                     const SizedBox(height: 20),
//                                     const Text(
//                                       'No Leave Submitted!',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     const Text(
//                                       'Ready to catch some fresh air? Click "Submit Leave" and\ntake that well-deserved break!',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Submit Leave Button
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 56,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Handle submit leave
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF6C5CE7),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: const Text(
//                             'Submit Leave',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       // Bottom Navigation Bar
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF2D2D2D),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
//           ],
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildNavItem(Icons.home_outlined, false),
//                 _buildNavItem(Icons.calendar_today_outlined, false),
//                 _buildNavItem(Icons.assignment_outlined, true),
//                 _buildNavItem(Icons.person_outline, false),
//                 _buildNavItem(Icons.layers_outlined, false),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLeaveItem(String label, String value, Color color) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               width: 8,
//               height: 8,
//               decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   Widget _buildTabButton(
//     String label,
//     int index,
//     bool isSelected,
//     VoidCallback onTap,
//   ) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: isSelected ? const Color(0xFF6C5CE7) : Colors.white,
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(
//               color: isSelected
//                   ? const Color(0xFF6C5CE7)
//                   : Colors.grey.shade300,
//             ),
//           ),
//           child: Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: isSelected ? Colors.white : Colors.grey.shade700,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, bool isSelected) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       child: Icon(
//         icon,
//         color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey.shade400,
//         size: 28,
//       ),
//     );
//   }
// }
