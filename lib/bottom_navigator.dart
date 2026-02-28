import 'package:dronees/features/authorized/attendance/screens/attendance_screen.dart';
import 'package:dronees/features/authorized/gallery/screens/gallery_screen.dart';
import 'package:dronees/features/authorized/home/screens/home_screen.dart';
import 'package:dronees/features/authorized/leave/screens/leave_summary_screen.dart';
import 'package:dronees/features/authorized/profile/screens/profile_screens.dart';
import 'package:dronees/features/authorized/travel_allowance/screens/travel_allowance_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

// class BottomNavigator extends StatelessWidget {
//   final NavigationController navBarController = Get.put(NavigationController());

//   // Define your pages here
//   final List<Widget> pages = [
//     HomeScreen(),
//     // AttendanceScreen(),
//     LeaveSummaryScreen(),
//     TravelAllowanceSummary(),
//     GalleryScreen(),
//     ProfileScreen(),
//   ];

//   BottomNavigator({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black, // Matching your image background
//       body: Obx(
//         () => IndexedStack(
//           index: navBarController.selectedIndex.value,
//           children: pages,
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavBar(
//         navBarController: navBarController,
//       ),
//     );
//   }

//   BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
//     return BottomNavigationBarItem(
//       icon: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon),
//           const SizedBox(height: 4),
//           // White indicator line seen in your image
//           AnimatedContainer(
//             duration: Duration(milliseconds: 200),
//             height: 2,
//             width: navBarController.selectedIndex.value == index ? 12 : 0,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         ],
//       ),
//       label: '',
//     );
//   }
// }

// class NavigationController extends GetxController {
//   // Current selected tab index
//   var selectedIndex = 0.obs;

//   // Function to update the index
//   void changeIndex(int index) {
//     if (selectedIndex.value != index) {
//       selectedIndex.value = index;
//       // Optional: Add haptic feedback (uncomment if you want)
//       HapticFeedback.lightImpact();
//     }
//   }
// }

class CustomBottomNavBar extends StatelessWidget {
  final NavigationController navBarController;

  const CustomBottomNavBar({super.key, required this.navBarController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 50,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Iconsax.home, 0, "Home"),
                _buildNavItem(Iconsax.calendar_edit, 1, "Leave"),
                _buildNavItem(Iconsax.transaction_minus, 2, "Travel Allow"),
                _buildNavItem(Iconsax.gallery, 3, "Gallery"),
                _buildNavItem(Iconsax.profile_circle, 4, "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    final isSelected = navBarController.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => navBarController.changeIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF7B61FF), Color(0xFF9D7FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7B61FF).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with scale animation
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white38,
                size: 24,
              ),
            ),

            // Animated label that appears on selection
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigator extends StatelessWidget {
  final NavigationController navBarController = Get.put(NavigationController());

  final List<Widget Function()> pageBuilders = [
    () => HomeScreen(),
    () => LeaveSummaryScreen(),
    () => TravelAllowanceSummary(),
    () => GalleryScreen(),
    () => ProfileScreen(),
  ];

  BottomNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        // Mark current index as visited
        navBarController.markVisited(navBarController.selectedIndex.value);

        return Stack(
          children: List.generate(pageBuilders.length, (index) {
            final visited = navBarController.visitedIndexes.contains(index);

            // Don't build if never visited
            if (!visited) return const SizedBox.shrink();

            return Offstage(
              offstage: navBarController.selectedIndex.value != index,
              child: TickerMode(
                enabled: navBarController.selectedIndex.value == index,
                child: pageBuilders[index](), // built once, reused after
              ),
            );
          }),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(
        navBarController: navBarController,
      ),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();
  var selectedIndex = 0.obs;

  // Track which tabs have been visited
  final RxSet<int> visitedIndexes = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Home is visited on launch
    markVisited(0);
  }

  void markVisited(int index) {
    if (!visitedIndexes.contains(index)) {
      visitedIndexes.add(index);
    }
  }

  void changeIndex(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      HapticFeedback.lightImpact();
    }
  }
}
