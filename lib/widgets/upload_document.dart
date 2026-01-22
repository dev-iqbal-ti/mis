import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class UploadDocument extends StatelessWidget {
  const UploadDocument({
    super.key,
    this.errorText,
    this.subTitle = 'Format should be in .jpeg .png less than 5MB',
    this.title = 'Upload Photo',
    this.field,
  });

  final String? errorText;
  final String title;
  final String? subTitle;
  final FormFieldState? field;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(TSizes.defaultPadding),
          decoration: BoxDecoration(
            color: field?.hasError ?? false
                ? TColors.error.withAlpha(30)
                : const Color(0xFFF8F7FF),
            borderRadius: BorderRadius.circular(16),

            // Show red border if there is an error
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: field?.hasError ?? false
                      ? TColors.error.withAlpha(50)
                      : Color(0xFFEDE7FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.paperclip_2_copy,
                  color: field?.hasError ?? false
                      ? TColors.error
                      : Color(0xFF6C5CE7),
                  size: 32,
                ),
              ),
              const SizedBox(height: TSizes.minSpaceBtw),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: field?.hasError ?? false
                      ? TColors.error
                      : Color(0xFF6C5CE7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subTitle ?? 'Format should be in .jpeg .png less than 5MB',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Display validation error text below the container
      ],
    );
  }
}
