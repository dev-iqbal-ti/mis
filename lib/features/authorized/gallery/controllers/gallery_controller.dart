import 'dart:io';
import 'package:dronees/features/authorized/gallery/models/gallery_item.dart';
import 'package:dronees/features/authorized/gallery/screens/image_details_screen.dart';
import 'package:dronees/features/authorized/home/controllers/home_controller.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:dronees/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GalleryController extends GetxController {
  static GalleryController get instance => Get.find();

  Rxn<Map<String, List<GalleryItem>>> groupedItems =
      Rxn<Map<String, List<GalleryItem>>>(null);

  RxList<GalleryItem> allItems = <GalleryItem>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;

  final Rxn<GalleryItem> selectedItem = Rxn<GalleryItem>(null);
  RxList<GalleryItem> detailsItems = <GalleryItem>[].obs;

  // Pagination
  RxInt currentPage = 1.obs;
  final int pageSize = 20;

  var uploadProgress = 0.0.obs;
  var isUploading = false.obs;
  Rxn<File> selectedFile = Rxn<File>();

  // ScrollController for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchGalleryItems();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore.value &&
          hasMoreData.value) {
        loadMoreItems();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void navigateToImageDetails(List<GalleryItem> items, GalleryItem item) {
    selectedItem.value = item;
    detailsItems.value = items;
    Get.to(
      () => ImageDetailScreen(
        selectedItem: selectedItem,
        detailsItems: detailsItems,
        onConformDelete: (int p1) {
          deleteImage(p1);
        },
        showHero: true,
      ),
    );
  }

  Future<void> fetchGalleryItems({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
      }

      isLoading.value = true;

      final response = await THttpHelper.getRequest(
        API.getApis.getGallery,
        queryParams: {
          'page': currentPage.value.toString(),
          'limit': pageSize.toString(),
        },
      );

      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final pagination = response['pagination'];

        if (isRefresh) {
          allItems.clear();
        }

        // Parse items
        final items = data.map((json) => GalleryItem.fromJson(json)).toList();
        allItems.addAll(items);

        // Check if more data available
        if (pagination != null) {
          final totalPages = pagination['totalPages'] ?? 1;
          hasMoreData.value = currentPage.value < totalPages;
        }

        // Group items by date
        groupedItems.value = groupItemsByDate(allItems);
      }
    } catch (e) {
      print('Error fetching gallery items: $e');
      Get.snackbar(
        'Error',
        'Failed to load gallery items',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load more items (pagination)
  Future<void> loadMoreItems() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await THttpHelper.getRequest(
        API.getApis.getGallery,
        queryParams: {
          'page': currentPage.value.toString(),
          'limit': pageSize.toString(),
        },
      );

      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final pagination = response['pagination'];

        // Parse and add new items
        final items = data.map((json) => GalleryItem.fromJson(json)).toList();
        allItems.addAll(items);

        // Update grouped items
        groupedItems.value = groupItemsByDate(allItems);

        // Check if more data available
        if (pagination != null) {
          final totalPages = pagination['totalPages'] ?? 1;
          hasMoreData.value = currentPage.value < totalPages;
        }
      }
    } catch (e) {
      print('Error loading more items: $e');
      currentPage.value--; // Revert page increment on error
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Refresh data
  Future<void> refreshGalleryItems() async {
    await fetchGalleryItems(isRefresh: true);
  }

  // Reset progress and image
  void resetUpload() {
    selectedFile.value = null;
    uploadProgress.value = 0.0;
    isUploading.value = false;
  }

  // Upload Logic
  Future<void> uploadWorkImage() async {
    if (selectedFile.value == null) return;

    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;

      // Replace with your actual endpoint and base logic
      final response = await THttpHelper.uploadImageWithProgress(
        endpoint: API.postApis.uploadImage,
        file: selectedFile.value!,
        onProgress: (progress) {
          uploadProgress.value = progress;
        },
      );

      if (response != null) {
        resetUpload();
        refreshGalleryItems();
        Get.back();
        TLoaders.successSnackBar(
          title: "Success",
          message: "Image uploaded to gallery!",
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: "Upload Failed", message: e.toString());
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> deleteImage(int id) async {
    final response = await THttpHelper.deleteRequest(
      API.deleteApis.deleteImage(id),
    );

    if (response == null) {
      return;
    }
    TLoggerHelper.customPrint(response.toString());
    if (response["success"] == true) {
      // remove image from the list and select next eitheir from left or right and if no image left go back.
      // Find index of current item
      final index = detailsItems.indexWhere((item) => item.id == id);

      if (index != -1) {
        // Remove the item
        detailsItems.removeAt(index);

        if (detailsItems.isNotEmpty) {
          // Prefer selecting next (right side)
          final newIndex = index < detailsItems.length
              ? index
              : detailsItems.length - 1;

          selectedItem.value = detailsItems[newIndex];
        } else {
          // No items left → go back
          Get.back();
        }
      }

      HomeController.to.removeImageAtIndex(id);

      // Remove from master list
      allItems.removeWhere((item) => item.id == id);

      // Regroup
      groupedItems.value = groupItemsByDate(allItems);

      // Get.back();
      TLoaders.successSnackBar(
        title: "Success",
        message: "Image Deleted Successfully",
      );
    }
  }

  void removeImageAtIndex(int id) {
    TLoggerHelper.customPrint("removeImageAtIndex $id");
    final index = allItems.indexWhere((item) => item.id == id);
    TLoggerHelper.customPrint("removeImageAtIndex $index");

    if (index != -1) {
      // Remove the item
      allItems.removeAt(index);
      // allItems.refresh();
      groupedItems.value = groupItemsByDate(allItems);
      groupedItems.refresh();
    }
  }

  Future<void> pickDocument() async {
    final source = await Get.bottomSheet<ImageSource>(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Source",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                sourceTile(Icons.camera_alt, "Camera", ImageSource.camera),
                const SizedBox(width: 16),
                sourceTile(Icons.photo_library, "Gallery", ImageSource.gallery),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    if (source == null) return;

    final file = await ImageUploadService.pickImageFromSource(source);

    if (file != null) {
      selectedFile.value = file;
    }
  }

  Widget sourceTile(IconData icon, String title, ImageSource source) {
    return Expanded(
      child: InkWell(
        onTap: () => Get.back(result: source),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1EFFF), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C5CE7).withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFF1EFFF),
                child: Icon(icon, color: const Color(0xFF6C5CE7), size: 30),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // How to call it in your BottomSheet/Dialog:
  Widget buildSourcePicker() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          sourceTile(Icons.camera_alt_outlined, "Camera", ImageSource.camera),
          const SizedBox(width: 16), // Space between buttons
          sourceTile(Icons.image_outlined, "Gallery", ImageSource.gallery),
        ],
      ),
    );
  }
}
