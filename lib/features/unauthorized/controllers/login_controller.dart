import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Role selection
  var selectedRole = 'pilot'.obs;
  RxBool showPassword = RxBool(false);

  // Loading state
  var isLoading = false.obs;

  // Sign-up logic
  Future<void> signUp() async {
    final form = formKey.currentState;

    if (form == null || !form.validate()) {
      debugPrint('❌ Validation failed');
      return;
    }

    isLoading.value = true;

    try {
      final user = (
        userName: usernameController.text.trim(),
        emailOrPhone: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: selectedRole.value,
      );

      await Future.delayed(const Duration(seconds: 1)); // mock async call

      Get.snackbar(
        'Success',
        'Signup successful for ${user.userName}!',
        snackPosition: SnackPosition.TOP,
      );

      // Get.offAllNamed(AppRoutes.HOME);
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
    usernameController.dispose();
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
