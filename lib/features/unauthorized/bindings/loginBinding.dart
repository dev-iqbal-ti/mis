import 'package:dronees/features/unauthorized/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Register controller when /login route is opened
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
