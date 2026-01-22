import 'dart:io';

import 'package:dronees/features/authorized/money_receive/models/money_record.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoneyReceiveController extends GetxController {
  final paymentFormKey = GlobalKey<FormState>();

  // Observables
  var receipts = <MoneyRecord>[].obs;
  var selectedProject = Rxn<String>();
  var selectedMode = Rxn<String>();
  var selectedImage = Rx<File?>(null);

  final amountController = TextEditingController();
  final remarkController = TextEditingController();

  // Errors for custom fields
  var showProjectError = false.obs;
  var showImageError = false.obs;

  double get totalCollected =>
      receipts.fold(0, (sum, item) => sum + double.parse(item.amount));

  void addRecord() {
    final isValid = paymentFormKey.currentState?.validate() ?? false;
    showProjectError.value = selectedProject.value == null;
    showImageError.value = selectedImage.value == null;

    if (isValid && !showProjectError.value && !showImageError.value) {
      receipts.insert(
        0,
        MoneyRecord(
          id: DateTime.now().toString(),
          projectName: selectedProject.value!,
          amount: amountController.text,
          mode: selectedMode.value!,
          remark: remarkController.text,
          date: "21 Jan 2026",
          imagePath: selectedImage.value?.path,
        ),
      );

      Get.back();
      _resetForm();
      Get.snackbar(
        "Success",
        "Payment report submitted",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _resetForm() {
    selectedProject.value = null;
    selectedMode.value = null;
    selectedImage.value = null;
    amountController.clear();
    remarkController.clear();
  }
}
