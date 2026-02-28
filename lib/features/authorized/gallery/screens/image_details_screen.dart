import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/gallery/models/gallery_item.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/helpers/share_healper.dart';
import 'package:dronees/widgets/confirm_sheet.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailScreen extends StatelessWidget {
  final Rxn<GalleryItem> selectedItem;
  final RxList<GalleryItem> detailsItems;
  final void Function(int) onConformDelete;
  final bool showHero;

  final PhotoViewScaleStateController _photoViewScaleController =
      PhotoViewScaleStateController();

  ImageDetailScreen({
    super.key,
    required this.selectedItem,
    required this.detailsItems,
    required this.onConformDelete,
    required this.showHero,
  });

  void _resetPhotoScale() {
    _photoViewScaleController.scaleState = PhotoViewScaleState.initial;
  }

  @override
  Widget build(BuildContext context) {
    // final controller = GalleryController.instance;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // --- Main Center Image ---
            Center(
              child: Obx(
                () => Hero(
                  tag: !showHero ? "" : selectedItem.value!.id,
                  child: PhotoView(
                    scaleStateController: _photoViewScaleController,
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                  (event.expectedTotalBytes ?? 1),
                      ),
                    ),
                    errorBuilder: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                            size: 30,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Unavailable",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    imageProvider: CachedNetworkImageProvider(
                      selectedItem.value!.imageUrl,
                    ),
                  ),
                ),
              ),
            ),

            // --- Top Navigation Bar ---
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(
                            0.4,
                          ), // Semi-transparent black
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(
                              0.2,
                            ), // Subtle light border
                            width: 0.5,
                          ),
                        ),
                        // Adding a slight blur effect makes it look premium
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: const Center(
                              child: Icon(
                                Iconsax.arrow_left_2_copy,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Bottom Controls Container ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- 1. Thumbnail Strip ---
                  SizedBox(
                    height: 60,
                    child: Obx(
                      () => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: detailsItems.length,
                        itemBuilder: (context, index) {
                          final item = detailsItems[index];

                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _resetPhotoScale();
                              selectedItem.value = item;
                              detailsItems.refresh();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                border: item.id == selectedItem.value?.id
                                    ? Border.all(color: Colors.yellow, width: 2)
                                    : null,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 50,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- 2. Bottom Action Bar (Matches image style) ---
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C), // Dark grey background
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Obx(() {
                      final isOwner =
                          selectedItem.value!.userId ==
                          AuthController.instance.authUser?.userDetails.id;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildBottomIcon(
                            CupertinoIcons.share,
                            "Share",
                            () async {
                              await ShareHelper.shareImage(
                                imageUrl: selectedItem.value!.imageUrl,
                                text: 'Shared by ${selectedItem.value!.name}',
                                context: context,
                              );
                            },
                          ),

                          _buildBottomIcon(
                            CupertinoIcons.info_circle,
                            "Info",
                            () {
                              // Show info dialogue
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Image Info"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Name: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: selectedItem.value!.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Date: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  DateFormat(
                                                    "dd MMMM yyyy : hh:mm",
                                                  ).format(
                                                    selectedItem
                                                        .value!
                                                        .createdAt,
                                                  ),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          if (isOwner)
                            _buildBottomIcon(
                              CupertinoIcons.delete,
                              iconColor: TColors.error,
                              "Delete",
                              () async {
                                CustomBlurBottomSheet.show(
                                  context,
                                  widget: ConfirmSheet(
                                    icon: CupertinoIcons.delete,
                                    themeColor: TColors.error,
                                    confirmText: "Yes, Delete",
                                    title: "Delete",
                                    description:
                                        "Are you sure you want to delete this image. This action cannot be undone.",
                                    onConfirm: () =>
                                        onConformDelete(selectedItem.value!.id),
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcon(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color iconColor = Colors.white70,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: iconColor, size: 26),
      tooltip: label,
    );
  }
}
