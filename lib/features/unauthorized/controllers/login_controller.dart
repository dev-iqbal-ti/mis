import 'dart:convert';
import 'dart:developer';

import 'package:dronees/bottom_navigator.dart';
import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final formKey = GlobalKey<FormState>();

  // final emailController = TextEditingController(
  //   text: "iqbal.khan786@gmail.com",
  // );
  // final passwordController = TextEditingController(text: "Password@123");
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool obscure = RxBool(true);
  RxBool remember = RxBool(true);

  // Role selection
  RxBool showPassword = RxBool(false);

  // Loading state
  var isLoading = false.obs;

  // Sign-up logic
  Future<void> login() async {
    final form = formKey.currentState;

    if (form == null || !form.validate()) {
      debugPrint('❌ Validation failed');
      return;
    }

    isLoading.value = true;

    try {
      final user = {
        "username": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "platform": "mobile",
      };

      final response = await THttpHelper.postRequest(API.postApis.login, user);

      if (response == null) return;

      await AuthController.instance.setAuthUser(
        response,
        remember: remember.value,
      );
      Get.offAll(() => BottomNavigator());
    } catch (e) {
      Get.snackbar('Error', 'Error: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
