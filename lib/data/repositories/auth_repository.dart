import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/routes/appRoute.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final GetStorage deviceStorage = GetStorage();

  @override
  void onReady() {
    initializeApp();
  }

  Future<void> initializeApp() async {
    final String data = await AuthController.instance.initAuthUser();

    if (data == "User") {
      Get.offAllNamed(AppRoutes.HOME);
    } else if (data == "Name Required") {
      // Get.offAll(() => const LetsGetStartedScreen());
    } else {
      print("No User");
      // Get.offAllNamed("/welcome");
      // Get.offAll(() => const WelcomeScreen());
    }
    await Future.delayed(const Duration(milliseconds: 500));
    FlutterNativeSplash.remove();
  }
}
