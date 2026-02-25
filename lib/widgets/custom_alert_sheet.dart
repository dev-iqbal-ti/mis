import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomAlertSheet extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onAction;
  final IconData? icon;
  final Color? accentColor;

  const CustomAlertSheet({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onAction,
    this.icon = Icons.info_outline_rounded,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    // Default to theme primary color if no accent color is provided
    final Color themeColor = accentColor ?? Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultPadding,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. The Modern Handle/Grabber
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // 2. The Illustrative Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: themeColor),
          ),
          const SizedBox(height: 24),

          // 3. Typography
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // 4. The High-Emphasis Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Padding for gesture navigation bars
        ],
      ),
    );
  }
}
