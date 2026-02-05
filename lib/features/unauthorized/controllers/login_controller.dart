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

  final emailController = TextEditingController(text: "jesmibano@gmail.com");
  final passwordController = TextEditingController(text: "Pass@123");
  RxBool obscure = RxBool(true);
  RxBool remember = RxBool(true);

  // Role selection
  var selectedRole = 'pilot'.obs;
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

      log(user.toString());
      // await Future.delayed(const Duration(seconds: 2));
      final response = await THttpHelper.postRequest(API.postApis.login, user);

      if (response == null) return;

      await AuthController.instance.setAuthUser(response);
      Get.offAll(() => BottomNavigator());
    } catch (e) {
      Get.snackbar('Error', 'Error: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    // Replace the current screen with the Register screen
    Get.offNamed('/register');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signIn() async {
    final form = formKey.currentState;

    if (form == null || !form.validate()) {
      debugPrint('❌ Validation failed');
      return;
    }

    isLoading.value = true;

    try {
      // final response = await AuthService.loginUser(
      //   emailOrPhone: emailController.text.trim(),
      //   password: passwordController.text.trim(),
      //   role: selectedRole.value,
      // );

      // Get.snackbar(
      //   'success',
      //   'Welcome back ${response['name']}!',
      //   snackPosition: SnackPosition.TOP,
      // );

      // Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      Get.snackbar('Error', 'Error: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
