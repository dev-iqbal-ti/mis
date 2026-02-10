import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class ShareHelper {
  /// Share image from network URL
  static Future<void> shareImage({
    required String imageUrl,
    String? text,
    BuildContext? context,
  }) async {
    try {
      // Show loading indicator
      if (context != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
          ),
        );
      }

      // Download image to temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = imageUrl.split('/').last;
      final filePath = '${tempDir.path}/$fileName';

      // Download using Dio
      final dio = Dio();
      await dio.download(
        imageUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
              'Download progress: ${(received / total * 100).toStringAsFixed(0)}%',
            );
          }
        },
      );

      // Close loading dialog
      if (context != null && context.mounted) {
        Navigator.pop(context);
      }

      // Share the image
      final xFile = XFile(filePath);
      await Share.shareXFiles([
        xFile,
      ], text: text ?? 'Check out this image from Gallery');
    } catch (e) {
      // Close loading dialog on error
      if (context != null && context.mounted) {
        Navigator.pop(context);
      }

      print('Error sharing image: $e');

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Share multiple images
  static Future<void> shareMultipleImages({
    required List<String> imageUrls,
    String? text,
    BuildContext? context,
  }) async {
    try {
      // Show loading indicator
      if (context != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
          ),
        );
      }

      final tempDir = await getTemporaryDirectory();
      final dio = Dio();
      List<XFile> xFiles = [];

      // Download all images
      for (var imageUrl in imageUrls) {
        final fileName = imageUrl.split('/').last;
        final filePath = '${tempDir.path}/$fileName';

        await dio.download(imageUrl, filePath);
        xFiles.add(XFile(filePath));
      }

      // Close loading dialog
      if (context != null && context.mounted) {
        Navigator.pop(context);
      }

      // Share all images
      await Share.shareXFiles(
        xFiles,
        text: text ?? 'Check out these images from Gallery',
      );
    } catch (e) {
      // Close loading dialog on error
      if (context != null && context.mounted) {
        Navigator.pop(context);
      }

      print('Error sharing images: $e');

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share images: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
