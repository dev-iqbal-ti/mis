// import 'package:dronees/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final isLoading = false.obs;

  Future<void> refreshProfile() async {
    isLoading.value = true;
    // Simulate API Fetch
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    update(); // Triggers UI refresh
  }
}
