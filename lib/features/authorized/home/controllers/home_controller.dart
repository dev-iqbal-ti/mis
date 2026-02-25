import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxString fullName = ''.obs;
  RxString initails = "".obs;
  @override
  void onInit() {
    super.onInit();
    fullName.value = AuthController.instance.fullName.value;
    if (fullName.split(" ").length > 1) {
      final splitName = fullName.split(" ");
      initails.value =
          splitName[0][0].toUpperCase() + splitName[1][0].toUpperCase();
    } else {
      initails.value = fullName.split("")[0];
    }
    TLoggerHelper.customPrint(fullName.value);
    // ever(AuthController.instance.fullName, (value) {
    //   print("ControllerB received update: $value");
    // });
  }
}
