import 'dart:io';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class TravelAllowanceController extends GetxController {
  final amountController = TextEditingController();
  final purposeController = TextEditingController();
  final selectedDate = DateTime.now().obs;
  final selectedFile = Rx<File?>(null);
  final isSubmitting = false.obs;

  final ImagePicker _picker = ImagePicker();

  void setDate(DateTime date) {
    selectedDate.value = date;
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

  Future<void> pickDocument(FormFieldState<File> field) async {
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
      field.didChange(file);
    }
  }

  Future<void> submitAllowance() async {
    try {
      isSubmitting.value = true;

      final payload = {
        "date": selectedDate.value.toIso8601String(),
        "amount": amountController.text.trim(),
        "purpose": purposeController.text.trim(),
      };

      final file = selectedFile.value!;

      // TODO: Send to API
      await uploadToServer(payload, file);

      Get.snackbar("Success", "Travel allowance submitted successfully");

      clearForm();
    } catch (e) {
      Get.snackbar("Error", "Failed to submit allowance");
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearForm() {
    amountController.clear();
    purposeController.clear();
    selectedFile.value = null;
    selectedDate.value = DateTime.now();
  }

  Future<void> uploadToServer(Map data, File file) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void onClose() {
    amountController.dispose();
    purposeController.dispose();
    super.onClose();
  }
}
