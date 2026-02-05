import 'dart:developer';
import 'dart:io';

import 'package:dronees/utils/logging/logger.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  // Maximum allowed file size (10 MB)
  // ignore: constant_identifier_names
  static const int MAX_FILE_SIZE = 10 * 1024 * 1024;

  // Select multiple images from gallery with size validation
  static Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFiles != null) {
        // Filter out images larger than 10 MB
        return pickedFiles
            .where((file) => File(file.path).lengthSync() <= MAX_FILE_SIZE)
            .map((file) => File(file.path))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error picking multiple images: $e');
      return [];
    }
  }

  static Future<File?> pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        if (await file.length() <= MAX_FILE_SIZE) {
          return file;
        } else {
          TLoggerHelper.customPrint("File size exceeds 10MB limit.");
          return null;
        }
      }
      return null;
    } catch (e) {
      TLoggerHelper.customPrint('Error picking image: $e');
      return null;
    }
  }

  // Take photo using camera with size validation
  static Future<Object?> takePhoto({xFile = false}) async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (photo != null) {
        if (xFile) {
          return photo;
        }
        log(photo.path);
        File file = File(photo.path);
        return file.lengthSync() <= MAX_FILE_SIZE ? file : null;
      }
      return null;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  static Future<List<File>> selectAndUploadImages({
    required ImageSource source,
  }) async {
    List<File> selectedImages = [];

    // Select images based on source
    if (source == ImageSource.gallery) {
      selectedImages = await pickMultipleImages();
      TLoggerHelper.customPrint(selectedImages[0].path);
    } else {
      final Object? photo = await takePhoto();
      if (photo != null && photo is File) {
        selectedImages.add(photo);
      }
    }
    return selectedImages;
  }
}
