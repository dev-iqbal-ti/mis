import 'package:dronees/features/authorized/gallery/models/gallery_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                child: Image.network(currentItem.imageUrl, fit: BoxFit.contain),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBottomIcon(CupertinoIcons.share, "Share", () {}),
                        _buildBottomIcon(
                          CupertinoIcons.heart,
                          "Favorite",
                          () {},
                        ),

                        _buildBottomIcon(CupertinoIcons.info_circle, "Info", () {
                          // Show info dialogue
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Image Info"),
                              content: Text(
                                "Created: ${DateFormat('yyyy-MM-dd HH:mm').format(currentItem.creationDate)}",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("Close"),
                                ),
                              ],
                            ),
                          );
                        }),
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

  Widget _buildBottomIcon(IconData icon, String label, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white70, size: 26),
      tooltip: label,
    );
  }
}
