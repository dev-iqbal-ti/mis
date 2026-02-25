import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:dronees/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;

  // Password Strength (0.0 to 1.0)
  var passwordStrength = 0.0.obs;
  var strengthText = "".obs;
  var strengthColor = Colors.transparent.obs;

  // Animation Controller for "Shake" effect
  late AnimationController shakeController;

  @override
  void onInit() {
    super.onInit();
    shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Listen to password changes for real-time strength updates
    newPasswordController.addListener(_updateStrength);
  }

  @override
  void onClose() {
    super.onClose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    shakeController.dispose();
  }

  void _updateStrength() {
    String p = newPasswordController.text;
    if (p.isEmpty) {
      passwordStrength.value = 0.0;
      strengthText.value = "";
    } else if (p.length < 6) {
      passwordStrength.value = 0.3;
      strengthText.value = "Weak";
      strengthColor.value = Colors.red;
    } else if (p.length < 10) {
      passwordStrength.value = 0.6;
      strengthText.value = "Medium";
      strengthColor.value = Colors.orange;
    } else {
      passwordStrength.value = 1.0;
      strengthText.value = "Strong";
      strengthColor.value = Colors.green;
    }
  }

  void validateAndSave() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      final data = {
        "oldPassword": oldPasswordController.text.trim(),
        "newPassword": newPasswordController.text.trim(),
        "confirmPassword": confirmPasswordController.text.trim(),
      };
      TLoggerHelper.customPrint(data.toString());

      final response = await THttpHelper.postRequest(
        API.postApis.changePassword,
        data,
      );

      if (response == null) {
        isLoading.value = false;
        return;
      }
      TLoaders.successSnackBar(title: "success", message: response["message"]);
      isLoading.value = false;
      Get.back();
    } else {
      // Trigger Shake Animation on Error
      shakeController.forward(from: 0.0);
    }
  }
}
