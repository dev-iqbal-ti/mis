import 'package:dronees/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TLoaders {
  static successSnackBar({
    required String title,
    String message = "",
    int duration = 3,
  }) {
    Get.snackbar(
      title, // We pass these but override with titleText/messageText for styling
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: duration),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      backgroundColor: const Color(
        0xFF10B981,
      ).withOpacity(0.95), // Emerald green
      colorText: Colors.white,
      borderRadius: 15,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,

      // Glassmorphism/Elevation effect
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],

      // Icon with a subtle background circle
      icon: Container(
        margin: EdgeInsets.only(left: 12.w),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          CupertinoIcons.check_mark,
          color: Colors.white,
          size: 20,
        ),
      ),

      titleText: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          fontFamily: "Poppins",
        ),
      ),

      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 13.sp,
          fontFamily: "Poppins",
          height: 1.4, // Better readability
        ),
      ),

      // Optional: Add a progress bar at the bottom
      showProgressIndicator: false,
      leftBarIndicatorColor: Colors.white, // Adds a nice thin line on the left
    );
  }

  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(
      '',
      '',
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(20.w),
      icon: Padding(
        padding: EdgeInsets.all(18.w),
        child: const Icon(
          CupertinoIcons.exclamationmark_circle,
          color: TColors.white,
          size: 30,
        ),
      ),
      titleText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: TextStyle(
            color: TColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          message,
          style: TextStyle(
            color: TColors.white,
            fontSize: 14.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      '',
      '',
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(20.w),
      icon: Padding(
        padding: EdgeInsets.all(18.w),
        child: const Icon(
          CupertinoIcons.exclamationmark_circle,
          color: TColors.white,
          size: 30,
        ),
      ),
      titleText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: TextStyle(
            color: TColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          message,
          style: TextStyle(
            color: TColors.white,
            fontSize: 14.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}
