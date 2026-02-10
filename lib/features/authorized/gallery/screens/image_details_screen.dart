import 'package:cached_network_image/cached_network_image.dart';
import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/gallery/models/gallery_item.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/helpers/share_healper.dart';
import 'package:dronees/widgets/confirm_sheet.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ImageDetailScreen extends StatefulWidget {
  final GalleryItem selectedItem;

  final List<GalleryItem> allItems;

  const ImageDetailScreen({
    super.key,
    required this.selectedItem,
    required this.allItems,
  });

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  late GalleryItem currentItem;

  @override
  void initState() {
    super.initState();
    currentItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // --- Main Center Image ---
            Center(
              child: Hero(
                tag: currentItem.id,
                child: CachedNetworkImage(
                  imageUrl: currentItem.imageUrl,

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
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: widget.allItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.allItems[index];
                        final isSelected = item.id == currentItem.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentItem = item;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              border: isSelected
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBottomIcon(
                          CupertinoIcons.share,
                          "Share",
                          () async {
                            await ShareHelper.shareImage(
                              imageUrl: currentItem.imageUrl,
                              text: 'Shared by ${currentItem.name}',
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
                                            text: currentItem.name,
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
                                            text: DateFormat(
                                              "dd MMMM yyyy : hh:mm",
                                            ).format(currentItem.createdAt),
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
                        if (currentItem.userId ==
                            AuthController.instance.authUser?.userDetails.id)
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
                                  onConfirm: () {},
                                ),
                              );
                            },
                          ),
                      ],
                    ),
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
