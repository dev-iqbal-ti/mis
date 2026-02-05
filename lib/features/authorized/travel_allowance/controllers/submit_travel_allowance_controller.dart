import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dronees/features/authorized/travel_allowance/controllers/travel_allowsnce_controller.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubmitTravelAllowanceController extends GetxController {
  final amountController = TextEditingController();
  final purposeController = TextEditingController();
  Rxn<DateTime> selectedDate = Rxn<DateTime>(DateTime.now());
  final selectedFile = Rx<File?>(null);
  final taType = 'Normal'.obs; // 'Normal' | 'Advance'
  final Rxn<String> tourType = Rxn<String>(null);
  final isSubmitting = false.obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ── NEW TextEditingControllers ────────────────────────────────────────────
  final TextEditingController otherSpecifyController = TextEditingController();
  final TextEditingController fromLocationController = TextEditingController();
  final TextEditingController toLocationController = TextEditingController();
  final TextEditingController totalEstimatedExpenseController =
      TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();

  // ── NEW date observables (advance dates) ──────────────────────────────────
  final departureDate = Rx<DateTime?>(null);
  final returnDate = Rx<DateTime?>(null);

  // ── NEW boolean observables ───────────────────────────────────────────────
  final accommodationRequired = false.obs;
  final advanceRequired = false.obs;

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

    // new controllers
    otherSpecifyController.dispose();
    fromLocationController.dispose();
    toLocationController.dispose();
    totalEstimatedExpenseController.dispose();
    advanceAmountController.dispose();
    super.onClose();
  }

  Future<void> submitAllowance() async {
    Map<String, dynamic> payload = {
      'ta_type': taType.value,
      'tour_type': tourType.value,
      'purpose': purposeController.text.trim(),
    };

    // ── other_specify (only when tour_type == 'Other') ───────────────────
    if (tourType.value == 'Other') {
      payload['other_specify'] = otherSpecifyController.text.trim();
    }

    if (taType.value == 'Normal') {
      payload["transation_date"] = DateFormat(
        'yyyy-MM-dd',
      ).format(selectedDate.value!);
      payload["amount"] = double.tryParse(amountController.text.trim()) ?? 0;
    }

    // ── advance details (only when ta_type == 'Advance') ─────────────────
    if (taType.value == 'Advance') {
      payload = {
        ...payload,
        'from_location': fromLocationController.text.trim(),
        'to_location': toLocationController.text.trim(),
        'departure_date': departureDate.value?.toIso8601String(),
        'return_date': returnDate.value?.toIso8601String(),
        'accommodation_required': accommodationRequired.value,
        'advance_required': advanceRequired.value,
        'total_estimated_expense':
            double.tryParse(totalEstimatedExpenseController.text.trim()) ?? 0,
        'advance_amount':
            double.tryParse(advanceAmountController.text.trim()) ?? 0,
      };
    }

    final response = await THttpHelper.formDataRequest(
      API.postApis.submitAllowance,
      selectedFile.value,
      payload,
    );

    // log(response.toString());
    if (response == null) return;
    TravelAllowanceController.instance.refreshAllowances();
    formKey.currentState!.reset();

    Get.back();
  }
}
