import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dronees/features/authorized/gallery/models/gallery_item.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
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

            sourceTile(Icons.camera_alt, "Camera", ImageSource.camera),
            sourceTile(Icons.photo_library, "Gallery", ImageSource.gallery),
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
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF1EFFF),
        child: Icon(icon, color: const Color(0xFF6C5CE7)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () {
        Get.back(result: source);
      },
    );
  }
}
