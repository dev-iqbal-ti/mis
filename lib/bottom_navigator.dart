import 'package:dronees/features/authorized/attendance/screens/attendance_screen.dart';
import 'package:dronees/features/authorized/gallery/screens/gallery_screen.dart';
import 'package:dronees/features/authorized/home/screens/home_screen.dart';
import 'package:dronees/features/authorized/profile/screens/profile_screens.dart';
import 'package:dronees/features/authorized/travel_allowance/screens/travel_allowance_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BottomNavigator extends StatelessWidget {
  final NavigationController navBarController = Get.put(NavigationController());

  // Define your pages here
  final List<Widget> pages = [
    HomeScreen(),
    AttendanceScreen(),
    TravelAllowanceSummary(),
    GalleryScreen(),
    ProfileScreen(),
  ];

  BottomNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Matching your image background
      body: Obx(
        () => IndexedStack(
          index: navBarController.selectedIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
          ),
          child: BottomNavigationBar(
            currentIndex: navBarController.selectedIndex.value,
            onTap: navBarController.changeIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xFF121212), // Dark theme
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white38,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              _buildNavItem(Iconsax.home, 0),
              _buildNavItem(Iconsax.calendar_edit, 1),
              _buildNavItem(Iconsax.transaction_minus, 2),
              _buildNavItem(Iconsax.gallery, 3),
              _buildNavItem(Iconsax.profile_circle, 4),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          // White indicator line seen in your image
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: 2,
            width: navBarController.selectedIndex.value == index ? 12 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
      label: '',
    );
  }
}

class NavigationController extends GetxController {
  // Current selected tab index
  var selectedIndex = 0.obs;

  // Function to update the index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
