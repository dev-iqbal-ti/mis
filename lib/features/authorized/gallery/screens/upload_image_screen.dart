import 'package:dronees/features/authorized/gallery/controllers/gallery_controller.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';

class UploadImageScreen extends StatelessWidget {
  const UploadImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GalleryController());
    const primaryColor = Color(0xFF6C5CE7);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Slightly off-white background
      appBar: AppBar(
        title: const Text(
          'Upload Work',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Showcase your shot",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Text(
                "High-quality JPG or PNG works best.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // --- Preview Box ---
              Expanded(
                flex: 10,
                child: Obx(() {
                  final hasImage = controller.selectedFile.value != null;
                  return GestureDetector(
                    onTap: controller.isUploading.value
                        ? null
                        : () => controller.pickDocument(),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),

                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: hasImage
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    controller.selectedFile.value!,
                                    fit: BoxFit.cover,
                                  ),
                                  // Dark overlay for better button visibility
                                  Container(
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                  // Change Image Button
                                  Positioned(
                                    bottom: 15,
                                    right: 15,
                                    child: FloatingActionButton.extended(
                                      onPressed: controller.isUploading.value
                                          ? null
                                          : () => controller.pickDocument(),
                                      backgroundColor: Colors.white,
                                      label: const Text(
                                        "Change",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                      icon: const Icon(
                                        Iconsax.edit,
                                        color: primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // --- Progress Section ---
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.isUploading.value
                      ? _buildUploadProgress(controller.uploadProgress.value)
                      : const SizedBox(height: 80), // Maintain space
                ),
              ),

              const Spacer(),

              // --- Action Button ---
              Obx(
                () => Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    onPressed:
                        (controller.selectedFile.value == null ||
                            controller.isUploading.value)
                        ? null
                        : () => controller.uploadWorkImage(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      shadowColor: primaryColor.withOpacity(0.4),
                    ),
                    child: controller.isUploading.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.document_upload, size: 20),
                              SizedBox(width: 12),
                              Text(
                                'Upload to Gallery',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7).withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Lottie.asset(
            TImages.image_preview,
            height: 100,
            repeat: false,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tap to select image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'PNG, JPG up to 10MB',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildUploadProgress(double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Uploading...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${(progress * 100).toStringAsFixed(0)}%"),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFF6C5CE7),
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}
