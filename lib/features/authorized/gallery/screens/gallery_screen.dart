import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dronees/features/authorized/gallery/controllers/gallery_controller.dart';
import 'package:dronees/features/authorized/gallery/screens/image_details_screen.dart';
import 'package:dronees/features/authorized/gallery/screens/upload_image_screen.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GalleryController controller = Get.put(GalleryController());

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
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gallery',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Keep all your images in one place.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
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
                        Iconsax.gallery,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section with Pull-to-Refresh
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: const Color(0xFFF5F6FA),
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.allItems.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6C5CE7),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: const Color(0xFF6C5CE7),
                      onRefresh: controller.refreshGalleryItems,
                      child: CustomScrollView(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: _buildSlivers(controller),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Get.to(() => const UploadImageScreen());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C5CE7),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0xFF6C5CE7).withOpacity(0.4),
          padding: const EdgeInsets.all(16),
          side: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Icon(Iconsax.gallery_export, size: 30),
      ),
    );
  }

  List<Widget> _buildSlivers(GalleryController controller) {
    List<Widget> slivers = [];

    // Check if empty
    if (controller.groupedItems.value == null ||
        controller.groupedItems.value!.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.gallery, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No images yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your gallery is empty',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
      );
      return slivers;
    }

    // Iterate through the grouped data map
    controller.groupedItems.value!.forEach((dateHeader, items) {
      // 1. Add the Date Header Sliver
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              dateHeader,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
        ),
      );

      // 2. Add the Staggered Grid Sliver for this section's items
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageDetailScreen(
                        selectedItem: item,
                        allItems: items,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: item.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.thumbnailUrl,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                      errorWidget: (context, url, error) => Container(
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
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });

    // Add loading indicator at bottom when loading more
    if (controller.isLoadingMore.value) {
      slivers.add(
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C5CE7),
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      );
    }

    // Add bottom spacing for better scroll experience
    slivers.add(
      const SliverToBoxAdapter(
        child: SizedBox(height: 80), // spacing + button height + padding
      ),
    );

    return slivers;
  }
}
