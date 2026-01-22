// import 'package:dronees/features/authorized/gallery/models/gallery_item.dart';
// import 'package:dronees/features/authorized/gallery/screens/image_details_screen.dart';
// import 'package:dronees/utils/constants/sizes.dart';
// import 'package:dronees/utils/device/device_utility.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// // Ensure you import the file where your data models are defined above

// class GalleryScreen extends StatefulWidget {
//   const GalleryScreen({super.key});

//   @override
//   State<GalleryScreen> createState() => _GalleryScreenState();
// }

// class _GalleryScreenState extends State<GalleryScreen> {
//   late Map<String, List<GalleryItem>> groupedData;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize and group the data
//     groupedData = groupItemsByDate(mockGalleryItems);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text("Photos", style: TextStyle(color: Colors.black)),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.more_horiz, color: Colors.black),
//           ),
//         ],
//       ),
//       // CustomScrollView is necessary for mixing different sliver types
//       body: CustomScrollView(slivers: _buildSlivers()),
//     );
//   }

//   List<Widget> _buildSlivers() {
//     List<Widget> slivers = [];

//     // Iterate through the grouped data map
//     groupedData.forEach((dateHeader, items) {
//       // 1. Add the Date Header Sliver
//       slivers.add(
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               dateHeader,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       );

//       // 2. Add the Staggered Grid Sliver for this section's items
//       slivers.add(
//         SliverPadding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           sliver: SliverMasonryGrid.count(
//             crossAxisCount: 3, // Adjust number of columns
//             mainAxisSpacing: 4,
//             crossAxisSpacing: 4,
//             childCount: items.length,
//             itemBuilder: (context, index) {
//               final item = items[index];
//               return GestureDetector(
//                 onTap: () {
//                   // Navigate to detail screen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ImageDetailScreen(
//                         selectedItem: item,
//                         allItems:
//                             mockGalleryItems, // Pass all for thumbnail strip
//                       ),
//                     ),
//                   );
//                 },
//                 // Hero widget for smooth transition animation
//                 child: Hero(
//                   tag: item.id,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       item.imageUrl,
//                       fit: BoxFit.cover,
//                       // Using aspect ratio controller to define staggered height
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     });

//     // Add bottom spacing equal to bottom button height + padding
//     slivers.add(
//       SliverToBoxAdapter(
//         child: SizedBox(
//           height:
//               TDeviceUtils.getBottomNavigationBarHeight(), // spacing + button height + padding
//         ),
//       ),
//     );

//     return slivers;
//   }
// }

import 'dart:io';

import 'package:dronees/features/authorized/gallery/models/gallery_item.dart';
import 'package:dronees/features/authorized/gallery/screens/image_details_screen.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/device/device_utility.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Map<String, List<GalleryItem>> groupedData;

  @override
  void initState() {
    super.initState();
    // Initialize and group the data
    groupedData = groupItemsByDate(mockGalleryItems);
  }

  @override
  Widget build(BuildContext context) {
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

            // Content Section
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: const Color(0xFFF5F6FA),
                  child: CustomScrollView(
                    physics: ClampingScrollPhysics(),
                    slivers: _buildSlivers(),
                  ),
                ),
              ),
            ),

            // Bottom Button (inside SafeArea now)
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Get.to(() => SubmitTravelAllowance());
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
        child: Icon(Iconsax.gallery_export, size: 30),
      ),
    );
  }

  List<Widget> _buildSlivers() {
    List<Widget> slivers = [];

    // Check if empty
    if (groupedData.isEmpty) {
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
    groupedData.forEach((dateHeader, items) {
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
                        allItems: mockGalleryItems,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: item.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade200,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: const Color(0xFF6C5CE7),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Iconsax.gallery_slash,
                            color: Colors.grey.shade400,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });

    // Add bottom spacing for better scroll experience
    slivers.add(
      SliverToBoxAdapter(
        child: SizedBox(
          height: 16, // spacing + button height + padding
        ),
      ),
    );
    return slivers;
  }
}
