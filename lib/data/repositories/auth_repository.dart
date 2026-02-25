import 'package:dronees/bottom_navigator.dart';
import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/unauthorized/screens/onboarding_screen.dart';
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
      Get.offAll(() => BottomNavigator());
    } else {
      print("No User");
      Get.offAll(() => const OnboardingScreen());
    }
    await Future.delayed(const Duration(milliseconds: 500));
    FlutterNativeSplash.remove();
  }
}
