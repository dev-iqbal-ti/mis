import 'dart:developer';
import 'dart:ui';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SubmitConfirmationSheet extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool cancelOutside;
  final String subtitle;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final Widget? child;

  const SubmitConfirmationSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.onConfirm,
    this.cancelOutside = true,
    this.child,
  });

  // Updated static show method to accept parameters
  static void show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String confirmButtonText,
    required String cancelButtonText,
    required VoidCallback onConfirm,
    bool cancelOutside = true,
    Widget? child,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: cancelOutside,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SubmitConfirmationSheet(
        icon: icon,
        title: title,
        subtitle: subtitle,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: onConfirm,
        cancelOutside: cancelOutside,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              log("on clicked blur area");
              // cancelOutside ? Navigator.pop(context) : null
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: const SizedBox.shrink(),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.fromLTRB(
            TSizes.defaultPadding,
            60,
            TSizes.defaultPadding,
            40,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title, // Dynamic Title
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                subtitle, // Dynamic Subtitle
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Child Widget
              if (child != null)
                Column(
                  children: [
                    child!,
                    const SizedBox(height: TSizes.minSpaceBtw),
                  ],
                ),

              // Primary Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close sheet
                    onConfirm(); // Trigger callback
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF703EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    confirmButtonText, // Dynamic Text
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Secondary Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF703EFF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    cancelButtonText, // Dynamic Text
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF703EFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF8A59FF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8A59FF).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 40), // Dynamic Icon
          ),
        ),
      ],
    );
  }
}
