import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dronees/features/unauthorized/screens/login_screen.dart';
import 'package:dronees/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  User? authUser;
  final isLoggedIn = false.obs;
  final GetStorage deviceStorage = GetStorage();

  Future<void> setAuthUser(Map<String, dynamic> user) async {
    authUser = userFromJson(jsonEncode(user));
    await deviceStorage.write('droneesUser', user);
    isLoggedIn.value = true;
  }

  void logout() {
    authUser = null;
    isLoggedIn.value = false;
    deviceStorage.remove('droneesUser');
    Get.offAll(() => const LoginScreen());
  }

  Future<String> initAuthUser() async {
    final userData = await deviceStorage.read('droneesUser');
    developer.log(userData.toString());
    if (userData == null) {
      isLoggedIn.value = false;
      return "No User";
    }
    try {
      authUser = userFromJson(jsonEncode(userData));
      isLoggedIn.value = true;
      return "User";
    } catch (e) {
      developer.log("initAuthUser: $e");
      return 'No User';
    }
  }
}
